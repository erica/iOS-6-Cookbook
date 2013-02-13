//
//  CircleRecognizer.h
//  HelloWorld
//
//  Created by Erica Sadun on 6/18/12.
//  Copyright (c) 2012 Erica Sadun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleRecognizer : UIGestureRecognizer
{
	NSMutableArray *points;	
	NSDate *firstTouchDate;
}
@end