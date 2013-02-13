/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "RibbonPull.h"
#import <AudioToolbox/AudioToolbox.h>

// Return the alpha byte offset
static NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 0;}

// Return a byte array of image
NSData *getBitmapFromImage (UIImage *image)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
	
	CGSize size = image.size;
	Byte *bitmapData = calloc(size.width * size.height * 4, 1); // Courtesy of Dirk. Thanks!
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Error: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
	
    CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bitmapData);
		return NULL;
    }
	
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	CGContextDrawImage(context, rect, image.CGImage);
	Byte *data = CGBitmapContextGetData(context);
	CGContextRelease(context);
    
    NSData *bytes = [NSData dataWithBytes:data length:size.width * size.height * 4];
    free(bitmapData);
	
    return bytes;
}

@implementation RibbonPull
- (id) initWithFrame: (CGRect) aFrame
{
	if (!(self = [super initWithFrame:aFrame])) return nil;

    self.frame = CGRectMake(0.0f, 0.0f, 60.0f, 175.0f);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    ribbonImage = [UIImage imageNamed:@"Ribbon.png"];
    ribbonData = getBitmapFromImage(ribbonImage);
    
    pullImageView = [[UIImageView alloc] initWithImage:ribbonImage];
    pullImageView.frame = CGRectMake(0.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
    
    // Initialize a wiggle count to draw attention to the control
    wiggleCount = 0;
    
    [self addSubview:pullImageView];
    [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0f];
   
    return self;
}

- (id) init
{
	return [self initWithFrame:CGRectZero];
}

+ (id) control
{
	return [[self alloc] init];
}

/*
 
 DISCOVERABILITY
 
 */


- (void) wiggle
{
    if (++wiggleCount > 3) return;
    
    [UIView animateWithDuration:0.25f animations:^(){
        pullImageView.center = CGPointMake(pullImageView.center.x, pullImageView.center.y + 10.0f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.25f animations:^(){
            pullImageView.center = CGPointMake(pullImageView.center.x, pullImageView.center.y - 10.0f);
        }];
    }];
    
    [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0f];
}

/*
 
 CLICK SOUND
 
 */

void _systemSoundDidComplete(SystemSoundID ssID, void *clientData)
{
    AudioServicesDisposeSystemSoundID(ssID);
}

- (void) playClick
{
    NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    CFURLRef baseURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndpath]);
    
    SystemSoundID sysSound;
    AudioServicesCreateSystemSoundID(baseURL, &sysSound);
    CFRelease(baseURL);
    
    AudioServicesAddSystemSoundCompletion(sysSound, NULL, NULL, _systemSoundDidComplete, NULL);
	AudioServicesPlaySystemSound(sysSound);
}

/*
 
 TOUCH TRACKING
 
 */

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    Byte *bytes = (Byte *) ribbonData.bytes;
    
	// Establish touch down event
	CGPoint touchPoint = [touch locationInView:self];
    CGPoint ribbonPoint = [touch locationInView:pullImageView];
    
    uint offset = alphaOffset(ribbonPoint.x, ribbonPoint.y, pullImageView.bounds.size.width);
    
    // Test for containment and alpha
    if (CGRectContainsPoint(pullImageView.frame, touchPoint) &&
        (bytes[offset] > 85))
    {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        touchDownPoint = touchPoint;
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Once the user has figured this out, don't wiggle any more
    wiggleCount = 999;
    
    CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.frame, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    else 
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    
    // Adjust art
    CGFloat dy = MAX(touchPoint.y - touchDownPoint.y, 0.0f);
    dy = MIN(dy, self.bounds.size.height - 75.0f);
    
    pullImageView.frame = CGRectMake(0.0f, dy + 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
    
    // Detect if travel has been sufficient to trigger everything
    if (dy > 75.0f)
    {
        [self playClick];
        [UIView animateWithDuration:0.3f animations:^(){
            pullImageView.frame = CGRectMake(0.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
        } completion:^(BOOL finished){
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }];
        return NO; 
    }

	return YES;
}

- (void) endTrackingWithTouch: (UITouch *)touch withEvent: (UIEvent *)event
{
    // Test if touch ended inside or outside
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else 
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    
    [UIView animateWithDuration:0.3f animations:^(){
        pullImageView.frame = CGRectMake(0.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
    }];
}


- (void)cancelTrackingWithEvent: (UIEvent *) event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
