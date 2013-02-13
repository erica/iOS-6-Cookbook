/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)
#define RESIZABLE(_VIEW_) [_VIEW_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth]

@interface TestBedViewController : UIViewController
{
    IBOutlet UIImageView *imageView;
}
@end

@implementation TestBedViewController
- (void) fadeOut: (id) sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 imageView.alpha = 0.0f;
					 }
					 completion:^(BOOL done){
						 self.navigationItem.rightBarButtonItem.enabled = YES;
						 self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade In", @selector(fadeIn:));
					 }];
}


- (void) fadeIn: (id) sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 imageView.alpha = 1.0f;
					 }
					 completion:^(BOOL done){
						 self.navigationItem.rightBarButtonItem.enabled = YES;
						 self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade Out", @selector(fadeOut:));
					 }];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade In", @selector(fadeIn:));
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(>=0)]|" options:0 metrics:nil views:@{@"imageView":imageView}]];
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