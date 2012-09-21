/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define CONSTRAIN(VIEW, FORMAT)     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

@interface TestBedViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *textField;
    UISegmentedControl *segmentedControl;
}
@end

@implementation TestBedViewController
- (void) updateStatus: (NSString *) string
{
	NSPredicate *telePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[\\(]?([2-9][0-9]{2})[\\)]?[-.\\. ]?([2-9][0-9]{2})[-.\\. ]?([0-9]{4})$'"];
	BOOL match = [telePredicate evaluateWithObject:string];
	self.title = match ? @"Phone Number" : nil;	
}

- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
	if (!string.length) 
	{
		[self updateStatus:newString];
		return YES;
	}
    
    NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
	[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
	[cs addCharactersInString:@"()-. "];
	
	// legal characters check
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:[cs invertedSet]] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
	[self updateStatus:basicTest ? newString : textField.text];
    
	return basicTest;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
    [textField resignFirstResponder];
    return YES;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    
    // Create a text field by hand
	textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 30.0f)];
	textField.placeholder = @"Enter Text";
    [self.view addSubview:textField];
    
    PREPCONSTRAINTS(textField);
    CONSTRAIN(textField, @"V:|-30-[textField]");
    CONSTRAIN(textField, @"H:|-[textField(>=0)]-|");
	
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
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