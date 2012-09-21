/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#pragma mark - Cookbook
#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]

#pragma mark - Bar Buttons
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define IMGBARBUTTON(IMAGE, SELECTOR) [[UIBarButtonItem alloc] initWithImage:IMAGE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define CUSTOMBARBUTTON(VIEW) [[UIBarButtonItem alloc] initWithCustomView:VIEW]

#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]
#define BARBUTTON_TARGET(TITLE, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]

#pragma mark - Platform
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#pragma mark - Orientation
#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)
#define IS_PORTRAIT_2 UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)

#pragma mark - Debug
#define BOOL_CHECK(TITLE, CHECK_ITEM) printf("%s: %s\n", TITLE, (CHECK_ITEM) ? "Yes" : "No")

#pragma mark - Geometry
#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
#define RESIZABLE(_VIEW_) [_VIEW_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth]

#pragma mark - Strings
#define STREQ(STRING1, STRING2) ([STRING1 caseInsensitiveCompare:STRING2] == NSOrderedSame)
#define PREFIXED(STRING1, STRING2) ([[STRING1 uppercaseString] hasPrefix:[STRING2 uppercaseString]])

#pragma mark - Constraints

// Prepare Constraint Compliance
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

// Add a  visual format constraint
#define CONSTRAIN(PARENT, VIEW, FORMAT) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define CONSTRAIN_VIEWS(PARENT, FORMAT, BINDINGS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:BINDINGS]]

// Stretch across axis
#define STRETCH_VIEW_H(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"H:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW_V(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"V:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW(PARENT, VIEW) {STRETCH_VIEW_H(PARENT, VIEW); STRETCH_VIEW_V(PARENT, VIEW);}

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}

// Align to parent
#define ALIGN_VIEW_LEFT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_RIGHT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_TOP(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_BOTTOM(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]]

// Set Size
#define CONSTRAIN_WIDTH(VIEW, WIDTH) CONSTRAIN(VIEW, VIEW, @"H:["#VIEW"(=="#WIDTH")]")
#define CONSTRAIN_HEIGHT(VIEW, HEIGHT) CONSTRAIN(VIEW, VIEW, @"V:["#VIEW"(=="#HEIGHT")]")
#define CONSTRAIN_SIZE(VIEW, HEIGHT, WIDTH) {CONSTRAIN_WIDTH(VIEW, WIDTH); CONSTRAIN_HEIGHT(VIEW, HEIGHT);}

// Set Aspect
#define CONSTRAIN_ASPECT(VIEW, ASPECT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeHeight multiplier:(ASPECT) constant:0.0f]]

// Order items
#define CONSTRAIN_ORDER_H(PARENT, VIEW1, VIEW2) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(@"H:["#VIEW1"]->=0-["#VIEW2"]") options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW1, VIEW2)]]
#define CONSTRAIN_ORDER_V(PARENT, VIEW1, VIEW2) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(@"V:["#VIEW1"]->=0-["#VIEW2"]") options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW1, VIEW2)]]
