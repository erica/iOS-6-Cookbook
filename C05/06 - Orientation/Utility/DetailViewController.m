/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "DetailViewController.h"
#import "Utility.h"

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
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(imageView, titleLabel, artistLabel, button);
    
    if (IS_IPAD || UIDeviceOrientationIsPortrait(newOrientation) || (newOrientation == UIDeviceOrientationUnknown))
    {
        for (UIView *view in @[imageView, titleLabel, artistLabel, button])
            CENTER_VIEW_H(self.view, view);
        CONSTRAIN_VIEWS(self.view, @"V:|-[imageView]-30-[titleLabel(>=0)]-[artistLabel]-15-[button]-(>=0)-|", bindings);
    }
    else
    {
        // Center image view on left
        CENTER_VIEW_V(self.view, imageView);

        // Lay out remaining views
        CONSTRAIN(self.view, imageView, @"H:|-[imageView]");
        CONSTRAIN(self.view, titleLabel, @"H:[titleLabel]-15-|");
        CONSTRAIN(self.view, artistLabel, @"H:[artistLabel]-15-|");
        CONSTRAIN(self.view, button, @"H:[button]-15-|");
        CONSTRAIN_VIEWS(self.view, @"V:|-(>=0)-[titleLabel(>=0)]-[artistLabel]-15-[button]-|", bindings);

        // Make sure titleLabel doesn't overlap
        CONSTRAIN_VIEWS(self.view, @"H:[imageView]-(>=0)-[titleLabel]", bindings);
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    newOrientation = toInterfaceOrientation;
    [self updateViewConstraints];
}

- (void) viewDidAppear:(BOOL)animated
{
    newOrientation = self.interfaceOrientation;
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
    
    newOrientation = UIDeviceOrientationUnknown;
}

@end

