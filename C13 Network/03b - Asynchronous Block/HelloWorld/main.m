/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Utility.h"

// Large Movie (35 MB)
#define LARGE_MOVIE @"http://www.archive.org/download/BettyBoopCartoons/Betty_Boop_More_Pep_1936_512kb.mp4"

// Short movie (3 MB)
#define SMALL_MOVIE @"http://www.archive.org/download/Drive-inSaveFreeTv/Drive-in--SaveFreeTv_512kb.mp4"

// Fake address
#define FAKE_MOVIE @"http://www.idontbelievethisisavalidurlforthisexample.com"

// Current URL to test
#define MOVIE_PATH  LARGE_MOVIE
#define MOVIE_URL   [NSURL URLWithString:MOVIE_PATH]

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

- (void) readySteady
{
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self playMovie];
}

- (void) go
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aiv startAnimating];
    self.navigationItem.titleView = aiv;

    // Remove any existing data
    if ([[NSFileManager defaultManager] fileExistsAtPath:DEST_PATH])
    {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:DEST_PATH error:&error])
            NSLog(@"Error removing existing data: %@", error.localizedFailureReason);
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:MOVIE_PATH]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!data)
        {
            NSLog(@"Error downloading data: %@", error.localizedFailureReason);
            return;
        }
        
        [data writeToFile:DEST_PATH atomically:YES];
        [self performSelectorOnMainThread:@selector(readySteady) withObject:nil waitUntilDone:NO];
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