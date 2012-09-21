/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

@interface RibbonPull : UIControl
{
    NSData *ribbonData;
    UIImage *ribbonImage;
    UIImageView *pullImageView;
    CGPoint touchDownPoint;
    int wiggleCount;
}
+ (id) control;
@end
