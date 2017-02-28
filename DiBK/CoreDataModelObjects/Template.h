//
//  Template.h
//  DiBK
//
//  Created by david stummer on 23/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checklist, Theme, UserInfo;

@interface Template : NSManagedObject

@property (nonatomic, retain) NSNumber * templateId;
@property (nonatomic, retain) NSString * templateLanguage;
@property (nonatomic, retain) NSString * templateName;
@property (nonatomic, retain) NSSet *checklists;
@property (nonatomic, retain) NSSet *themes;
@property (nonatomic, retain) UserInfo *user;
@end

@interface Template (CoreDataGeneratedAccessors)

- (void)addChecklistsObject:(Checklist *)value;
- (void)removeChecklistsObject:(Checklist *)value;
- (void)addChecklists:(NSSet *)values;
- (void)removeChecklists:(NSSet *)values;

- (void)addThemesObject:(Theme *)value;
- (void)removeThemesObject:(Theme *)value;
- (void)addThemes:(NSSet *)values;
- (void)removeThemes:(NSSet *)values;

@end
