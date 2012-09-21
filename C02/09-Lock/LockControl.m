/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import "LockControl.h"
#import "Utility.h"

#define MIN_SIZE    256.0f

@implementation LockControl
- (UIImage *) swatch
{
    CGSize baseSize = CGSizeMake(MIN_SIZE, MIN_SIZE);
    CGRect baseBounds = (CGRect){.size = baseSize};
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:baseBounds cornerRadius:32.0f];

    UIGraphicsBeginImageContext(baseSize);
    [[[UIColor blackColor] colorWithAlphaComponent:0.3f] set];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGPoint) thumbStartPoint
{
    return CGPointMake(18.0f, 15.0f);
}

- (void) layoutSubviewsInternal
{
    UIImageView *backsplash = [[UIImageView alloc] initWithImage:[self swatch]];
    [self addSubview:backsplash];
    
    PREPCONSTRAINTS(backsplash);
    CONSTRAIN(self, backsplash, @"H:|[backsplash(>=0)]|");
    CONSTRAIN(self, backsplash, @"V:|[backsplash(>=0)]|");
    
    lockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockclosed-art.png"]];
    [self addSubview:lockView];
    
    PREPCONSTRAINTS(lockView);
    CONSTRAIN(lockView, lockView, @"H:[lockView(==87)]");
    CONSTRAIN(lockView, lockView, @"V:[lockView(==118)]");
    CONSTRAIN(self, lockView, @"V:|-35-[lockView]");
    CENTERH(self, lockView);
        
    trackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track.png"]];
    [self addSubview:trackView];
    
    PREPCONSTRAINTS(trackView);
    CONSTRAIN(trackView, trackView, @"H:[trackView(==201)]");
    CONSTRAIN(trackView, trackView, @"V:[trackView(==30)]");
    CENTERH(self, trackView);
    CONSTRAIN(self, trackView, @"V:[trackView]-30-|");
        
    thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb.png"]];
    [trackView addSubview:thumbView];
    
    PREPCONSTRAINTS(thumbView);
    thumbView.center = [self thumbStartPoint];
    CONSTRAIN(thumbView, thumbView, @"H:[thumbView(==24)]");
    CONSTRAIN(thumbView, thumbView, @"V:[thumbView(==24)]");
    CENTERV(trackView, thumbView);
}

- (id) initWithFrame: (CGRect) aFrame
{
    if (!(self = [super initWithFrame:aFrame])) return self;

	self.backgroundColor = [UIColor clearColor];
    [self layoutSubviewsInternal];
    value = 1;

    return self;
}

- (id) init
{
	return [self initWithFrame:CGRectZero];
}

+ (id) controlWithTarget:(id)target
{
	LockControl *control = [[self alloc] init];
    [control addTarget:target action:@selector(handleUnlock:) forControlEvents:UIControlEventValueChanged];
    return control;
}

- (BOOL) value
{
    return value;
}

- (void) setValue:(BOOL)newValue
{
    if (value == newValue) return;
    value = newValue;
    lockView.image = [UIImage imageNamed:value ? @"lockclosed-art.png" : @"lockopen-art.png"];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:self];
    CGRect largeTrack = CGRectInset(trackView.frame, -20.0f, -20.0f);
    if (!CGRectContainsPoint(largeTrack, touchPoint)) return NO;

    touchPoint = [touch locationInView:trackView];
    CGRect largeThumb = CGRectInset(thumbView.frame, -20.0f, -20.0f);
    if (!CGRectContainsPoint(largeThumb, touchPoint)) return NO;
    
	[self sendActionsForControlEvents:UIControlEventTouchDown];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:trackView];
    CGFloat trackStart = [self thumbStartPoint].x;
    CGFloat trackEnd = trackView.bounds.size.width * 0.97 - thumbView.bounds.size.width;
    
    CGFloat offset = touchPoint.x;
    offset = MAX(offset, trackStart);
    offset = MIN(offset, trackEnd);
    
    [UIView animateWithDuration:0.1f animations:^(){
        thumbView.center = CGPointMake(CGRectGetMidX(thumbView.bounds) + offset, CGRectGetMidY(trackView.bounds));
    }];

	return YES;
}

- (void) endTrackingWithTouch: (UITouch *)touch withEvent: (UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:trackView];
    CGFloat offset = touchPoint.x;
    if (offset > trackView.frame.size.width * 0.75f)
    {
        // complete, unlock, and fade away
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        self.value = NO;
        [UIView animateWithDuration:0.5f animations:^(){
            self.alpha = 0.0f;             
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        // fail - reset
        [UIView animateWithDuration:0.2f animations:^(){
            thumbView.center = [self thumbStartPoint];
        }];
    }

    if (CGRectContainsPoint(trackView.bounds, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else 
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}

- (void)cancelTrackingWithEvent: (UIEvent *) event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
