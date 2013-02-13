/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

typedef enum
{
    GridRowAlignmentNone,
    GridRowAlignmentTop,
    GridRowAlignmentCenter,
    GridRowAlignmentBottom,
} GridRowAlignment;

@interface GridLayout : UICollectionViewFlowLayout

@property (nonatomic) GridRowAlignment alignment;

/* 
// If you want to subclass UICollectionViewLayout directly add these properties
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) UIEdgeInsets sectionInset;
*/
@end
