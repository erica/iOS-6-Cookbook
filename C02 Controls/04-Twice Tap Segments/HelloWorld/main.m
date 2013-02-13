/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

@class DoubleTapSegmentedControl;

@protocol DoubleTapSegmentedControlDelegate <NSObject>
- (void) performSegmentAction: (DoubleTapSegmentedControl *) aDTSC;
@end

@interface DoubleTapSegmentedControl : UISegmentedControl
@property (nonatomic, retain) id <DoubleTapSegmentedControlDelegate> tapDelegate;
@end

@implementation DoubleTapSegmentedControl
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if (self.tapDelegate) [self.tapDelegate performSegmentAction:self];
    
    // Add a little extra feedback
    NSDictionary *attributeDictionary = @{UITextAttributeTextColor : [UIColor lightGrayColor]};
    [self setTitleTextAttributes:attributeDictionary forState:UIControlStateSelected];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setTitleTextAttributes:nil forState:UIControlStateSelected];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
@end

@interface TestBedViewController : UIViewController <DoubleTapSegmentedControlDelegate>
@end

@implementation TestBedViewController
- (void) performSegmentAction: (DoubleTapSegmentedControl *) seg
{
    NSArray *items = [@"One*Two*Three" componentsSeparatedByString:@"*"];
    NSString *selected = [items objectAtIndex:seg.selectedSegmentIndex];
    
    // Check for a second tap
    if ([selected isEqualToString:self.title])
        selected = [NSString stringWithFormat:@"%@ (again)", selected];
    self.title = selected;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add a segment testbed to the view
    NSArray *items = [@"One*Two*Three" componentsSeparatedByString:@"*"];
    DoubleTapSegmentedControl *seg = [[DoubleTapSegmentedControl alloc] initWithItems:items];
    seg.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f);
    seg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    seg.selectedSegmentIndex = 0;
    seg.tapDelegate = self;
    [self.view addSubview:seg];
    
    self.title = @"One";
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