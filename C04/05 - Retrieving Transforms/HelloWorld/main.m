/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIView-Transform.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect dest = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    
    UIView *compareView = [[UIView alloc] initWithFrame:dest];
    compareView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:compareView];
    
    UIView *testView = [[UIView alloc] initWithFrame:dest];
    testView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:testView];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI_4);
    transform = CGAffineTransformScale(transform, 1.5f, 0.75f);
    transform = CGAffineTransformTranslate(transform, 30.0f, 40.0f);
    testView.transform = transform;
    
    NSLog(@"Translation: (%0.3f, %0.3f)", testView.tx, testView.ty);
    NSLog(@"Scale: (%0.3f, %0.3f)", testView.xscale, testView.yscale);
    NSLog(@"Rotation: %0.3f", testView.rotation);

    compareView.transform = CGAffineTransformMakeTranslation(testView.tx, testView.ty);
}

// Ignore this
/*
typedef void (^BasicBlock)(void);
- (void) viewDidAppear:(BOOL)animated
{
    BOOL animated = YES;
    UIView *compareView = self.view.subviews[0];
    BasicBlock update = ^(){[compareView setFrame:(CGRect) {.origin = CGPointZero, .size = compareView.bounds.size}];};
    if (animated)
        [UIView animateWithDuration:0.1f animations:update];
    else
        update();
} */
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