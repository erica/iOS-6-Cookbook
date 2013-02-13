/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "BookController.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define CRAYON_NAME(CRAYON)	[CRAYON componentsSeparatedByString:@"#"][0]
#define CRAYON_COLOR(CRAYON) [self colorFromHexString:[[CRAYON componentsSeparatedByString:@"#"] lastObject]]
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define RESIZABLE(_VIEW_) [_VIEW_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth]
#define CONSTRAIN(VIEW, FORMAT)     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

@interface TestBedViewController : UIViewController <BookControllerDelegate>
{
    NSArray *rawColors;
    BookController *bookController;
    UISlider *pageSlider;
    NSTimer *hiderTimer;
}
@end

@implementation TestBedViewController
- (UIColor *) colorFromHexString: (NSString *) hexColor
{
	unsigned int red, green, blue;
    
	NSRange range = NSMakeRange(0, 2);
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location += 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location += 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:1.0f];
}

- (NSInteger) numberOfPages
{
    return rawColors.count;
}

- (UIViewController *) controllerWithColor: (UIColor *) color withName: (NSString *) name
{
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view = [[[NSBundle mainBundle] loadNibNamed:(IS_IPHONE ? @"Page-iPhone" : @"Page-iPad") owner:controller options:nil] lastObject];
    controller.view.backgroundColor = color;
    
    UILabel *colorLabel = (UILabel *)[controller.view viewWithTag:101];
    colorLabel.text = name;
    
    return controller;
}

- (id) viewControllerForPage: (int) pageNumber
{
    if (pageNumber > (rawColors.count - 1)) return nil;
    if (pageNumber < 0) return nil;
    
    NSString *rawString = rawColors[pageNumber];
    UIViewController *vc = [self controllerWithColor:CRAYON_COLOR(rawString) withName:CRAYON_NAME(rawString)];
    vc.view.tag = pageNumber;
    return vc;
}

- (void) moveToPage: (UISlider *) theSlider
{
    [hiderTimer invalidate];
    hiderTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideSlider:) userInfo:nil repeats:NO];
    [bookController moveToPage:(int) theSlider.value];
}

- (void) bookControllerDidTurnToPage: (NSNumber *) pageNumber
{
    pageSlider.value = pageNumber.intValue;
}

// Hide the slider after the timer fires
- (void) hideSlider: (NSTimer *) aTimer
{
    [UIView animateWithDuration:0.3f animations:^(void){
        pageSlider.alpha = 0.0f;
    }];
    
    [hiderTimer invalidate];
    hiderTimer = nil;
}

// Present the slider when tapped
- (void) handleTap: (UITapGestureRecognizer *) recognizer
{
    [UIView animateWithDuration:0.3f animations:^(void){
        pageSlider.alpha = 1.0f;
    }];
    
    [hiderTimer invalidate];
    hiderTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideSlider:) userInfo:nil repeats:NO];
}


- (void) viewDidAppear:(BOOL)animated
{
    if (!bookController)
    {
        bookController = [BookController bookWithDelegate:self style:BookLayoutStyleBook];
        RESIZABLE(bookController.view);
    }

    [self addChildViewController:bookController];
    [self.view addSubview:bookController.view];
    [bookController didMoveToParentViewController:self];
    
    [bookController moveToPage:0];
    [self.view bringSubviewToFront:pageSlider];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [bookController willMoveToParentViewController:nil];
    [bookController.view removeFromSuperview];
    [bookController removeFromParentViewController];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    RESIZABLE(self.view);
    
    // Load colors and create first view controller
    NSString *pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt" inDirectory:@"/"];
	rawColors = [[NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    
    // Establish a slider
    pageSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.view addSubview:pageSlider];
    
    PREPCONSTRAINTS(pageSlider);
    CONSTRAIN(pageSlider, @"V:|-60-[pageSlider(==40)]");
    CONSTRAIN(pageSlider, @"H:|-[pageSlider(>=0)]-|");
    
    [pageSlider addTarget:self action:@selector(moveToPage:) forControlEvents:UIControlEventValueChanged];
    
    pageSlider.alpha = 0.0f; // initially hidden
    pageSlider.minimumValue = 0.0f;
    pageSlider.maximumValue = (float)(rawColors.count - 1);
    pageSlider.continuous = YES;
    pageSlider.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    pageSlider.minimumTrackTintColor = [UIColor grayColor];
    pageSlider.maximumTrackTintColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
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
    [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = tbvc;
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