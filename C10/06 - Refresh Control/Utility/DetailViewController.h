/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    NSDictionary *dict;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *artistLabel;
    UIButton *button;
}
- (id) initWithDictionary: (NSDictionary *) aDictionary;
@end

