/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Person.h"
#import "Utility.h"

@interface TestBedViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>
{
    NSArray *lineArray;
    UIFont *defaultFont;
    int index;
}
@property CoreDataHelper *dataHelper;
@end

@implementation TestBedViewController
@synthesize dataHelper;

#pragma mark Data Source
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithData:person.imageData];
    return CGSizeMake(image.size.width, image.size.height + 20.0f);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (dataHelper.numberOfEntities == 0) return 0;
	return dataHelper.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Rows per section
    id <NSFetchedResultsSectionInfo> sectionInfo = dataHelper.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

#define IMAGEVIEWTAG    99

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Person *person = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithData:person.imageData];
    
    cell.backgroundColor = [UIColor clearColor];
    if (![cell.contentView viewWithTag:IMAGEVIEWTAG])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = IMAGEVIEWTAG;
        [cell.contentView addSubview:imageView];
    }

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:IMAGEVIEWTAG];
    imageView.frame = CGRectMake(0.0f, 10.0f, image.size.width, image.size.height);
    imageView.image = image;

    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];

	return cell;
}

#pragma mark -
#pragma mark Delegate methods

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setBarButtonItems];
}

- (void)collectionView:(UICollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark Editing and Undo

- (void) setBarButtonItems
{
    self.navigationItem.rightBarButtonItem.enabled = (self.collectionView.indexPathsForSelectedItems.count != 0);
    
    UIBarButtonItem *undo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, dataHelper.context.undoManager, @selector(undo));
    undo.enabled = dataHelper.context.undoManager.canUndo;
    UIBarButtonItem *redo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, dataHelper.context.undoManager, @selector(redo));
    redo.enabled = dataHelper.context.undoManager.canRedo;
    UIBarButtonItem *add = SYSBARBUTTON(UIBarButtonSystemItemAdd, @selector(addItem));
    
    self.navigationItem.leftBarButtonItems = @[add, undo, redo];
}


- (void) refresh
{
    [dataHelper fetchData];
    dataHelper.fetchedResultsController.delegate = self;
    [self.collectionView reloadData];
    [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Respond to data change from undo controller
    [self refresh];
}

#define GETINDEX(ATTRIBUTE) [attributes indexOfObject:ATTRIBUTE]
- (void) setupNewPerson: (Person *) person
{
    // Add a new item to the database
    NSArray *attributes = @[@"number", @"gender", @"givenname", @"middleinitial", @"surname", @"streetaddress", @"city", @"state", @"zipcode", @"country", @"emailaddress", @"password", @"telephonenumber", @"mothersmaiden", @"birthday", @"cctype", @"ccnumber", @"cvv2", @"ccexpires", @"nationalid", @"ups", @"occupation", @"domain", @"bloodtype", @"pounds", @"kilograms", @"feetinches", @"centimeters"];

    if (!lineArray)
    {
        NSString *dataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakePersons" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
        lineArray = [dataString componentsSeparatedByString:@"\n"];
    }
    NSString *line = lineArray[index++];
    NSArray *items = [line componentsSeparatedByString:@","];

    NSString *fullName = [NSString stringWithFormat:@"%@ %@", items[GETINDEX(@"givenname")], items[GETINDEX(@"surname")]];
    person.imageData = UIImagePNGRepresentation(stringImage(fullName, defaultFont, 10.0f));
    person.surname = items[GETINDEX(@"surname")];
    person.section = [[person.surname substringFromIndex:0] substringToIndex:1];
    person.emailaddress = items[GETINDEX(@"emailaddress")];
    person.gender = items[GETINDEX(@"gender")];
    person.middleinitial = items[GETINDEX(@"middleinitial")];
    person.occupation = items[GETINDEX(@"occupation")];
    person.givenname = items[GETINDEX(@"givenname")];
}

- (void) addItem
{
    // Surround the "add" functionality with undo grouping
    NSUndoManager *manager = dataHelper.context.undoManager;
    [manager beginUndoGrouping];
    {
        Person *person = (Person *)[dataHelper newObject];
        [self setupNewPerson:person];
    }
    [manager endUndoGrouping];
    [manager setActionName:@"Add"];
    [dataHelper save];
    [self refresh];
}

- (void) deleteItem
{
    if (!self.collectionView.indexPathsForSelectedItems.count) return;
    
    NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems[0];
    NSManagedObject *object = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    NSUndoManager *manager = dataHelper.context.undoManager;
    [manager beginUndoGrouping];
    {
        [dataHelper.context deleteObject:object];
    }
    [manager endUndoGrouping];
    [manager setActionName:@"Delete"];
    [dataHelper save];
    [self refresh];
}

#pragma mark Setup
- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout
{
    if (!(self = [super initWithCollectionViewLayout:layout])) return nil;
    index = rand() % 1000;
    defaultFont = [UIFont fontWithName:@"Futura" size:24.0f];
    return self;
}

- (void) viewDidLoad
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.allowsSelection = YES;
    
    self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemAdd, @selector(addItem));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Delete", @selector(deleteItem));
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark First Responder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
    [self setBarButtonItems];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic) UIWindow *window;
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    srand(time(0));

    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    [[UIToolbar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 60.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	TestBedViewController *tbvc = [[TestBedViewController alloc] initWithCollectionViewLayout:layout];
    
    // Setup Core Data *before* presenting collection view
    tbvc.dataHelper = [[CoreDataHelper alloc] init];
    tbvc.dataHelper.entityName = @"Person";
    tbvc.dataHelper.defaultSortAttribute = @"section";
    [tbvc.dataHelper setupCoreData];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
	[_window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}