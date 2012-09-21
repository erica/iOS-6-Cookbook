/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <UIKit/UIKit.h>

@interface TOUCHkitView : UIView 
{
	NSSet *touches;
}
@property (strong) UIColor *touchColor;

+ (id) sharedInstance;
@end
