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
@property (nonatomic, readonly) NSArray *filteredArray;

- (NSString *) colorNameAtIndexPath: (NSIndexPath *) path;
- (UIColor *) colorAtIndexPath: (NSIndexPath *) path;
- (UIColor *) colorNamed: (NSString *) aColor;
- (NSInteger) countInSection: (NSInteger) section;
- (NSString *) nameForSection: (NSInteger) section;
- (NSInteger) filterWithString: (NSString *) filter;
@end
