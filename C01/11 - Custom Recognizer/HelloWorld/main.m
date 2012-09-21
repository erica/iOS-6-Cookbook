/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CircleRecognizer.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RESIZABLE(_VIEW_) [_VIEW_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth]

@interface UIColor (Random)
@end

@implementation UIColor(Random)
+(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
	
	float intensityOffset = 0.25f;
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX; red = (red / 2.0f) + intensityOffset;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX; blue = (blue / 2.0f) + intensityOffset;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX; green = (green / 2.0f) + intensityOffset;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void) handleCircleRecognizer:(UIGestureRecognizer *) recognizer
{
	// Respond to a recognition event by updating the background
    // I do this just to give the user some feedback that the recognizer succeeded
	NSLog(@"Circle recognized");
	self.view.backgroundColor = [UIColor randomColor];
}
- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CircleRecognizer *recognizer = [[CircleRecognizer alloc] initWithTarget:self action:@selector(handleCircleRecognizer:)]; 
	[self.view addGestureRecognizer:recognizer];
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