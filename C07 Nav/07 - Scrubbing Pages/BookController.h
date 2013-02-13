/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

// Used for storing the most recent book page used
#define DEFAULTS_BOOKPAGE   @"BookControllerMostRecentPage"

typedef enum
{
    BookLayoutStyleBook, // side by side in landscape
    BookLayoutStyleFlipBook, // side by side in portrait
    BookLayoutStyleHorizontalScroll,
    BookLayoutStyleVerticalScroll,
} BookLayoutStyle;

@protocol BookControllerDelegate <NSObject>
- (id) viewControllerForPage: (int) pageNumber;
@optional
- (NSInteger) numberOfPages; // primarily for scrolling layouts
- (void) bookControllerDidTurnToPage: (NSNumber *) pageNumber;
@end

@interface BookController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
+ (id) bookWithDelegate: (id) theDelegate;
+ (id) bookWithDelegate: (id) theDelegate style: (BookLayoutStyle) aStyle;
- (void) moveToPage: (uint) requestedPage;
- (int) currentPage;

@property (nonatomic, weak) id <BookControllerDelegate> bookDelegate;
@property (nonatomic) uint pageNumber;
@property (nonatomic) BookLayoutStyle layoutStyle;
@end