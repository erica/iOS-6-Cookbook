/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "GridLayout.h"
#import "ImageCell.h"
#import "Utility.h"

@interface TestBedViewController : UICollectionViewController
{
    NSMutableDictionary *artDictionary;
    UIFont *baseFont;
}
@end

@implementation TestBedViewController
#pragma mark -
#pragma mark Flow layout

#define BASE_SIZE   120.0f

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(BASE_SIZE, BASE_SIZE);
    // return CGSizeMake(BASE_SIZE + 20.0f * indexPath.item, BASE_SIZE + 20.0f * indexPath.item);
}

#pragma mark -
#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
    // return 1 + section; // for stairstep
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ImageCell *cell = (ImageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat size = BASE_SIZE; //  + 20.0f * indexPath.item;
    
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        NSString *indexString = [NSString stringWithFormat:@"[S%d, I%d]", indexPath.section, indexPath.item];
        image = stringImageTinted(indexString, baseFont, size);
        artDictionary[indexPath] = image;
    }
    
    cell.imageView.image = image;

	return cell;
}

#pragma mark -
#pragma mark Delegate methods

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected %@", indexPath);
    self.title = [NSString stringWithFormat:@"%d items selected", [aCollectionView indexPathsForSelectedItems].count];
}

- (void)collectionView:(UICollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deselected %@", indexPath);
    self.title = [NSString stringWithFormat:@"%d items selected", [aCollectionView indexPathsForSelectedItems].count];
}

#pragma mark -
#pragma mark Setup

- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout
{
    if (!(self = [super initWithCollectionViewLayout:layout])) return nil;
    artDictionary = [NSMutableDictionary dictionary];
    baseFont = [UIFont fontWithName:@"Futura" size: IS_IPAD? 18.0f : 24.0f];
    return self;
}

- (void) viewDidLoad
{
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];

    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.allowsSelection = NO;
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
    
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GridLayout *layout = [[GridLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    layout.minimumInteritemSpacing = 20.0f;
    layout.minimumLineSpacing = 20.0f;
    layout.alignment = GridRowAlignmentCenter;
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