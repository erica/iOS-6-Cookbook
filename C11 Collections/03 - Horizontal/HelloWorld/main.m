/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface InsetCollectionView : UIView <UICollectionViewDataSource>
@property (strong, readonly) UICollectionView *collectionView;
@end

@implementation InsetCollectionView
#pragma mark -
#pragma mark Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UIImageView *) viewForIndexPath: (NSIndexPath *) indexPath
{
    NSString *string = [NSString stringWithFormat:@"S%d(%d)", indexPath.section, indexPath.item];
    UIImage *image = blockStringImage(string, 16.0f);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    if ([cell viewWithTag:999])
        [[cell viewWithTag:999] removeFromSuperview];
    
    UIImageView *imageView = [self viewForIndexPath:indexPath];
    imageView.tag = 999;
    
    [cell.contentView addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(cell.contentView, imageView);
    
	return cell;
}

#pragma mark -
#pragma mark Setup

- (id) initWithFrame:(CGRect)frame
{
    if (!([super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 40.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.itemSize = CGSizeMake(100.0f, 100.0f);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor darkGrayColor];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    PREPCONSTRAINTS(_collectionView);
    CONSTRAIN(self, _collectionView, @"H:|[_collectionView(>=0)]|");
    CONSTRAIN(self, _collectionView, @"V:|-20-[_collectionView(>=0)]-20-|");

    return self;
}
    
@end

@interface TestBedViewController : UIViewController
{
    InsetCollectionView *cv;
}
@end

@implementation TestBedViewController

#pragma mark -
#pragma mark Setup

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor lightGrayColor];

    cv = [[InsetCollectionView alloc] initWithFrame:CGRectZero];
    cv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cv];
    
    PREPCONSTRAINTS(cv);
    CONSTRAIN(self.view, cv, @"H:|[cv(>=0)]|");
    CONSTRAIN(self.view, cv, @"V:|-[cv(==200)]");
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    srand(time(0));
    
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}