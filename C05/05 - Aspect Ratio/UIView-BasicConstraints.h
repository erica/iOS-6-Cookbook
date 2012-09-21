/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <Foundation/Foundation.h>

@interface UIView (BasicConstraints)
- (void) showConstraints;

- (void) centerHorizontallyInSuperview;
- (void) centerVerticallyInSuperview;

- (void) constrainWithinSuperviewBounds;
- (void) constrainSelfToSize:(CGSize)aSize;
@end

