/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "PushButton.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UIViewController
{
    PushButton *button;
    UIImageView *butterflyView;
}
@end

@implementation TestBedViewController
- (void) pushed: (PushButton *) aButton
{
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create button and add target
    button = [PushButton button];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
}

- (void) recenter
{
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    butterflyView.center = viewCenter;
    button.center = viewCenter;
}

- (void) viewDidAppear:(BOOL)animated
{
    
    if (!butterflyView)
    {
        // Load Butterflies
        NSMutableArray *butterflies = [NSMutableArray array];
        UIImage *image;
        for (int i = 1; i <= 17; i++) {
            NSString *butterfly = [NSString stringWithFormat:@"bf_%d.png", i];
            if ((image = [UIImage imageNamed:butterfly])) 
                [butterflies addObject:image];
        }
        
        CGSize size = ((UIImage *)[butterflies lastObject]).size;
        
        butterflyView = [[UIImageView alloc] initWithFrame:(CGRect){.size = size}];
        [butterflyView setAnimationImages:butterflies];
        [butterflyView setAnimationDuration:1.2f];
        [butterflyView startAnimating];
        [self.view addSubview:butterflyView];
        [self.view sendSubviewToBack:butterflyView];
    }
    
    [self recenter];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self recenter];
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