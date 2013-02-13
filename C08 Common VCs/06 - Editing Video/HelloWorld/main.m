/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIVideoEditorControllerDelegate>
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
    NSURL *mediaURL;
}

#pragma mark - Saving
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error)
    {
        NSLog(@"Error saving video: %@", error.localizedFailureReason);
        return;
    }
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) saveVideo
{
    // check if video is compatible with album and save
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
	if (compatible)
    {
		UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
}

#pragma mark - Utility
- (void) performDismiss
{
    if (IS_IPHONE)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [popover dismissPopoverAnimated:YES];
}

- (void) presentViewController:(UIViewController *)viewControllerToPresent
{
    if (IS_IPHONE)
	{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
	}
	else
	{
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

#pragma mark - Video Editor Controller
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    [self performDismiss];
    mediaURL = [NSURL URLWithString:editedVideoPath];
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Save", @selector(saveVideo));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error
{
    [self performDismiss];
    mediaURL = nil;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
    self.navigationItem.leftBarButtonItem = nil;
    
    NSLog(@"Video edit failed: %@", error.localizedFailureReason);
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
{
    [self performDismiss];
    mediaURL = nil;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) editMedia
{
    if (popover) return;
    
	if (![UIVideoEditorController canEditVideoAtPath:mediaURL.path])
	{
		self.title = @"Cannot Edit Video";
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
		return;
	}
	
	UIVideoEditorController *editor = [[UIVideoEditorController alloc] init];
	editor.videoPath = mediaURL.path;
	editor.delegate = self;
    [self presentViewController:editor];
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performDismiss];
    popover = nil;
    mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Edit", @selector(editMedia));
}


// Dismiss picker
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self performDismiss];
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (void) pickVideo
{
    if (popover) return;
    
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    
    [self presentViewController:picker];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
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