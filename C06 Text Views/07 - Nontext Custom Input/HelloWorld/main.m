/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CONSTRAIN(VIEW, FORMAT)     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]

@interface UIView (FirstResponderUtility)
+ (UIView *) currentResponder;
@end

@implementation UIView (FirstResponderUtility)
- (UIView *) findFirstResponder
{
	if ([self isFirstResponder]) return self;
	
	for (UIView *view in self.subviews)
	{
		UIView *fr = [view findFirstResponder];
		if (fr) return fr;
	}
	
	return nil;
}

+ (UIView *) currentResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [keyWindow findFirstResponder];
}
@end

@interface ColorView : UIView <UIKeyInput>
@property (strong) UIView *inputView;
@end

@implementation ColorView
// UITextInput protocol
- (BOOL) hasText {return NO;}
- (void) insertText:(NSString *)text {}
- (void) deleteBackward {}

// First responder support
- (BOOL) canBecomeFirstResponder {return YES;}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {[self becomeFirstResponder];}

// Initialize with user interaction allowed
- (id) initWithFrame:(CGRect)aFrame
{
	if (!(self = [super initWithFrame:aFrame])) return self;
	self.backgroundColor = COOKBOOK_PURPLE_COLOR;
	self.userInteractionEnabled = YES;
	return self;
}
@end

@interface InputToolbar : UIToolbar <UIInputViewAudioFeedback>
@end

@implementation InputToolbar
- (BOOL) enableInputClicksWhenVisible 
{
    return YES;
}

- (void) updateColor: (UIColor *) aColor
{
 	[UIView currentResponder].backgroundColor = aColor;
    [[UIDevice currentDevice] playInputClick];
}

// Color change options
- (void) light: (id) sender {
	[self updateColor:[COOKBOOK_PURPLE_COLOR colorWithAlphaComponent:0.33f]];}
- (void) medium: (id) sender {
	[self updateColor:[COOKBOOK_PURPLE_COLOR colorWithAlphaComponent:0.66f]];}
- (void) dark: (id) sender {
	[self updateColor:COOKBOOK_PURPLE_COLOR];}

// Resign first responder on Done
- (void) done: (id) sender
{
	[[UIView currentResponder] resignFirstResponder];
}

- (id) initWithFrame: (CGRect) aFrame
{
	if (!(self = [super initWithFrame: aFrame])) return self;
	
	NSMutableArray *theItems = [NSMutableArray array];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[theItems addObject:BARBUTTON(@"Light", @selector(light:))];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[theItems addObject:BARBUTTON(@"Medium", @selector(medium:))];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[theItems addObject:BARBUTTON(@"Dark", @selector(dark:))];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[theItems addObject:BARBUTTON(@"Done", @selector(done:))];
	self.items = theItems;
	
	return self;
}
@end

@interface TestBedViewController : UIViewController
{
    ColorView *colorView;
}
@end

@implementation TestBedViewController

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
	InputToolbar *itb = [[InputToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 44.0f)];
    
	colorView = [[ColorView alloc] initWithFrame:CGRectZero];
	colorView.inputView = itb;
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    colorView.userInteractionEnabled = YES;
    [self.view addSubview:colorView];
    CONSTRAIN(colorView, @"V:|-40-[colorView(>=0)]-120-|");
    CONSTRAIN(colorView, @"H:|-40-[colorView(>=0)]-40-|");
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
    [[UIToolbar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];

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