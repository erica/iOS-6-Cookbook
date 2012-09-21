/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DataManager.h"
#import "DetailViewController.h"

@interface TestBedViewController : UITableViewController
{
    DataManager *manager;
}
@end

@implementation TestBedViewController

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (manager.entries) return manager.entries.count;
    return 0;
}

// On user tap, present detail 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [manager.entries objectAtIndex:indexPath.row];
    if (VALID(dict[@"price"]) && VALID(dict[@"large image"]) && VALID(dict[@"address"]))
    {
        DetailViewController *detail = [[DetailViewController alloc] initWithDictionary:dict];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic" forIndexPath:indexPath];
    cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"generic"];
    
    NSDictionary *dict = [manager.entries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"artist"];
    cell.imageView.image = dict[@"image"];
    
    NSString *address = dict[@"address"];
    if (![address isKindOfClass:[NSNull class]])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
          
	return cell;
}

- (void) dataIsReady: (id) sender
{
    self.title = @"iTunes Top Albums";
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void) loadData
{
    self.title = @"Loading...";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.refreshControl beginRefreshing];
    
    [manager loadData];
}

- (void) loadView
{
    [super loadView];
    self.tableView.rowHeight = 72.0f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"generic"];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Load", @selector(loadData));
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];

    manager = [[DataManager alloc] init];
    manager.delegate = self;
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