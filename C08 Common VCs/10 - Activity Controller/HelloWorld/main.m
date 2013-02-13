/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface TextViewController : UIViewController
@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, weak) UIActivity *activity;
@end

@implementation TextViewController
- (void) done
{
    // This is busted on iPad. Radars filed.
    [_activity activityDidFinish:YES];
}

- (id) init
{
    if (!(self = [super init])) return nil;
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont fontWithName:@"Futura" size:16.0f];
    _textView.editable = NO;
    
    [self.view addSubview:_textView];
    PREPCONSTRAINTS(_textView);
    STRETCH_VIEW(self.view, _textView);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(done));
    return self;
}
@end

@interface MyActivity : UIActivity
@end
@implementation MyActivity
{
    NSArray *items;
}

- (NSString *)activityType
{
    return @"CustomActivityTypeListItemsAndTypes";
}

- (NSString *) activityTitle
{
    return @"List Items (Cookbook)";
}

- (UIImage *) activityImage
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 75.0f, 75.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    rect = CGRectInset(rect, 15.0f, 15.0f);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0f];
    [path stroke];
    
    rect = CGRectInset(rect, 0.0f, 10.0f);    
    [@"iOS" drawInRect:rect withFont:[UIFont fontWithName:@"Futura" size:18.0f] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    items = activityItems;
}

- (UIViewController *) activityViewController
{
    TextViewController *tv = [[TextViewController alloc] init];
    tv.activity = self;
    UITextView *textView = tv.textView;
    
    
    NSMutableString *string = [NSMutableString string];
    for (id item in items)
        [string appendFormat:@"%@: %@\n", [item class], [item description]];
    textView.text = string;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tv];
    return nav;
}

@end

@interface TestBedViewController : UIViewController <UIActivityItemSource, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UIPopoverController *popover;
}

#pragma mark - Utility
- (void) presentViewController:(UIViewController *)viewControllerToPresent
{
    if (popover) [popover dismissPopoverAnimated:NO];
    
    if (IS_IPHONE)
	{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
	}
	else
	{
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem
                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

#pragma mark - Activity - 

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    // NSLog(@"Type: %@", activityType);
    return imageView.image;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return imageView.image;
}

- (void) action
{    
    // Self adopts the UIActivityItemSource Protocol
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[self] applicationActivities:nil];
    
    // Or supply the item(s) directly
    // UIImage *secondImage = [UIImage imageNamed:@"Default.png"];
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image, secondImage] applicationActivities:nil];
    
    // Or roll your own activity
    /* UIImage *secondImage = [UIImage imageNamed:@"Default.png"];
    UIActivity *appActivity = [[MyActivity alloc] init];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image, secondImage] applicationActivities:@[appActivity]]; */
    
    // String
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[@"Hello", @"World"]applicationActivities:nil];

    // array, dictionary, date, number, url
    // UIColor *color = [UIColor redColor];
    // NSURL *url = [NSURL URLWithString:@"http://ericasadun.com"];
    // NSArray *testArray = @[@"z", @"y", @"x"];
    // NSDate *date = [NSDate date];
    // NSDictionary *dict = @{@"hello":@"world"};
    // NSDictionary *dict = @{@"Hello":[UIColor greenColor]};
    
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image] applicationActivities:nil];

    [self presentViewController:activity];
}

- (void) abc {imageView.image = blockImage(@" abc ");}
- (void) def {imageView.image = blockImage(@" def ");}
- (void) ghi {imageView.image = blockImage(@" ghi ");}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemAction, @selector(action));
    self.navigationItem.rightBarButtonItems = @[
    BARBUTTON(@"ghi", @selector(ghi)),
    BARBUTTON(@"def", @selector(def)),
    BARBUTTON(@"abc", @selector(abc)),
    ];
    
    imageView = [[UIImageView alloc] initWithImage:blockImage(@" abc ")];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(self.view, imageView);
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