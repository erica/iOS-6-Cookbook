/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <UIKit/UIKit.h>
#import "DragView.h"

@interface PullView : UIImageView <UIGestureRecognizerDelegate>
{
	DragView *dv;
	BOOL gestureWasHandled;
	int pointCount;
	CGPoint startPoint;
	NSUInteger touchtype;
}
@end