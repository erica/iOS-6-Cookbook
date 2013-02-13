//
//  Person.h
//  HelloWorld
//
//  Created by Erica Sadun on 7/17/12.
//  Copyright (c) 2012 Erica Sadun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * emailaddress;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * givenname;
@property (nonatomic, retain) NSString * middleinitial;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * surname;

@end
