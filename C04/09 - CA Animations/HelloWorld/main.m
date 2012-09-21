/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"

@interface TestBedViewController : UIViewController
{
    UIImageView *frontObject;
    UIImageView *backObject;
}
@end

@implementation TestBedViewController
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
}

- (void) animate: (id) sender
{
	// Set up the animation
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 1.0f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	
	switch ([(UISegmentedControl *)self.navigationItem.titleView selectedSegmentIndex]) 
	{
		case 0:
			animation.type = kCATransitionFade;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			break;
		case 2:
			animation.type = kCATransitionPush;
			break;
		case 3:
			animation.type = kCATransitionReveal;
		default:
			break;
	}
	animation.subtype = kCATransitionFromBottom;
	
	// Perform the animation
	[self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[self.view.layer addAnimation:animation forKey:@"animation"];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add secondary object
    backObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    [self.view addSubview:backObject];
    PREPCONSTRAINTS(backObject);
    CENTER_VIEW(self.view, backObject);
    
    // Add primary object
    frontObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    [self.view addSubview:frontObject];
    PREPCONSTRAINTS(frontObject);
    CENTER_VIEW(self.view, frontObject);

	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(animate:));
    
    // Add a segmented control to select the animation
	UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:[@"Fade Over Push Reveal" componentsSeparatedByString:@" "]];
	sc.segmentedControlStyle = UISegmentedControlStyleBar;
	sc. selectedSegmentIndex = 0;
	self.navigationItem.titleView = sc;
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
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}