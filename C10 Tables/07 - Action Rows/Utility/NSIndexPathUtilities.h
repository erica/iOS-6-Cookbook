/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define INDEXPATH(SECTION, ROW) [NSIndexPath indexPathForRow:ROW inSection:SECTION]

@interface NSIndexPath (adjustments)

// Is this index path before the other
- (BOOL) before: (NSIndexPath *) path;

@property (nonatomic, readonly) NSIndexPath *next;
@property (nonatomic, readonly) NSIndexPath *previous;
@end
