/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "PunchedLayout.h"
#import "ReflectingView.h"
#import "Utility.h"

@interface TestBedViewController : UICollectionViewController
{
    NSMutableDictionary *artDictionary;
    CGPoint desiredPoint;
}
@end

@implementation TestBedViewController
#pragma mark -
#pragma mark Flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(251.0f, 246.0f);
}

#pragma mark -
#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        image = blockImage();
        artDictionary[indexPath] = image;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (![cell.contentView viewWithTag:99])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 98;
        
        ReflectingView *rv = [[ReflectingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageView.frame.size.width, imageView.frame.size.height + 20.0f)];
        [rv setupReflection];
        rv.tag = 99;
        
        [cell.contentView addSubview:rv];
        [rv addSubview:imageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:98];
    imageView.image = image;

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

// Workaround for edge conditions. Hat tip Nicolas Goles
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (CGPointEqualToPoint(desiredPoint, CGRectNull.origin))
        return;
    
    CGRect rect = scrollView.bounds;
    rect.origin = desiredPoint;
    [self.collectionView scrollRectToVisible:rect animated:YES];
    
    desiredPoint = CGRectNull.origin;
}

#pragma mark -
#pragma mark Setup

- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout
{
    if (!(self = [super initWithCollectionViewLayout:layout])) return nil;
    artDictionary = [NSMutableDictionary dictionary];
    return self;
}

- (void) viewDidLoad
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;

    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.allowsSelection = NO;    
    
    // Workaround for edge conditions. Hat tip Nicolas Goles
    self.collectionView.delegate = self;
    desiredPoint = CGRectNull.origin;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"PleaseRecenter" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSValue *value = (NSValue *)note.object;
        desiredPoint = value.CGPointValue;
    }];
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
    
    PunchedLayout *layout = [[PunchedLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 80.0f, 100.0f, 10.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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