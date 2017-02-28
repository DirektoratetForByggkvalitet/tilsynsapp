//
//  Municipality.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Municipality : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * county;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * mNr;
@property (nonatomic, retain) NSString * mWeapon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * zipPlace;
@property (nonatomic, retain) UserInfo *user;

- (NSString*)getIdStr;

@end
