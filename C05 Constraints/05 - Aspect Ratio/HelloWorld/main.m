/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIView-BasicConstraints.h"
#import "Utility.h"

@interface TestBedViewController : UIViewController
{
    NSLayoutConstraint *aspectConstraint;
    BOOL useFourToThree;
    UIView *view1;
}
@end

@implementation TestBedViewController
- (UILabel *) createLabel: (NSString *) aTitle
{
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aLabel.font = [UIFont fontWithName:@"Futura" size:24.0f];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.textColor = [UIColor darkGrayColor];
    aLabel.text = aTitle;
    
    aLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [aLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[aLabel(>=theWidth@750)]" options:0 metrics:@{@"theWidth":@300.0} views:NSDictionaryOfVariableBindings(aLabel)]];
    [aLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[aLabel(>=theHeight@750)]" options:0 metrics:@{@"theHeight":@300.0} views:NSDictionaryOfVariableBindings(aLabel)]];

    return aLabel;
}

- (void) action: (id) sender
{
    if (aspectConstraint)
        [self.view removeConstraint:aspectConstraint];
    
    if (useFourToThree)
        aspectConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeHeight multiplier:(4.0f / 3.0f) constant:0.0f];
    else
        aspectConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeHeight multiplier:(16.0f / 9.0f) constant:0.0f];
    
    [self.view addConstraint:aspectConstraint];

    useFourToThree = !useFourToThree;
    
    [view1 showConstraints];
    [self.view showConstraints];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Switch", @selector(action:));
    
    view1 = [self createLabel:@"View 1"];
    view1.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.25f];
    [self.view addSubview:view1];
    
    [view1 constrainWithinSuperviewBounds];
    [view1 centerVerticallyInSuperview];
    [view1 centerHorizontallyInSuperview];
    
    [self action:nil];
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