/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Utility.h"

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate>
@end

@implementation TestBedViewController

#pragma mark - Utility
- (void) performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) presentViewController:(UIViewController *)viewControllerToPresent
{
    // Modal is best
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}


#pragma mark - Messaging
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self performDismiss];

    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Message was cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message was sent");
            break;
        default:
            break;
    }
}

- (void) sendMessage
{
    MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
    mcvc.messageComposeDelegate = self;
    // mcvc.recipients = [NSArray array];
    mcvc.body = @"I'm reading the iOS Developer's Cookbook";
    [self presentViewController:mcvc];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([MFMessageComposeViewController canSendText])
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Send", @selector(sendMessage));
    else
        self.title = @"Cannot send texts";
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