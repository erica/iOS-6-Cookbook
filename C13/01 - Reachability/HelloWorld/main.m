/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIDevice-Reachability.h"
#import "Utility.h"

@interface TestBedViewController : UIViewController <ReachabilityWatcher>
@end
@implementation TestBedViewController
{
    UITextView *textView;
}

- (void) log: (id) formatstring,...
{
    va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
    
    NSString *newString = [NSString stringWithFormat:@"%@: %@\n%@", [NSDate date], outstring, textView.text];
    textView.text = newString;
}

// Run basic reachability tests
- (void) runTests
{
    UIDevice *device = [UIDevice currentDevice];
    [self log:@"\n\n"];
    [self log:@"Current host: %@", [device hostname]];
    [self log:@"Local: %@", [device localWiFiIPAddress]];
    [self log:@"All: %@", [device localWiFiIPAddresses]];
    
    [self log:@"Network available?: %@", [device networkAvailable] ? @"Yes" : @"No"];
    [self log:@"Active WLAN?: %@", [device activeWLAN] ? @"Yes" : @"No"];
    [self log:@"Active WWAN?: %@", [device activeWWAN] ? @"Yes" : @"No"];
    [self log:@"Active hotspot?: %@", [device activePersonalHotspot] ? @"Yes" : @"No"];
    if (![device activeWWAN]) return;
    [self log:@"Contacting whatismyip.com"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         NSString *results = [device whatismyipdotcom];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"IP Addy: %@", results];
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }];
     }];
}

- (void) checkAddresses
{
    UIDevice *device = [UIDevice currentDevice];
    if (![device networkAvailable]) return;
    [self log:@"Checking IP Addresses"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         NSString *google = [device getIPAddressForHost:@"www.google.com"];
         NSString *amazon = [device getIPAddressForHost:@"www.amazon.com"];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"Google: %@", google];
             [self log:@"Amazon: %@", amazon];
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }];
     }];
}

#define CHECK(SITE) [self log:@"• %@ : %@", SITE, [device hostAvailable:SITE] ? @"available" : @"not available"];

- (void) checkSites
{
    UIDevice *device = [UIDevice currentDevice];
    NSDate *date = [NSDate date];
    CHECK(@"www.google.com");
    CHECK(@"www.ericasadun.com");
    CHECK(@"www.notverylikely.com");
    CHECK(@"192.168.0.108");
    CHECK(@"pearson.com");
    CHECK(@"www.pearson.com");
    [self log:@"Elapsed time: %0.1f", [[NSDate date] timeIntervalSinceDate:date]];
}

- (void) reachabilityChanged
{
    [self log:@"REACHABILITY CHANGED!\n"];
    [self runTests];
}

- (void) loadView
{
    [super loadView];
    textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Futura" size:IS_IPAD ? 24.0f : 12.0f];
    textView.textColor = COOKBOOK_PURPLE_COLOR;
    textView.text = @"";
    [self.view addSubview:textView];
    PREPCONSTRAINTS(textView);
    STRETCH_VIEW(self.view, textView);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Test", @selector(runTests));
    
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end
@implementation TestBedAppDelegate
{
	UIWindow *window;
    TestBedViewController *tbvc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    
    [[UIDevice currentDevice] scheduleReachabilityWatcher:tbvc];
    
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}