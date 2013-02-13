/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIView-BasicConstraints.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR] 
#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface TestBedViewController : UIViewController
{
    UITextView *textView;
    UIToolbar *toolBar;
    
    NSArray *currentVerticalConstraints;
}
@end

@implementation TestBedViewController
- (void) clearText
{
	[textView setText:@""];
}

- (void) leaveKeyboardMode
{
	[textView resignFirstResponder];
}

- (UIToolbar *) accessoryView
{
	toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	toolBar.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
	[items addObject:BARBUTTON(@"Clear", @selector(clearText))];
	[items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:BARBUTTON(@"Done", @selector(leaveKeyboardMode))];
	toolBar.items = items;	
	
	return toolBar;
}

- (void) adjustToBottomInset: (CGFloat) offset
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
    currentVerticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(>=0)]-bottomMargin-|" options:0 metrics:@{@"bottomMargin":@(offset)} views:@{@"textView":textView}];
    [self.view addConstraints:currentVerticalConstraints];
}

- (BOOL) isUsingHardwareKeyboard: (CGRect) kbounds
{
	CGFloat startPoint = toolBar.superview.frame.origin.y;
	CGFloat endHeight = startPoint + kbounds.size.height;
	CGFloat viewHeight = self.view.window.frame.size.height;
	BOOL usingHardwareKeyboard = endHeight > viewHeight;
    return usingHardwareKeyboard;
}

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
    [self adjustToBottomInset: (isUsingHardware) ? toolBar.bounds.size.height: kbounds.size.height];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	textView.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
    textView.inputAccessoryView = [self accessoryView];
    
	[self.view addSubviewAndConstrainToBounds:textView];
    [textView fitToWidthWithInset:0.0f];
    
    // Set up initial full-height constraint
    [self adjustToBottomInset:0.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextViewBounds:) name:UIKeyboardDidChangeFrameNotification object:nil];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
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