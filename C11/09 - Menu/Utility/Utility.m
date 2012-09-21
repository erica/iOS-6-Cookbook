/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

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
