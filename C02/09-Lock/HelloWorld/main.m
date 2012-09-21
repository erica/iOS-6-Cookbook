/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "LockControl.h"

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
- (void) handleUnlock: (LockControl *) control
{
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Lock", @selector(lock:));
}

- (void) lock:(id) sender
{
    self.navigationItem.rightBarButtonItem = nil;
    
    LockControl *lock = [LockControl controlWithTarget:self];
    [self.view addSubview:lock];
    
    lock.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    PREPCONSTRAINTS(lock);
    CENTERH(self.view, lock);
    CENTERV(self.view, lock);
    
    lock.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^(){
        lock.alpha = 1.0f;
    }];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self lock:nil];
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