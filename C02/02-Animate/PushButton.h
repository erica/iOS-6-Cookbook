/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

@interface PushButton : UIButton
{
    BOOL isOn;
}

@property (nonatomic, assign) BOOL isOn;

+ (id) button;

@end
