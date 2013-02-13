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

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

@interface LimitedTextField : UITextField
@end
@implementation LimitedTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UITextRange *range = self.selectedTextRange;
    BOOL hasText = self.text.length > 0;
    
    if (action == @selector(cut:)) return !range.empty;
    if (action == @selector(copy:)) return !range.empty;
    if (action == @selector(select:)) return hasText;
    if (action == @selector(selectAll:)) return hasText;
    if (action == @selector(paste:)) return NO;
    
    return NO;
}
@end;

@interface TestBedViewController : UIViewController <UITextFieldDelegate>
{
    LimitedTextField *textField;
    UISegmentedControl *segmentedControl;
}
@end

@implementation TestBedViewController

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
	
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0: // Alpha only
            [cs addCharactersInString:ALPHA];
            break;
        case 1: // Integers
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            break;
        case 2: // Decimals
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            if ([aTextField.text rangeOfString:@"."].location == NSNotFound)
				[cs addCharactersInString:@"."];
            break;
        case 3: // Alphanumeric
            [cs addCharactersInString:ALPHA];
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            break;
        default:
            break;
    }
	
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:[cs invertedSet]] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    return basicTest;
}

- (void) segmentChanged: (UISegmentedControl *) seg
{
	textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    
    // Create a text field by hand
	textField = [[LimitedTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 30.0f)];
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
    
    // Add segmented control with entry options
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[@"ABC 123 2.3 A2C" componentsSeparatedByString:@" "]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
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