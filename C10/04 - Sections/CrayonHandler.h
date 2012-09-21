/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

@interface CrayonHandler : NSObject
{
    NSMutableDictionary *crayonColors;
    NSMutableArray *sectionArray;
}
@property (nonatomic, readonly) NSInteger numberOfSections;

- (NSString *) colorNameAtIndexPath: (NSIndexPath *) path;
- (UIColor *) colorAtIndexPath: (NSIndexPath *) path;
- (NSInteger) countInSection: (NSInteger) section;
- (NSString *) nameForSection: (NSInteger) section;
@end
