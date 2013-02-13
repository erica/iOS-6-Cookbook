/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define BARBUTTON_TARGET(TARGET, TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]

#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR] 
#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CONSTRAIN(VIEW, FORMAT)     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]

#define DATAPATH [NSHomeDirectory() stringByAppendingFormat:@"/Library/data.txt"]


@interface TestBedViewController : UIViewController <UITextViewDelegate>
{
	UITextView *textView;
	UIToolbar *toolbar;
    
    NSArray *currentVerticalConstraints;

}
@end

@implementation TestBedViewController

// Store data out to file
- (void) archiveData
{
	[textView.text writeToFile:DATAPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// Update the undo and redo button states
- (void)textViewDidChange:(UITextView *)textView
{
	[self loadAccessoryView];
}

// Choose which items to enable and disable on the toolbar
- (void) loadAccessoryView
{
	NSMutableArray *items = [NSMutableArray array];
	UIBarButtonItem *spacer = SYSBARBUTTON(UIBarButtonSystemItemFixedSpace, nil);
	spacer.width = 20.0f;
    
	BOOL canUndo = [textView.undoManager canUndo];
    UIBarButtonItem *undoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, textView.undoManager, @selector(undo));
    undoItem.enabled = canUndo;
    [items addObject:undoItem];
    
	BOOL canRedo = [textView.undoManager canRedo];
    UIBarButtonItem *redoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, textView.undoManager, @selector(redo));
    redoItem.enabled = canRedo;
    [items addObject:redoItem];
    
    // Add select all
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
    [items addObject:BARBUTTON_TARGET(textView, @"Sel", @selector(selectAll:))];

    // Add style buttons
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
    [items addObject:BARBUTTON_TARGET(textView, @"B", @selector(toggleBoldface:))];
    [items addObject:BARBUTTON_TARGET(textView, @"I", @selector(toggleItalics:))];
    [items addObject:BARBUTTON_TARGET(textView, @"U", @selector(toggleUnderline:))];
    
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:BARBUTTON(@"Done", @selector(leaveKeyboardMode))];
    
	toolbar.items = items;	
}

// Returns a plain accessory view
- (UIToolbar *) accessoryView
{
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 44.0f)];
	toolbar.tintColor = [UIColor darkGrayColor];
	return toolbar;
}

// Respond to the two accessory buttons
- (void) leaveKeyboardMode { [textView resignFirstResponder];	[self archiveData];}
- (void) clearText { [textView setText:@""]; }

// Check for use of hardware keyboard
- (BOOL) isUsingHardwareKeyboard: (CGRect) kbounds
{
	CGFloat startPoint = toolbar.superview.frame.origin.y;
	CGFloat endHeight = startPoint + kbounds.size.height;
	CGFloat viewHeight = self.view.window.frame.size.height;
	BOOL usingHardwareKeyboard = endHeight > viewHeight;
    return usingHardwareKeyboard;
}

// Update TextView Height
- (void) adjustToBottomInset: (CGFloat) offset
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
    currentVerticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(>=0)]-bottomMargin-|" options:0 metrics:@{@"bottomMargin":@(offset)} views:@{@"textView":textView}];
    [self.view addConstraints:currentVerticalConstraints];
}

// Respond to Keyboard Frame Changes
- (void) updateTextViewBounds: (NSNotification *) notification
{
	if (![textView isFirstResponder])	 // no keyboard
	{
        [self adjustToBottomInset:0.0f];
        return;
	}
    
	CGRect kbounds;
	[(NSValue *)[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&kbounds];
    
    BOOL isUsingHardware = [self isUsingHardwareKeyboard:kbounds];
    [self adjustToBottomInset: (isUsingHardware) ? toolbar.bounds.size.height: kbounds.size.height];
    [self loadAccessoryView];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create text view
    textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.spellCheckingType = UITextSpellCheckingTypeNo;

    // Set its basic properties
	textView.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
    textView.inputAccessoryView = [self accessoryView];
    textView.allowsEditingTextAttributes = YES;
    textView.delegate = self;
    
    // Add and constrain the view
    [self.view addSubview:textView];
    CONSTRAIN(textView, @"H:|[textView(>=0)]|");
    [self adjustToBottomInset:0.0f];

    // Load any existing string
    if ([[NSFileManager defaultManager] fileExistsAtPath:DATAPATH])
    {
        NSString *string = [NSString stringWithContentsOfFile:DATAPATH encoding:NSUTF8StringEncoding error:nil];
		textView.text = string;
    }
    
    // Subscribe to keyboard changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextViewBounds:) name:UIKeyboardDidChangeFrameNotification object:nil];   
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
    TestBedViewController *tbvc;
}
@end
@implementation TestBedAppDelegate
- (void) applicationWillResignActive:(UIApplication *)application
{
    [tbvc archiveData];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}