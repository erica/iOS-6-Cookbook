/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "RibbonPull.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface TestBedViewController : UIViewController
{
    RibbonPull *ribbonPull;
    UIView *hiddenView;
    BOOL isHidden;
    float desiredHeight;
}
@end

@implementation TestBedViewController

- (void) updateDrawer: (UIControl *) aControl
{
    [UIView animateWithDuration:1.0f animations:^(){
        if (isHidden)
        {
            hiddenView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, desiredHeight);
            ribbonPull.center = CGPointMake(ribbonPull.center.x, ribbonPull.center.y + desiredHeight);
        }
        else
        {
            hiddenView.frame = CGRectMake(0.0f, -desiredHeight, self.view.bounds.size.width, desiredHeight);
            ribbonPull.center = CGPointMake(ribbonPull.center.x, ribbonPull.center.y - desiredHeight);
        }
    }];
    
    isHidden = !isHidden;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    
    desiredHeight = 120.0f;
    isHidden = YES;
    
    CGSize appSize = [UIScreen mainScreen].applicationFrame.size;
    hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -desiredHeight, appSize.width, desiredHeight)];
    hiddenView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:hiddenView];

    ribbonPull = [RibbonPull control];
    CGSize ribbonSize = ribbonPull.bounds.size;
    [ribbonPull addTarget:self action:@selector(updateDrawer:) forControlEvents:UIControlEventValueChanged];
    ribbonPull.center = CGPointMake(appSize.width - ribbonSize.width, ribbonSize.height / 2.0f);
    [self.view addSubview:ribbonPull];
}

- (void) viewDidAppear:(BOOL)animated
{
    CGSize ribbonSize = ribbonPull.bounds.size;
    ribbonPull.center = CGPointMake(self.view.bounds.size.width - ribbonSize.width, ribbonPull.center.y);

	hiddenView.frame = CGRectMake(0.0f, isHidden ? -desiredHeight : 0.0f, self.view.bounds.size.width, desiredHeight);

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self viewDidAppear:NO];
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