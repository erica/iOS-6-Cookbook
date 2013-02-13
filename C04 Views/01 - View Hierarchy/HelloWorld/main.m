/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

@interface TestBedViewController : UITableViewController
{
    NSArray *items;
}
@end

@implementation TestBedViewController

// Recursively travel down the view tree, increasing the
// indentation level for children
- (void) dumpView: (UIView *) aView atIndent: (int) indent into: (NSMutableString *) outstring
{
    // Add the indentation
    for (int i = 0; i < indent; i++)
        [outstring appendString:@"--"];
    
    // Add the class description
    [outstring appendFormat:@"[%2d] %@\n", indent,
     [[aView class] description]];
    
    // Recurse on subviews
    for (UIView *view in aView.subviews)
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

// Start the tree recursion at level 0 with the root view
- (void) dumpTree: (id) sender
{
    NSMutableString *outstring = [NSMutableString string];
    [self dumpView:self.view atIndent:0 into:outstring];
    NSLog(@"%@", outstring);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	// This simple table has only one section
	return 1; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	// Return the number of items
	return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Respond to user interaction
    self.title = [items objectAtIndex:indexPath.row];
}

- (void) loadView
{
    [super loadView];
    items = [@"A*B*C*D*E*F*G*H*I*J*K*L" componentsSeparatedByString:@"*"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Dump", @selector(dumpTree:));
    
    // Feel free to edit the Sample xib and storyboard files to get a sense of how they work
    UIView *sampleView = [[[NSBundle mainBundle] loadNibNamed:@"Sample" owner:self options:NULL] objectAtIndex:0];
    if (sampleView)
    {
        NSMutableString *outstring = [NSMutableString string];
        [self dumpView:sampleView atIndent:0 into:outstring];
        NSLog(@"Dumping sample view: %@", outstring);
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sample" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    if (vc.view)
    {
        NSMutableString *outstring = [NSMutableString string];
        [self dumpView:vc.view atIndent:0 into:outstring];
        NSLog(@"Dumping sample storyboard: %@", outstring);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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