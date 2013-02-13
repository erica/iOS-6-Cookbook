/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CircleLayout.h"
#import "Utility.h"

UIColor *randomColor()
{
    return [UIColor colorWithRed:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                           green:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                            blue:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                           alpha:1.0f];
}

@interface TestBedViewController : UICollectionViewController
{
    NSInteger count;
}
@end

@implementation TestBedViewController

#pragma mark -
#pragma mark Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = randomColor();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:circleInBlock(80.0f)];
    cell.selectedBackgroundView = imageView;
    
	return cell;
}

#pragma mark - 
#pragma mark Editing

- (void) add
{
    int itemNumber = 0;
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    if (selectedItems.count)
        itemNumber = ((NSIndexPath *)selectedItems[0]).item + 1;
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemNumber inSection:0];

    count += 1;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[itemPath]];
    } completion:^(BOOL done){
        [self.collectionView selectItemAtIndexPath:itemPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = (count < (IS_IPAD ? 20 : 8));
    }];
}

- (void) reenableDeleteButton
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) delete
{
    if (!count) return;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self performSelector:@selector(reenableDeleteButton) withObject:nil afterDelay:0.15f];
    
    count -= 1;
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    NSInteger itemNumber;
    itemNumber = selectedItems.count ? ((NSIndexPath *)selectedItems[0]).item : 0;
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemNumber inSection:0];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[itemPath]];
    } completion:^(BOOL done){
        if (count)
            [self.collectionView selectItemAtIndexPath: [NSIndexPath indexPathForItem:MAX(0, itemNumber - 1) inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        self.navigationItem.rightBarButtonItem.enabled = (count != 0);
        self.navigationItem.leftBarButtonItem.enabled = (count < (IS_IPAD ? 20 : 8));
    }];
}

#pragma mark -
#pragma mark Delegate methods

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark -
#pragma mark Setup

- (void) viewDidLoad
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Add", @selector(add));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Delete", @selector(delete));
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    srand(time(0));
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    CircleLayout *layout = [[CircleLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 50.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.itemSize = CGSizeMake(80.0f, 80.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	TestBedViewController *tbvc = [[TestBedViewController alloc] initWithCollectionViewLayout:layout];
    
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