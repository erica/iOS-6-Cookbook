/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define MAXCIRCLES  12
#define SIDELENGTH  96.0f
#define HALFCIRCLE  48.0f
#define INSET_AMT   4

@interface DragView : UIImageView
{
    CGPoint previousLocation;
}
@end

@implementation DragView
- (id) initWithImage: (UIImage *) anImage
{
    if (self = [super initWithImage:anImage])
    {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.gestureRecognizers = @[pan];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
	CGPoint pt;
	float HALFSIDE = SIDELENGTH / 2.0f;
	
	// normalize with centered origin
	pt.x = (point.x - HALFSIDE) / HALFSIDE;
	pt.y = (point.y - HALFSIDE) / HALFSIDE;
	
	// x^2 + y^2 = radius
	float xsquared = pt.x * pt.x;
	float ysquared = pt.y * pt.y;
	
	// If the radius < 1, the point is within the clipped circle
	if ((xsquared + ysquared) < 1.0) return YES;
	return NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    previousLocation = self.center;
}

- (void) handlePan: (UIPanGestureRecognizer *) uigr
{
	CGPoint translation = [uigr translationInView:self.superview];
	CGPoint newcenter = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
	
	// Bound movement into parent bounds
	float halfx = CGRectGetMidX(self.bounds);
	newcenter.x = MAX(halfx, newcenter.x);
	newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
	
	float halfy = CGRectGetMidY(self.bounds);
	newcenter.y = MAX(halfy, newcenter.y);
	newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
	
	// Set new location
	self.center = newcenter;	
}
@end


@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

#define RANDOMLEVEL	((random() % 128) / 256.0f)

- (UIImage *) createImage
{
	UIColor *color = [UIColor colorWithRed:RANDOMLEVEL green:RANDOMLEVEL blue:RANDOMLEVEL alpha:1.0f];
    
    CGSize size = CGSizeMake(SIDELENGTH, SIDELENGTH);
	CGRect rect = (CGRect){.size = size};
    
	UIGraphicsBeginImageContext(size);

	// Create a filled ellipse
	[color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];
	
	// Outline the circle a couple of times
    [[UIColor whiteColor] setStroke];
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, INSET_AMT, INSET_AMT)];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, 2*INSET_AMT, 2*INSET_AMT)]];
    [path stroke];
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

// Updated for orientation sensitivity, per request by Antoine
- (CGPoint) randomPosition: (UIInterfaceOrientation) orientation
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    CGFloat max = fmaxf(rect.size.width, rect.size.height);
    CGFloat min = fminf(rect.size.width, rect.size.height);
    
    CGFloat destw = min;
    CGFloat desth = max;
    if (UIInterfaceOrientationIsLandscape(orientation)) {destw = max; desth = min;}
    
    
    CGFloat x = random() % ((int)(destw - 2 * HALFCIRCLE)) + HALFCIRCLE;
    CGFloat y = random() % ((int)(desth - 2 * HALFCIRCLE)) + HALFCIRCLE;
    return CGPointMake(x, y);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        for (int i = 0; i < MAXCIRCLES; i++)
        {
            DragView *dragger = (DragView *) [self.view viewWithTag:100 + i];
            dragger.center = [self randomPosition:toInterfaceOrientation];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor blackColor];

    // Add the circles to random points on the screen	
    for (int i = 0; i < MAXCIRCLES; i++)
    {
        DragView *dragger = [[DragView alloc] initWithImage:[self createImage]];
        dragger.center = [self randomPosition:self.interfaceOrientation];
        dragger.tag = 100 + i;
        [self.view addSubview:dragger];
    }
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