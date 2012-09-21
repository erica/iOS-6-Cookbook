/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface TestBedViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *picker;
}
@end

@implementation TestBedViewController

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3; // three columns
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 1000000; // arbitrary and large
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 120.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSArray *names = @[@"club.png", @"diamond.png", @"heart.png", @"spade.png"];
    UIImage *image = [UIImage imageNamed:names[row%4]];

    UIImageView *imageView = (UIImageView *) view;
    imageView.image = image;
    
    if (!imageView)
        imageView = [[UIImageView alloc] initWithImage:image];
    
	return imageView;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSArray *names = @[@"C", @"D", @"H", @"S"];
	self.title = [NSString stringWithFormat:@"%@•%@•%@",
                  names[[pickerView selectedRowInComponent:0] % 4],
                  names[[pickerView selectedRowInComponent:1] % 4],
                  names[[pickerView selectedRowInComponent:2] % 4]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [picker selectRow:50000 + (rand() % 4) inComponent:0 animated:YES];
	[picker selectRow:50000 + (rand() % 4) inComponent:1 animated:YES];
	[picker selectRow:50000 + (rand() % 4) inComponent:2 animated:YES];
}

- (void) loadView
{
    [super loadView];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:picker];
    
    PREPCONSTRAINTS(picker);
    CENTERH(self.view, picker);
    CENTERV(self.view, picker);
    
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
}
@end


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