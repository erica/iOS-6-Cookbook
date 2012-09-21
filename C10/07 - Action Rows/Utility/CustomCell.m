/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
*/

#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"
#import "Utility.h"

@implementation CustomCell
- (void) setupButton: (UIButton *) aButton withTitle: (NSString *) aTitle withOffset: (CGFloat) anOffset
{
    [aButton setTitle:aTitle forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    aButton.frame = CGRectMake(anOffset, 35.0f, 0.0f, 0.0f);
    [aButton sizeToFit];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.contentView.backgroundColor = [UIColor darkGrayColor];
    
    titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleButton.tag = CustomCellActionTitle;
    [self setupButton:titleButton withTitle:@"Title" withOffset:35.0f];
    [self.contentView addSubview:titleButton];
    
    alertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self setupButton:alertButton withTitle:@"Alert" withOffset:135.0f];
    alertButton.tag = CustomCellActionAlert;
    [self.contentView addSubview:alertButton];
    
    return self;
}

- (void) setActionTarget:(id)target
{
    if ([target respondsToSelector:@selector(buttonPushed:)])
    {
        [titleButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [titleButton addTarget:target action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [alertButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [alertButton addTarget:target action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
