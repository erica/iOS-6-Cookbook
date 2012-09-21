/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "Utility.h"

@interface TestBedViewController : UIViewController
{
    CustomSlider *slider;
}
@end

@implementation TestBedViewController
- (void) updateValue: (UISlider *) aSlider
{
    // Scale the title view
    self.navigationItem.titleView.transform = CGAffineTransformMakeScale(1.0f + 4.0f * aSlider.value, 1.0f);
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Set global UISlider appearance attributes
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor blackColor]];
    [[UISlider appearance] setMaximumTrackTintColor:[UIColor grayColor]];
    
	// Add the slider
    slider = [CustomSlider slider];
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:slider];
    
    // Create a custom title view
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
    self.navigationItem.titleView = iv;
}

- (void) viewDidAppear:(BOOL)animated
{
    slider.center = RECTCENTER(self.view.bounds);
    [slider updateThumb];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    slider.center = RECTCENTER(self.view.bounds);
    [slider updateThumb];
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