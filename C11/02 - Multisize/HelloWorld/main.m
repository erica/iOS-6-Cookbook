/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "ImageCell.h"
#import "Utility.h"

@interface TestBedViewController : UICollectionViewController
{
    NSArray *wordArray;
    NSMutableDictionary *artDictionary;
}
@end

@implementation TestBedViewController

#pragma mark -
#pragma mark Utility

- (NSString *) itemAtIndexPath: (NSIndexPath *) indexPath
{
    NSArray *subArray = wordArray[indexPath.section];
    return subArray[indexPath.row];
}

- (UIImage *) imageForString: (NSString *) aString
{
    NSArray *fontFamilies = [UIFont familyNames];
    NSString *fontName = fontFamilies[rand() % fontFamilies.count];
    CGFloat fontSize = (IS_IPAD ? 18.0f : 12.0f) + (rand() % 10);
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    UIImage *image = stringImageTinted(aString, font, 10.0f);
    return image;
}

#pragma mark -
#pragma mark Flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        NSString *item = [self itemAtIndexPath:indexPath];
        image = [self imageForString:item];
        artDictionary[indexPath] = image;
    }
    
    // Add some random fun
    // CGFloat zoom = 1.0f + ((rand() % 20) / 40.0f);
    CGFloat zoom = 1.0f;
    
    return CGSizeMake(image.size.width * zoom, image.size.height * zoom);
}

#pragma mark -
#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return wordArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *subArray = wordArray[section];
    return subArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ImageCell *cell = (ImageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    NSString *item = [self itemAtIndexPath:indexPath];
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        image = [self imageForString:item];
        artDictionary[indexPath] = image;
    }
    cell.imageView.image = image;
    cell.contentView.frame = (CGRect){.size = image.size};
    
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
    
    wordArray = @[
    [@"lorem ipsum dolor sit amet consectetur adipiscing elit" componentsSeparatedByString:@" "],
    [@"cras varius ultricies elit" componentsSeparatedByString:@" "],
    [@"a tincidunt sem vehicula in" componentsSeparatedByString:@" "],
    [@"nullam pellentesque elit nec ligula ultrices vitae ultricies erat interdum" componentsSeparatedByString:@" "],
    [@"integer ut elit aliquam eros fermentum ornare vel vitae erat" componentsSeparatedByString:@" "],
    [@"pellentesque habitant morbi tristique senectus" componentsSeparatedByString:@" "],
    [@"enenatis tincidunt lorem sed suscipit" componentsSeparatedByString:@" "],
    ];
    artDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

- (void) viewDidLoad
{
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];

    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = YES;
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 50.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.itemSize = CGSizeMake(50.0f, 50.0f);
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