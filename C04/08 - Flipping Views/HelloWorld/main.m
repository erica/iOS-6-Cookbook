/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UIViewController
{
    UIImageView *purple;
    UIImageView *maroon;
    BOOL fromPurple;
}
@end

@implementation TestBedViewController
- (void) flip: (id) sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView transitionFromView: fromPurple ? purple : maroon
                        toView: fromPurple ? maroon : purple
                      duration: 1.0f
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    completion: ^(BOOL done){
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        fromPurple = !fromPurple;
                    }];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create objects
    maroon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    purple = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    
    fromPurple = YES;

    [self.view addSubview:maroon];
    [self.view addSubview:purple];

	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Flip", @selector(flip:));
}

#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

- (void) viewDidAppear: (BOOL) animated
{
    maroon.center = RECTCENTER(self.view.bounds);
    purple.center = RECTCENTER(self.view.bounds);
    [UIView animateWithDuration: 0.1f animations:^(){
        maroon.alpha = 1.0f;
        purple.alpha = 1.0f;
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self viewDidAppear:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration: 0.1f animations:^(){
        maroon.alpha = 0.0f;
        purple.alpha = 0.0f;
    }];
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
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}