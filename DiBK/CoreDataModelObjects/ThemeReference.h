//
//  ThemeReference.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ThemeReference : NSManagedObject

@property (nonatomic, retain) NSNumber * themeRefId;
@property (nonatomic, retain) NSNumber * themeRefNumber;
@property (nonatomic, retain) NSManagedObject *auditType;

@end
