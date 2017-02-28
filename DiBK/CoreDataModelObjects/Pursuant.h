//
//  Pursuant.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pursuant : NSManagedObject

@property (nonatomic, retain) NSNumber * pursuantId;
@property (nonatomic, retain) NSString * pursuantName;
@property (nonatomic, retain) NSManagedObject *auditType;

@end
