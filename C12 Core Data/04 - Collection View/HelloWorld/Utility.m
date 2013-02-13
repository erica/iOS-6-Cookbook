/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

UIImage *stringImage(NSString *string, UIFont *aFont, CGFloat inset)
{
    CGSize baseSize = [string sizeWithFont:aFont];
    CGSize adjustedSize = CGSizeMake(baseSize.width + inset * 2, baseSize.height + inset * 2);
    
	UIGraphicsBeginImageContext(adjustedSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop
    CGRect bounds = (CGRect){.size = adjustedSize};
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    // Draw a black edge
    [[UIColor blackColor] set];
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, inset);
    CGContextStrokePath(context);

    // Draw the string in black
    CGRect insetBounds = CGRectInset(bounds, inset, inset);
    [string drawInRect:insetBounds withFont:aFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


UIImage *circleInBlock(CGFloat aSize)
{
    CGSize size = CGSizeMake(aSize, aSize);
    CGRect bounds = (CGRect){.size = size};
    CGRect inset = CGRectInset(bounds, aSize * 0.25, aSize * 0.25);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.5f] set];
    CGContextFillEllipseInRect(context, inset);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
