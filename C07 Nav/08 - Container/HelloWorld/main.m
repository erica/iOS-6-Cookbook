/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "FlipViewController.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (UIViewController *) newFlipController
{
    UIViewController *blueController = [[UIViewController alloc] init];
    blueController.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *redController = [[UIViewController alloc] init];
    redController.view.backgroundColor = [UIColor redColor];
    
    FlipViewController *flipController = [[FlipViewController alloc]  initWithFrontController:blueController andBackController:redController];
    flipController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    flipController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return flipController;
}

- (void) modal: (id) sender
{
    [self.navigationController presentViewController:[self newFlipController] animated:YES completion:nil];
}

- (void) push: (id) sender
{
    [self.navigationController pushViewController:[self newFlipController] animated:YES];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Modal", @selector(modal:));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Push", @selector(push:));
    
    if (!IS_IPAD) return;
    
    UIViewController *flip = [self newFlipController];
    flip.view.bounds = CGRectMake(0.0f, 0.0f, 300.0f, 400.0f);
    flip.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    // Setup Child View Controller
    [self addChildViewController:flip];
    [self.view addSubview:flip.view];
    [flip didMoveToParentViewController:self];
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