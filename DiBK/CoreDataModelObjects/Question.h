//
//  Question.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AuditType, Photo, CheckPoint, Pursuant;

@interface Question : NSManagedObject
@property (nonatomic, retain) NSNumber * questionId;
@property (nonatomic, retain) NSNumber * questionIndex;
@property (nonatomic, retain) NSString * questionName;
@property (nonatomic, retain) AuditType *auditType;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *checkpoints;
@property (nonatomic, retain) NSSet *pursuants;
@property (nonatomic, retain) NSString *answer;
@property(nonatomic,retain)NSString* questionComment;
- (BOOL)hasAtLeastOnePhoto;
@end

@interface Question (CoreDataGeneratedAccessors)
- (void)addPhotoObject:(Photo *)value;
- (void)removePhotoObject:(Photo *)value;
- (void)addPhoto:(NSSet *)value;
- (void)removePhoto:(NSSet *)value;

- (void)addCheckpoints:(NSSet*)somethings;
- (void)removeCheckpoints:(NSSet*)somethings;
- (void)addCheckpointObject:(CheckPoint*)object;
- (void)removeCheckpointObject:(CheckPoint*)object;

- (void)addPursuants:(NSSet*)somethings;
- (void)removePursuants:(NSSet*)somethings;
- (void)addPursuantObject:(Pursuant*)object;
- (void)removePursuantObject:(Pursuant*)object;
@end