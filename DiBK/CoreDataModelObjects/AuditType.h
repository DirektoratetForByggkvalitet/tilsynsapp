//
//  AuditType.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checklist, Pursuant, ThemeReference;

@interface AuditType : NSManagedObject

@property (nonatomic, retain) NSNumber * auditTypeId;
@property (nonatomic, retain) NSString * auditTypeName;
@property (nonatomic, retain) NSSet *checklist;
@property (nonatomic, retain) NSSet *pursuants;
@property (nonatomic, retain) NSSet *checkpoints;
@property (nonatomic, retain) NSSet *themeRefs;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic) BOOL isChecked;
@end

@interface AuditType (CoreDataGeneratedAccessors)

- (void)addChecklistObject:(Checklist *)value;
- (void)removeChecklistObject:(Checklist *)value;
- (void)addChecklist:(NSSet *)values;
- (void)removeChecklist:(NSSet *)values;

- (void)addPursuantsObject:(Pursuant *)value;
- (void)removePursuantsObject:(Pursuant *)value;
- (void)addPursuants:(NSSet *)values;
- (void)removePursuants:(NSSet *)values;

- (void)addCheckpointsObject:(NSManagedObject *)value;
- (void)removeCheckpointsObject:(NSManagedObject *)value;
- (void)addCheckpoints:(NSSet *)values;
- (void)removeCheckpoints:(NSSet *)values;

- (void)addThemeRefsObject:(ThemeReference *)value;
- (void)removeThemeRefsObject:(ThemeReference *)value;
- (void)addThemeRefs:(NSSet *)values;
- (void)removeThemeRefs:(NSSet *)values;

- (void)addQuestionsObject:(NSManagedObject *)value;
- (void)removeQuestionsObject:(NSManagedObject *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
