/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "Utility.h"

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController

#pragma mark - Utility
- (void) performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) presentViewController:(UIViewController *)viewControllerToPresent
{

    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark - Social
- (void) postSocial: (NSString *) serviceType
{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [controller addImage:[UIImage imageNamed:@"Icon.png"]];
    [controller setInitialText:@"I'm reading the iOS Developer's Coookbook"];
    controller.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result)
        {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancelled");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Done");
                break;
            default:
                break;
        }
    };
    [self presentViewController:controller];
}
- (void) postToFacebook
{
    [self postSocial:SLServiceTypeFacebook];
}

- (void) postToTwitter
{
    [self postSocial:SLServiceTypeTwitter];
}

#pragma mark - Setup

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Social", @selector(postUpdate));
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        self.navigationItem.leftBarButtonItem = BARBUTTON(@"Facebook", @selector(postToFacebook));
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Twitter", @selector(postToTwitter));
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
    [[UIToolbar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
    
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