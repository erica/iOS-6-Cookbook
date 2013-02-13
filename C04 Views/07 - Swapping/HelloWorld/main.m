/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIView-BasicConstraints.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UIViewController
{
    UIImageView *frontObject;
    UIImageView *backObject;
}
@end

@implementation TestBedViewController
- (void) swap: (id) sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 frontObject.alpha = 0.0f;
						 backObject.alpha = 1.0f;
						 frontObject.transform = CGAffineTransformMakeScale(0.25f, 0.25f);
						 backObject.transform = CGAffineTransformIdentity;
						 [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
					 }
					 completion:^(BOOL done){
                         UIImageView *tmp = frontObject;
                         frontObject = backObject;
                         backObject = tmp;
						 self.navigationItem.rightBarButtonItem.enabled = YES;
					 }];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add secondary object
    backObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    [self.view addSubviewAndConstrainToBounds:backObject];
    [backObject centerHorizontallyInSuperview];
    [backObject centerVerticallyInSuperview];
    
    // Add primary object
    frontObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    [self.view addSubviewAndConstrainToBounds:frontObject];
    [frontObject centerHorizontallyInSuperview];
    [frontObject centerVerticallyInSuperview];

    // Prepare secondary object
    backObject.alpha = 0.0f;
    backObject.transform = CGAffineTransformMakeScale(0.25f, 0.25f);

	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Swap", @selector(swap:));
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