/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"
#import <MediaPlayer/MediaPlayer.h>

// Large Movie (35 MB)
#define LARGE_MOVIE @"http://www.archive.org/download/BettyBoopCartoons/Betty_Boop_More_Pep_1936_512kb.mp4"

// Short movie (3 MB)
#define SMALL_MOVIE @"http://www.archive.org/download/Drive-inSaveFreeTv/Drive-in--SaveFreeTv_512kb.mp4"

// Fake address
#define FAKE_MOVIE @"http://www.idontbelievethisisavalidurlforthisexample.com"

// Current URL to test
#define MOVIE_URL   [NSURL URLWithString:LARGE_MOVIE]

// Location to store downloaded item
#define DEST_PATH	[NSHomeDirectory() stringByAppendingString:@"/Documents/Movie.mp4"]
#define DEST_URL    [NSURL fileURLWithPath:DEST_PATH]

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    BOOL success;
}

- (void) playMovie
{
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:DEST_URL];
    player.moviePlayer.allowsAirPlay = YES;
    [player.moviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         [[NSNotificationCenter defaultCenter] removeObserver:self];
     }];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}

- (void) downloadFinished
{
    // Restore GUI
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!success)
    {
        NSLog(@"Failed download");
        return;
    }
    
    // Play the movie
    [self playMovie];
}

- (void) getData: (NSURL *) url
{
    NSDate *startDate = [NSDate date];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSURLResponse *response;
	NSError *error;
    success = NO;
    
	NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!result)
    {
        NSLog(@"Download failed: %@", error.localizedFailureReason);
        return;
    }
    
    if ((response.expectedContentLength == NSURLResponseUnknownLength) ||
        (response.expectedContentLength < 0))
    {
        NSLog(@"Unexpected content length");
        return;
    }
    
    if (![response.suggestedFilename isEqualToString:url.path.lastPathComponent])
    {
        NSLog(@"Name mismatch. Probably carrier error page");
        return;
    }
    
    if (response.expectedContentLength != result.length)
    {
        NSLog(@"Got %d bytes, expected %lld", result.length, response.expectedContentLength);
        return;
    }
    
    success = YES;
    [result writeToFile:DEST_PATH atomically:YES];
    NSLog(@"Download %d bytes", result.length);
    NSLog(@"Suggested file name: %@", response.suggestedFilename);
    NSLog(@"Elapsed time: %0.2f seconds.", [[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void) go
{
    self.navigationItem.rightBarButtonItem.enabled = NO;

    // Remove any existing data
    if ([[NSFileManager defaultManager] fileExistsAtPath:DEST_PATH])
    {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:DEST_PATH error:&error])
            NSLog(@"Error removing existing data: %@", error.localizedFailureReason);
    }

    // Fetch the data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         [self getData:MOVIE_URL];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             // Finish up on main thread
             [self downloadFinished];
         }];
     }];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(go));
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