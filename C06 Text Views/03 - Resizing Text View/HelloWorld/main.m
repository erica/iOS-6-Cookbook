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
- (void) leaveKeyboardMode
{
	[textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) adjustToBottomInset: (CGFloat) offset
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
    currentVerticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(>=0)]-bottomMargin-|" options:0 metrics:@{@"bottomMargin":@(offset)} views:@{@"textView":textView}];
    [self.view addConstraints:currentVerticalConstraints];
}

- (void) keyboardDidShow: (NSNotification *) notification
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
	// Retrieve the keyboard bounds via the notification userInfo dictionary
	CGRect kbounds;
	[(NSValue *)[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&kbounds];
    [self adjustToBottomInset:kbounds.size.height];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(leaveKeyboardMode));
}

- (void) keyboardWillHide: (NSNotification *) notification
{
    [self leaveKeyboardMode];
    [self adjustToBottomInset:0.0f];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	textView.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
    
	[self.view addSubviewAndConstrainToBounds:textView];
    [textView fitToWidthWithInset:0.0f];
    
    // Set up initial full-height constraint
    [self adjustToBottomInset:0.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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