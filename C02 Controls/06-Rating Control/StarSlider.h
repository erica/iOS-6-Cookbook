/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <UIKit/UIKit.h>

@interface StarSlider : UIControl
{
	int value; // from 0 to 5
}
@property (nonatomic, assign) int value;
+ (id) control;
@end
