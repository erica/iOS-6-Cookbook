/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "Utility.h"

@interface QuickItem : NSObject <QLPreviewItem>
@property (nonatomic, strong) NSString *path;
@property (readonly) NSString *previewItemTitle;
@property (readonly) NSURL *previewItemURL;
@end

@implementation QuickItem
- (NSString *) previewItemTitle
{
    return @"Generated PDF";
}

- (NSURL *) previewItemURL
{
    return [NSURL fileURLWithPath:_path];
}
@end

#define FILE_PATH   [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PDFSample.pdf"]

@interface TestBedViewController : UIViewController <QLPreviewControllerDataSource>
@end

@implementation TestBedViewController
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index;
{
    QuickItem *item = [[QuickItem alloc] init];
    item.path = FILE_PATH;
    return item;
}

- (void) push
{
    QLPreviewController *controller = [[QLPreviewController alloc] init];
    controller.dataSource = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) present
{
    QLPreviewController *controller = [[QLPreviewController alloc] init];
    controller.dataSource = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) dumpToPDFFile
{
    // Create a string
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Hello World!"];
    NSRange range = NSMakeRange(0, string.length);
    
    // Make the string center aligned and big
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:36.0f] range:range];

    // Load an image
    UIImage *image = [UIImage imageNamed:@"Default.png"];

    // Create PDF
    CGRect theBounds = CGRectMake(0.0f, 0.0f, 480.0f, 600.0f);
    UIGraphicsBeginPDFContextToFile(FILE_PATH, theBounds, nil);
    UIGraphicsBeginPDFPage();
    [string drawInRect:CGRectMake(0.0f, 30.0f, 480.0f, 50.0f)];
    [image drawAtPoint:CGPointMake(80.0f, 80.0f)];
    UIGraphicsEndPDFContext();
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Push", @selector(push));
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Present", @selector(present));
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:FILE_PATH])
        [[NSFileManager defaultManager] removeItemAtPath:FILE_PATH error:nil];
    
    [self dumpToPDFFile];
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