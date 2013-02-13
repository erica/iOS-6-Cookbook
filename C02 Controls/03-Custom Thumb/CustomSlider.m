/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import "CustomSlider.h"
#import "Thumb.h"

@implementation CustomSlider
// Update the thumb images as needed
- (void) updateThumb
{
	// Only update the thumb when registering significant changes, i.e. 10%
	if ((self.value < 0.98) && (ABS(self.value - previousValue) < 0.1f)) return;
	
	// create a new custom thumb image and use it for the highlighted state
    UIImage *customimg = thumbWithLevel(self.value);
	[self setThumbImage: customimg forState: UIControlStateHighlighted];
	previousValue = self.value;
}

// Expand the slider to accommodate the bigger thumb
- (void) startDrag: (UISlider *) aSlider
{
	self.frame = CGRectInset(self.frame, 0.0f, -30.0f);
}

// At release, shrink the frame back to normal
- (void) endDrag: (UISlider *) aSlider
{
    self.frame = CGRectInset(self.frame, 0.0f, 30.0f);
}

- (id) initWithFrame:(CGRect) aFrame
{
    if (!(self = [super initWithFrame:aFrame]))
        return self;
    
    // Initialize slider settings
	previousValue = -99.0f;
    self.value = 0.0f;

    [self setThumbImage:simpleThumb() forState:UIControlStateNormal];
    
    // Create the callbacks for touch, move, and release
	[self addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(updateThumb) forControlEvents:UIControlEventValueChanged];
	[self addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    
    return self;
}

+ (id) slider
{
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:(CGRect){.size=CGSizeMake(200.0f, 40.0f)}];
    
    return slider;
}
@end
