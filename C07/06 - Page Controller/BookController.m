/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "BookController.h"

#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define SAFE_ADD(_Array_, _Object_) {if (_Object_ && [_Array_ isKindOfClass:[NSMutableArray class]]) [pageControllers addObject:_Object_];}
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)


#pragma Book Controller
@implementation BookController

#pragma mark Utility

- (int) currentPage
{
    int pageCheck = ((UIViewController *)[self.viewControllers objectAtIndex:0]).view.tag;
    return pageCheck;
}


#pragma mark Presentation indices for page indicator (Data Source)

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // Slightly borked in iOS 6 beta
    // return [self currentPage];
    return 0;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    if (_bookDelegate && [_bookDelegate respondsToSelector:@selector(numberOfPages)])
       return [_bookDelegate numberOfPages];
    
    return 0;
}

#pragma mark Page Handling

// Update if you'd rather use some other decision style
- (BOOL) useSideBySide: (UIInterfaceOrientation) orientation
{
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    switch (_layoutStyle)
    {
        case BookLayoutStyleHorizontalScroll:
        case BookLayoutStyleVerticalScroll: return NO;
        case BookLayoutStyleFlipBook: return !isLandscape;
        default: return isLandscape;
    }
}

// Store the new page and update the delgate
- (void) updatePageTo: (uint) newPageNumber
{
    _pageNumber = newPageNumber;
    
    // Update to Cloud?
    [[NSUserDefaults standardUserDefaults] setInteger:_pageNumber forKey:DEFAULTS_BOOKPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];

    SAFE_PERFORM_WITH_ARG(_bookDelegate, @selector(bookControllerDidTurnToPage:), @(_pageNumber));
}

// Request controller from delegate
- (UIViewController *) controllerAtPage: (int) aPageNumber
{
    if (_bookDelegate && 
        [_bookDelegate respondsToSelector:@selector(viewControllerForPage:)])
    {
        UIViewController *controller = [_bookDelegate viewControllerForPage:aPageNumber];
        controller.view.tag = aPageNumber;
        return controller;
    }
    return nil;
}

// Update interface to the given page
- (void) fetchControllersForPage: (uint) requestedPage orientation: (UIInterfaceOrientation) orientation
{
    BOOL sideBySide = [self useSideBySide:orientation];
    int numberOfPagesNeeded = sideBySide ? 2 : 1;
    int currentCount = self.viewControllers.count;
    
    uint leftPage = requestedPage;
    if (sideBySide && (leftPage % 2))
        leftPage = floor(leftPage / 2) * 2;
    
    // Only check against current page when count is appropriate
    if (currentCount && (currentCount == numberOfPagesNeeded))
    {
        if (_pageNumber == requestedPage) return;
        if (_pageNumber == leftPage) return;
    }
    
    // Decide the prevailing direction by checking the new page against the old
    UIPageViewControllerNavigationDirection direction = (requestedPage > _pageNumber) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    // Update the controllers
    NSMutableArray *pageControllers = [NSMutableArray array];
    SAFE_ADD(pageControllers, [self controllerAtPage:leftPage]);    
    if (sideBySide)
        SAFE_ADD(pageControllers, [self controllerAtPage:leftPage + 1]);
    
    [self setViewControllers:pageControllers direction: direction animated:YES completion:nil];
    [self updatePageTo:leftPage];
}

// Entry point for external move request
- (void) moveToPage: (uint) requestedPage
{
    // Thanks Dino Lupo
    [self fetchControllersForPage:requestedPage orientation:(UIInterfaceOrientation)self.interfaceOrientation];
}

#pragma mark Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    [self updatePageTo:_pageNumber + 1];
    return [self controllerAtPage:(viewController.view.tag + 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self updatePageTo:_pageNumber - 1];
    return [self controllerAtPage:(viewController.view.tag - 1)];
}

#pragma mark Delegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    NSUInteger indexOfCurrentViewController = 0;
    if (self.viewControllers.count)
        indexOfCurrentViewController = ((UIViewController *)[self.viewControllers objectAtIndex:0]).view.tag;
    [self fetchControllersForPage:indexOfCurrentViewController orientation:orientation];
    
    BOOL sideBySide = [self useSideBySide:orientation];
    UIPageViewControllerSpineLocation spineLocation = sideBySide ? UIPageViewControllerSpineLocationMid : UIPageViewControllerSpineLocationMin;
    self.doubleSided = sideBySide;
    return spineLocation;
}

#pragma mark Class utility routines
// Return a new book
+ (id) bookWithDelegate: (id) theDelegate style: (BookLayoutStyle) aStyle
{
    // Determine orientation
    UIPageViewControllerNavigationOrientation orientation = UIPageViewControllerNavigationOrientationHorizontal;
    if ((aStyle == BookLayoutStyleFlipBook) || (aStyle == BookLayoutStyleVerticalScroll))
        orientation = UIPageViewControllerNavigationOrientationVertical;
    
    // Determine transitionStyle
    UIPageViewControllerTransitionStyle transitionStyle = UIPageViewControllerTransitionStylePageCurl;
    if ((aStyle == BookLayoutStyleHorizontalScroll) || (aStyle == BookLayoutStyleVerticalScroll))
        transitionStyle = UIPageViewControllerTransitionStyleScroll;
    
    // Pass options as a dictionary. Keys are spine location (curl) and spacing (scroll)
    BookController *bc = [[BookController alloc] initWithTransitionStyle:transitionStyle navigationOrientation:orientation options:nil];
    
    bc.layoutStyle = aStyle;
    bc.dataSource = bc;
    bc.delegate = bc;
    bc.bookDelegate = theDelegate;
    
    return bc;
}

+ (id) bookWithDelegate: (id) theDelegate
{
    return [self bookWithDelegate:theDelegate style:BookLayoutStyleBook];
}
@end
