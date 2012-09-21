/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@interface DataManager : NSObject
{
    TreeNode *root;
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, readonly) NSMutableArray *entries;
- (void) loadData;
@end
