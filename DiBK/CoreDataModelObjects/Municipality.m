//
//  Municipality.m
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Municipality.h"
#import "UserInfo.h"


@implementation Municipality

@dynamic address;
@dynamic county;
@dynamic email;
@dynamic language;
@dynamic mNr;
@dynamic mWeapon;
@dynamic name;
@dynamic phone;
@dynamic zipCode;
@dynamic zipPlace;
@dynamic user;

- (NSString*)getIdStr
{
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.mNr];
}

@end
