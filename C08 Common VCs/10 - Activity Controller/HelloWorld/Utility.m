/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

UIImage *blockImage(NSString *aString)
{
    UIFont *font = [UIFont fontWithName:@"Futura" size:96.0f];
    CGSize size = [aString sizeWithFont:font];
    size.width += 40.0f;
    size.height += 40.0f;
    
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGRect bounds = (CGRect){.size = size};
    
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    [[UIColor blackColor] set];
    bounds = CGRectInset(bounds, 8.0f, 8.0f);
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, 8.0f);
    CGContextStrokePath(context);
    
    [[UIColor redColor] set];
    bounds = CGRectInset(bounds, 8.0f, 8.0f);
    [aString drawInRect:bounds withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

