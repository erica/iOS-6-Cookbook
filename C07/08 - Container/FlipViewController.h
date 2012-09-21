/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <UIKit/UIKit.h>

@interface FlipViewController : UIViewController
{
    UINavigationBar  *navbar;
    UIButton *infoButton;
    NSArray *controllers;
    BOOL reversedOrder;
}

@property (nonatomic) BOOL prefersDarkInfoButton;

- (id) initWithFrontController: (UIViewController *) front andBackController: (UIViewController *) back;
@end
