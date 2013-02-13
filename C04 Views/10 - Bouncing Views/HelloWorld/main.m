/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "AnimationHelper.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

// These are defined in Animation Helper
// typedef void (^AnimationBlock)(void);
// typedef void (^CompletionBlock)(BOOL finished);

@interface TestBedViewController : UIViewController
{
	UIView *bounceView;
}
@end

@implementation TestBedViewController

- (void) enable: (BOOL) yorn
{
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems)
        item.enabled = yorn;
    self.navigationItem.rightBarButtonItem.enabled = yorn;
}

// Recipe example
- (void) bounce: (id) sender
{
    [self enable:NO];
    
    // Define the three stages of the animation in forward order
    AnimationBlock makeSmall = ^(void){
        bounceView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);};
    AnimationBlock makeLarge = ^(void){
        bounceView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);};
    AnimationBlock restoreToOriginal = ^(void) {
        bounceView.transform = CGAffineTransformIdentity;};
    
    // Create the three completion links in reverse order
    CompletionBlock reenable = ^(BOOL finished) {
        [self enable:YES];};
    CompletionBlock shrinkBack = ^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:restoreToOriginal completion: reenable];};
    CompletionBlock bounceLarge = ^(BOOL finished){
        [NSThread sleepForTimeInterval:0.5f];
        [UIView animateWithDuration:0.2 animations:makeLarge completion:shrinkBack];};
    
    // Start the animation
    [UIView animateWithDuration: 0.1f animations:makeSmall completion:bounceLarge];
}

// Additional example
- (void) actionScale
{
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    CGAffineTransform transientTransform = CGAffineTransformMakeScale(1.2f, 1.2f);
    CGAffineTransform shrinkTransform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    
    // Init
    [self enable:NO];
    bounceView.center = CGPointMake(midX, midY);
    bounceView.transform = shrinkTransform;
    
    // Go
    CompletionBlock allDone = ^(BOOL done){[self enable:YES];};
    CompletionBlock done = ^(BOOL done){sleep(2); [AnimationHelper viewAnimation:bounceView viaTransform:transientTransform toTransform:shrinkTransform completion:allDone]();};
    
    AnimationBlock block = [AnimationHelper viewAnimation:bounceView viaTransform:transientTransform toTransform:CGAffineTransformIdentity completion:done];
    block();
}

// Additional example
- (void) actionMove
{
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    CGPoint centerPoint = CGPointMake(midX, midY);
    CGPoint beyondPoint = CGPointMake(midX * 1.2f, midY);
    
    // Init
    [self enable:NO];
    bounceView.center = CGPointMake(-midX, midY);
    bounceView.transform = CGAffineTransformIdentity;
    
    // Go
    CompletionBlock allDone = ^(BOOL done){[self enable:YES];};
    CompletionBlock done = ^(BOOL done){sleep(2); [AnimationHelper viewAnimation:bounceView viaCenter: CGPointMake(midX * 1.2f, midY)toCenter:CGPointMake(-midX, midY) completion:allDone]();};
    AnimationBlock block = [AnimationHelper viewAnimation:bounceView viaCenter:beyondPoint toCenter:centerPoint completion:done];
    block();
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    bounceView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 150.0f)];
    bounceView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bounceView];
    bounceView.transform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    
    self.navigationItem.leftBarButtonItems = @[BARBUTTON(@"Scale", @selector(actionScale)), BARBUTTON(@"Move", @selector(actionMove))];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Start", @selector(bounce:));
}


- (void) viewDidAppear:(BOOL)animated
{
    bounceView.center = RECTCENTER(self.view.bounds);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    bounceView.center = RECTCENTER(self.view.bounds);
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