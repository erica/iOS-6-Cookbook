/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "CrayonHandler.h"

#define ALPHA    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface TestBedViewController : UITableViewController <UISearchBarDelegate>
{
    CrayonHandler *crayons;
    UISearchBar *searchBar;
    UISearchDisplayController *searchController;
}
@end

@implementation TestBedViewController

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (aTableView == searchController.searchResultsTableView) return 1;
    return crayons.numberOfSections;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (aTableView == searchController.searchResultsTableView)
        return [crayons filterWithString:searchBar.text];
    return [crayons countInSection:section];
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *crayonName;
    
    if (aTableView == self.tableView)
    {
        crayonName = [crayons colorNameAtIndexPath:indexPath];
    }
    else
    {
        if (indexPath.row < crayons.filteredArray.count)
            crayonName  = crayons.filteredArray[indexPath.row];
    }
    
    if (!crayonName)
    {
        NSLog(@"Unexpected error retrieving cell: [%d, %d] table: %@", indexPath.section, indexPath.row, aTableView);
        return nil;
    }

    cell.textLabel.text = crayonName ;
    cell.textLabel.textColor = [crayons colorNamed:crayonName];
    if ([crayonName hasPrefix:@"White"])
        cell.textLabel.textColor = [UIColor blackColor];

    return cell;
}

// Find the section that corresponds to a given title
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        [self.tableView scrollRectToVisible:searchBar.frame animated:NO];
        return -1;
    }
    return [ALPHA rangeOfString:title].location;
}

// Titles for the section index presentation
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if (aTableView == searchController.searchResultsTableView) return nil;
    
    NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 0; i < crayons.numberOfSections; i++)
    {
        NSString *name = [crayons nameForSection:i];
        if (name) [indices addObject:name];
    }
    return indices;
}

// Return the header title for a section
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if (aTableView == searchController.searchResultsTableView) return nil;
    return [crayons nameForSection:section];
}


// On selecting a row, update the navigation bar tint
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = nil;
    if (aTableView == self.tableView)
        color = [crayons colorAtIndexPath:indexPath];
    else
    {
        if (indexPath.row < crayons.filteredArray.count)
        {
            NSString *colorName = crayons.filteredArray[indexPath.row];
            if (colorName)
                color = [crayons colorNamed:colorName];
        }
    }
    
    if (color)
    {
        self.navigationController.navigationBar.tintColor = color;
        searchBar.tintColor = color;
    }

}

// Via Jack Lucky. Handle the cancel button by resetting the search text
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [searchBar setText:@""];
}

// Upon appearing, scroll away the search bar
- (void) viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


// Set up table
- (void) loadView
{
    [super loadView];
    crayons = [[CrayonHandler alloc] init];
    

    // Create a search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.tableView.tableHeaderView = searchBar;
    
    // Create the search display controller
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
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