/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (BasicConstraints)
// Visual format -- These *must* refer to [self] & superview only
- (NSArray *) constraintsForVisualFormat: (NSString *) aVisualFormat withMetrics: (NSDictionary *) metrics;
- (NSArray *) constraintsForVisualFormat: (NSString *) aVisualFormat;
- (void) addVisualFormat: (NSString *) aVisualFormat;
- (void) removeVisualFormat: (NSString *) aVisualFormat;

// Debug
- (NSString *) constraintRepresentation: (NSLayoutConstraint *) aConstraint;
- (void) showConstraints;
@property (nonatomic, readonly, strong) NSString *debugName;

// Constraint testing
- (BOOL) constraint: (NSLayoutConstraint *) constraint1 matches: (NSLayoutConstraint *) constraint2;
- (NSLayoutConstraint *) constraintMatchingConstraint: (NSLayoutConstraint *) aConstraint;
- (void) removeMatchingConstraint: (NSLayoutConstraint *) aConstraint;
- (void) removeMatchingConstraints: (NSArray *) anArray;

// Flexible sizing
- (NSArray *) stretchConstraints: (NSLayoutFormatOptions) anAlignment;
- (NSArray *) stretchConstraints: (NSLayoutFormatOptions) anAlignment withEdgeInset: (CGFloat) anInset;
- (void) stretchAlongAxes: (NSLayoutFormatOptions) anAlignment;
- (void) stretchAlongAxes: (NSLayoutFormatOptions) anAlignment withEdgeInset: (CGFloat) anInset;
- (void) fitToHeightWithInset: (CGFloat) anInset;
- (void) fitToWidthWithInset: (CGFloat) anInset;

// Alignment and Centering
- (NSArray *) alignmentConstraints: (NSLayoutFormatOptions) anAlignment;
- (void) setAlignmentInSuperview: (NSLayoutFormatOptions) anAlignment;
- (NSLayoutConstraint *) horizontalCenteringConstraint;
- (NSLayoutConstraint *) verticalCenteringConstraint;
- (void) centerHorizontallyInSuperview;
- (void) centerVerticallyInSuperview;

// Superview bounds limits
- (NSArray *) constraintsLimitingViewToSuperviewBounds;
- (void) constrainWithinSuperviewBounds;
- (void) addSubviewAndConstrainToBounds:(UIView *)view;

// Size, Position, and Aspect
- (NSArray *) sizeConstraints: (CGSize) aSize;
- (NSArray *) positionConstraints: (CGPoint) aPoint;
- (NSLayoutConstraint *) aspectConstraint: (CGFloat) aspectRatio;
- (void) constrainSize:(CGSize)aSize;
- (void) constrainPosition: (CGPoint)aPoint; // w/in superview bounds
- (void) constrainAspectRatio: (CGFloat) aspectRatio;

// Testing only
- (void) layoutItems: (NSArray *) viewArray usingInsets: (BOOL) useInsets horizontally: (BOOL) horizontally;
@end

