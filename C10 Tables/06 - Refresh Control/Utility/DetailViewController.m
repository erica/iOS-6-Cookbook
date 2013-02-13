/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "DetailViewController.h"
#define CONSTRAIN(FORMAT) [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:views]]
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

#define CENTERH(VIEW) [self.view addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
#define CENTERV(VIEW) [self.view addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@implementation DetailViewController
- (id) initWithDictionary: (NSDictionary *) aDictionary
{
    if (!(self = [super init])) return nil;
    
    dict = aDictionary;
    
    return self;
}

// Only works on-device. Invalid in simulator.
- (void) buy
{
    NSString *address = dict[@"address"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
}

- (void) updateViewConstraints
{
    [super updateViewConstraints];
    [self.view removeConstraints:self.view.constraints];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, titleLabel, artistLabel, button);
    
    if (IS_IPAD || (UIDeviceOrientationIsPortrait(self.interfaceOrientation)))
    {
        for (UIView *view in @[imageView, titleLabel, artistLabel, button])
            CENTERH(view);
        CONSTRAIN(@"V:|-[imageView]-30-[titleLabel(>=0)]-[artistLabel]-15-[button]-(>=0)-|");
    }
    else
    {
        CENTERV(imageView);
        CONSTRAIN(@"H:|-[imageView]");
        CONSTRAIN(@"H:[titleLabel]-15-|");
        CONSTRAIN(@"H:[artistLabel]-15-|");
        CONSTRAIN(@"H:[button]-15-|");
        CONSTRAIN(@"V:|-(>=0)-[titleLabel(>=0)]-[artistLabel]-15-[button]-|");

        // Make sure titleLabel doesn't overlap
        CONSTRAIN(@"H:[imageView]-(>=0)-[titleLabel]");
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateViewConstraints];
}

- (UILabel *) labelWithTitle: (NSString *) aTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = aTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura" size:20.0f];
    label.numberOfLines = 999;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = dict[@"large image"];
    imageView = [[UIImageView alloc] initWithImage:image];
    
    titleLabel = [self labelWithTitle:dict[@"name"]];
    artistLabel = [self labelWithTitle:dict[@"artist"]];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:dict[@"price"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *view in @[imageView, titleLabel, artistLabel, button])
    {
        [self.view addSubview:view];
        PREPCONSTRAINTS(view);
    }
    
    // Set aspect ratio for image view
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
}

@end

