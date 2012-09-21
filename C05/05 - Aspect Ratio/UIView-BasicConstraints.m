/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import "UIView-BasicConstraints.h"

@implementation UIView (BasicConstraints)

// For debugging
- (NSString *) nameForLayoutAttribute: (NSLayoutAttribute) anAttribute
{
    switch (anAttribute)
    {
        case NSLayoutAttributeLeft: return @"left";
        case NSLayoutAttributeRight: return @"right";
        case NSLayoutAttributeTop: return @"top";
        case NSLayoutAttributeBottom: return @"bottom";
        case NSLayoutAttributeLeading: return @"leading";
        case NSLayoutAttributeTrailing: return @"trailing";
        case NSLayoutAttributeWidth: return @"width";
        case NSLayoutAttributeHeight: return @"height";
        case NSLayoutAttributeCenterX: return @"centerX";
        case NSLayoutAttributeCenterY: return @"centerY";
        case NSLayoutAttributeBaseline: return @"baseline";
        default: return @"not-an-attribute";
    }
}

- (NSString *) nameForLayoutRelation: (NSLayoutRelation) aRelation
{
    switch (aRelation)
    {
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationEqual: return @"==";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        default: return @"not-a-relation";
    }
}

- (NSString *) nameForItem: (id) anItem
{
    if (!anItem) return @"nil";
    if (anItem == self) return @"[self]";
    if (anItem == self.superview) return @"[superview]";
    return [NSString stringWithFormat:@"[%@:%d]", [anItem class], (int) anItem];
}

- (NSString *) constraintRepresentation: (NSLayoutConstraint *) aConstraint
{
    NSString *item1 = [self nameForItem:aConstraint.firstItem];
    NSString *item2 = [self nameForItem:aConstraint.secondItem];
    NSString *relationship = [self nameForLayoutRelation:aConstraint.relation];
    NSString *attr1 = [self nameForLayoutAttribute:aConstraint.firstAttribute];
    NSString *attr2 = [self nameForLayoutAttribute:aConstraint.secondAttribute];
    
    NSString *result;
    
    if (!aConstraint.secondItem)
    {
        result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %0.3f", aConstraint.priority, item1, attr1, relationship, aConstraint.constant];
    }
    else if (aConstraint.multiplier == 1.0f)
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %@.%@", aConstraint.priority, item1, attr1, relationship, item2, attr2];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.constant];
    }
    else
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ * %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ ((%@.%@ * %0.3f) + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier, aConstraint.constant];
    }
    
    return result;
}

- (void) showConstraints
{
    NSString *viewName = [NSString stringWithFormat:@"[%@:%d]", [self class], (int) self];
    NSLog(@"View %@ has %d constraints", viewName, self.constraints.count);
    for (NSLayoutConstraint *constraint in self.constraints)
        NSLog(@"%@", [self constraintRepresentation:constraint]);
    printf("\n");
}

// Centering
- (void) centerHorizontallyInSuperview
{
    if (!self.superview) return;
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

- (void) centerVerticallyInSuperview
{
    if (!self.superview) return;
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}


// Forcing into the superview bounds
- (void) constrainWithinSuperviewBounds
{
    if (!self.superview) return;
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
}

- (void) constrainSelfToSize:(CGSize)aSize
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(theWidth)]" options:0 metrics:@{@"theWidth":@(aSize.width)} views:NSDictionaryOfVariableBindings(self)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(theHeight)]" options:0 metrics:@{@"theHeight":@(aSize.height)} views:NSDictionaryOfVariableBindings(self)]];
}
@end

