/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DownloadHelper.h"

#define TWITTERSEARCH @"http://search.twitter.com/search.json?q=ericasadun%20OR%20sadun&rpp=25&include_entities=true&result_type=mixed"
#define DEST_PATH	[NSHomeDirectory() stringByAppendingString:@"/Documents/output.json"]

@interface TestBedViewController : UITableViewController <DownloadHelperDelegate>
@end

@implementation TestBedViewController
{
    DownloadHelper *helper;
    NSArray *items;
}

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = [items objectAtIndex:indexPath.row][@"text"];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.text = [items objectAtIndex:indexPath.row][@"from_user_name"];
    
    return cell;
}

- (void) downloadFinished
{
    [self.refreshControl endRefreshing];
    NSData *jsonData = [NSData dataWithContentsOfFile:DEST_PATH];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    items = json[@"results"];
    [self.tableView reloadData];
}

- (void) dataDownloadFailed: (NSString *) reason
{
    self.title = reason;
    [self.refreshControl endRefreshing];
}

- (void) reloadData
{
    self.title = nil;
    [self.refreshControl beginRefreshing];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DEST_PATH])
        [[NSFileManager defaultManager] removeItemAtPath:DEST_PATH error:nil];
    
    helper = [DownloadHelper download:TWITTERSEARCH withTargetPath:DEST_PATH withDelegate:self];
}

// Set up table
- (void) loadView
{
    [super loadView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 120;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:2.0f];
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