//
//  Checklist.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChecklistSubtitle, Template;

@interface Checklist : NSManagedObject

@property (nonatomic, retain) NSNumber * checklistId;
@property (nonatomic, retain) NSString * checklistName;
@property (nonatomic, retain) NSSet *template;
@property (nonatomic, retain) NSSet *subtitles;
@property (nonatomic, retain) NSSet *audiTypes;
@end

@interface Checklist (CoreDataGeneratedAccessors)

- (void)addTemplateObject:(Template *)value;
- (void)removeTemplateObject:(Template *)value;
- (void)addTemplate:(NSSet *)values;
- (void)removeTemplate:(NSSet *)values;

- (void)addSubtitlesObject:(ChecklistSubtitle *)value;
- (void)removeSubtitlesObject:(ChecklistSubtitle *)value;
- (void)addSubtitles:(NSSet *)values;
- (void)removeSubtitles:(NSSet *)values;

- (void)addAudiTypesObject:(NSManagedObject *)value;
- (void)removeAudiTypesObject:(NSManagedObject *)value;
- (void)addAudiTypes:(NSSet *)values;
- (void)removeAudiTypes:(NSSet *)values;

@end
