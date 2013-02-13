/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];

    // Create two standard text fields
    UITextField *textField1 = [[UITextField alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    textField1.center = CGPointMake(self.view.frame.size.width / 2.0f, 30.0f);
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview: textField1];
    
    UITextField *textField2 = [[UITextField alloc]
                               initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 30.0f)];
    textField2.center = CGPointMake(self.view.frame.size.width / 2.0f, 80.0f);
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview: textField2];
    
    // Create a purple view to be used as the input view
    UIView *purpleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 120.0f)];
    purpleView.backgroundColor = COOKBOOK_PURPLE_COLOR;
    
    // Assign the input view
    textField2.inputView = purpleView;
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