/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "ImageCell.h"
#import "Utility.h"

@implementation ImageCell
- (id) initWithFrame:(CGRect)frame
{
    if (![super initWithFrame:frame]) return nil;
    
    self.backgroundColor = [UIColor clearColor];

    _imageView = [[UIImageView alloc] initWithFrame:(CGRect){.origin = CGPointMake(4.0f, 4.0f), .size=CGRectInset(frame, 4.0f, 4.0f).size}];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_imageView];
    
    return self;
}
@end

