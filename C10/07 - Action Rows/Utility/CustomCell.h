/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

typedef enum
{
    CustomCellActionNone,
    CustomCellActionTitle,
    CustomCellActionAlert,
} CustomCellActions;

@interface CustomCell : UITableViewCell
{
    UIButton *titleButton;
    UIButton *alertButton;
}
- (void) setActionTarget:(id)target;
@end
