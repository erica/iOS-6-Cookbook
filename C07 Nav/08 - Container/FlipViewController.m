/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "FlipViewController.h"

#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR] 

#define CONSTRAIN(VIEW, FORMAT)     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

@implementation FlipViewController
// Dismiss the view controller
- (void) done: (id) sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    if (!controllers.count)
    {
        NSLog(@"Error: No root view controller");
        return;
    }
    
    // Clean up the Child View Controller
    UIViewController *currentController = (UIViewController *)controllers[0];
    [currentController willMoveToParentViewController:nil];
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
}

- (void) flip: (id) sender
{
    // Please call only with two controllers;
    if (controllers.count < 2) return;

    // Determine which item is front, which is back
    UIViewController *front =  (UIViewController *)controllers[0];
    UIViewController *back =  (UIViewController *)controllers[1];
    
    // Select the transition direction
    UIViewAnimationTransition transition = reversedOrder ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    
    // Hide the info button until after the flip
    infoButton.alpha = 0.0f;
    
    // Prepare the front for removal, the back for adding
    [front willMoveToParentViewController:nil];
    [self addChildViewController:back];
    
    back.view.frame = front.view.frame;

    // Perform the transition
    [self transitionFromViewController: front toViewController:back duration:0.5f options: transition  animations:nil completion:^(BOOL done){
        
        // Bring the Info button back into view
        [self.view bringSubviewToFront:infoButton];
        [UIView animateWithDuration:0.3f animations:^(){
            infoButton.alpha = 1.0f;
        }];
        
        // Finish up transition
        [front removeFromParentViewController];
        [back didMoveToParentViewController:self];
        
        reversedOrder = !reversedOrder;
        controllers = @[back, front];
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (!controllers.count)
    {
        NSLog(@"Error: No root view controller");
        return;
    }
    
    UIViewController *front = controllers[0];
    UIViewController *back = nil;
    if (controllers.count > 1)
    {
        back = controllers[1];
        back.view.frame = front.view.frame;
    }

    [self addChildViewController:front];
    [self.view addSubview:front.view];
    [front didMoveToParentViewController:front];
    
    // Check for presentation and for flippability
    BOOL isPresented = self.isBeingPresented;
    
    // Clean up instance if re-use
    if (navbar || infoButton)
    {
        [navbar removeFromSuperview];
        [infoButton removeFromSuperview];
        navbar = nil;
    }

    // When presented, add a custom navigation bar
    if (isPresented)
    {
        navbar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        navbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        navbar.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,44.0f);
        [self.view addSubview:navbar];
    }

    // Right button is done when VC is presented
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = isPresented ? SYSBARBUTTON(UIBarButtonSystemItemDone, @selector(done:)) : nil;
    
    // Populate the navigation bar
    if (navbar)
        [navbar setItems:@[self.navigationItem] animated:NO];
    
    // Size the child VC view(s)
    CGFloat verticalOffset = (navbar != nil) ? 44.0f : 0.0f;
    CGRect destFrame = CGRectMake(0.0f, verticalOffset, self.view.frame.size.width, self.view.frame.size.height - verticalOffset);
    front.view.frame = destFrame;
    back.view.frame = destFrame;

    // Set up info button
    if (controllers.count < 2) return; // our work is done here
    
    // Create the "i" button
    infoButton = [UIButton buttonWithType:_prefersDarkInfoButton ? UIButtonTypeInfoDark : UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    // Place "i" button at bottom right of view
    CGSize frameSize = self.view.frame.size;
    infoButton.frame = CGRectMake(frameSize.width - 44.0f, frameSize.height - 44.0f, 44.0f, 44.0f);
    [self.view addSubview:infoButton];
}

// Sorry. No, really. Sorry.
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (controllers.count < 2) return;
    ((UIViewController *)controllers[1]).view.frame = ((UIViewController *)controllers[0]).view.frame;
}

- (void) loadView
{
    [super loadView];    
    self.view.backgroundColor = [UIColor blackColor];
}

// Return a newly initialized flip controller
- (id) initWithFrontController: (UIViewController *) front andBackController: (UIViewController *) back
{
    if (!(self = [super init])) return self;
    
    if (!front)
    {
        NSLog(@"Error: Attempting to create FlipViewController without a root controller.");
        return self;
    }
    
    if (back)
        controllers = @[front, back];
    else
        controllers = @[front];
    
    reversedOrder = NO;
    
    return self;
}
@end
