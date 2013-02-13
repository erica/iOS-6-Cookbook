/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "ColorControl.h"


@implementation ColorControl

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
	
	_value = nil;
	self.backgroundColor = [UIColor grayColor];
	
    return self;
}

- (void) updateColorFromTouch: (UITouch *) touch
{
	// Calculate hue and saturation
	CGPoint touchPoint = [touch locationInView:self];
	float hue = touchPoint.x / self.frame.size.width;
	float saturation = touchPoint.y / self.frame.size.height;
	
	// Update the color value and change background color
	self.value = [UIColor colorWithHue:hue saturation:saturation brightness:1.0f alpha:1.0f];
	self.backgroundColor = self.value;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

// Continue tracking touch in control
- (BOOL) continueTrackingWithTouch: (UITouch *) touch withEvent: (UIEvent *) event
{
	// Test if drag is currently inside or outside
	CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.bounds, touchPoint))
		[self sendActionsForControlEvents:UIControlEventTouchDragInside];
	else 
		[self sendActionsForControlEvents:UIControlEventTouchDragOutside];
	
	// Update color value
	[self updateColorFromTouch:touch];

	return YES;
}

// Start tracking touch in control
- (BOOL) beginTrackingWithTouch: (UITouch *) touch withEvent: (UIEvent *) event
{
	// Touch Down
	[self sendActionsForControlEvents:UIControlEventTouchDown];
	
	// Update color value
	[self updateColorFromTouch:touch];
	
	return YES;
}

// End tracking touch
- (void) endTrackingWithTouch: (UITouch *)touch withEvent: (UIEvent *)event
{
	// Test if touch ended inside or outside
	CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.bounds, touchPoint))
		[self sendActionsForControlEvents:UIControlEventTouchUpInside];
	else 
		[self sendActionsForControlEvents:UIControlEventTouchUpOutside];
	
	// Update color value
	[self updateColorFromTouch:touch];
}


// Handle touch cancel
- (void)cancelTrackingWithEvent: (UIEvent *) event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}


- (void)dealloc 
{
	self.value = nil;
}
@end
