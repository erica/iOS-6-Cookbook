/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Person.h"
#import "Utility.h"

@interface TestBedViewController : UIViewController <UITextFieldDelegate>
{
    CoreDataHelper *dataHelper;
    UITextField *textField;
    UITextView *textView;
}
@end

@implementation TestBedViewController

#define GETINDEX(ATTRIBUTE) [attributes indexOfObject:ATTRIBUTE]
- (void) initializeData
{
    NSArray *attributes = @[@"number", @"gender", @"givenname", @"middleinitial", @"surname", @"streetaddress", @"city", @"state", @"zipcode", @"country", @"emailaddress", @"password", @"telephonenumber", @"mothersmaiden", @"birthday", @"cctype", @"ccnumber", @"cvv2", @"ccexpires", @"nationalid", @"ups", @"occupation", @"domain", @"bloodtype", @"pounds", @"kilograms", @"feetinches", @"centimeters"];
    NSString *dataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakePersons" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];

    NSArray *lineArray = [dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in lineArray)
    {
        NSArray *items = [line componentsSeparatedByString:@","];
        if (items.count != attributes.count) continue;
        
        Person *person = (Person *)[dataHelper newObject];
        
        person.surname = items[GETINDEX(@"surname")];
        person.section = [[person.surname substringFromIndex:0] substringToIndex:1];
        person.emailaddress = items[GETINDEX(@"emailaddress")];
        person.gender = items[GETINDEX(@"gender")];
        person.middleinitial = items[GETINDEX(@"middleinitial")];
        person.occupation = items[GETINDEX(@"occupation")];
        person.givenname = items[GETINDEX(@"givenname")];
    }
    
    if ([dataHelper save])
        NSLog(@"Database created");
}

- (void) list
{
    if (!textField.text.length) return;
    
    [dataHelper fetchItemsMatching:textField.text forAttribute:@"surname" sortingBy:@"surname"];
    NSMutableString *string = [NSMutableString string];
    for (Person *person in dataHelper.fetchedResultsController.fetchedObjects)
    {
        NSString *entry = [NSString stringWithFormat:@"%@, %@ %@: %@\n", person.surname, person.givenname, person.middleinitial, person.occupation];
        [string appendString:entry];
    }
    
    textView.text = string;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [textField resignFirstResponder];
    [self list];
    return YES;
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 28.0f)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleBezel;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"Search";
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearsOnBeginEditing = YES;
    self.navigationItem.titleView = textField;

    
    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.editable = NO;
    [self.view addSubview:textView];
    PREPCONSTRAINTS(textView);
    CONSTRAIN(self.view, textView, @"H:|[textView(>=0)]|");
    CONSTRAIN(self.view, textView, @"V:|[textView(>=0)]|");
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"Person";
    dataHelper.defaultSortAttribute = @"surname";
    
    // Check for existing data
    BOOL firstRun = !dataHelper.hasStore;
    
    // Setup core data
    [dataHelper setupCoreData];
    if (firstRun)
        [self initializeData];
    [self list];
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
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
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