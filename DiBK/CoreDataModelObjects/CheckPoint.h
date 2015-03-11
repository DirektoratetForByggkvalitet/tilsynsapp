//
//  CheckPoint.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AuditType;

@interface CheckPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * checkPointId;
@property (nonatomic, retain) NSString * checkPointName;
@property (nonatomic, retain) NSSet *auditType;
@end

@interface CheckPoint (CoreDataGeneratedAccessors)

- (void)addAuditTypeObject:(AuditType *)value;
- (void)removeAuditTypeObject:(AuditType *)value;
- (void)addAuditType:(NSSet *)values;
- (void)removeAuditType:(NSSet *)values;

@end
