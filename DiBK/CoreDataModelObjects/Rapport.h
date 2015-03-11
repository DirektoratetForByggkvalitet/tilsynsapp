//
//  Rapport.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;
@class Chapter1Info;
@class Template, Conclusion;

@interface Rapport : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * dateLastEdited;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * rapportName;
@property (nonatomic, retain) NSString * rapportNumber;
@property (nonatomic, retain) UserInfo *user;
@property (nonatomic, retain) Chapter1Info *chapter1Info;
@property (nonatomic, retain) NSSet *rapports;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) Conclusion *conclusion;
@property (nonatomic, retain) NSString *pdfFilePath;
@property (nonatomic, retain) NSString *dateCompletedStr;
@end

@interface Rapport (CoreDataGeneratedAccessors)

- (void)addChapter1InfoObject:(Chapter1Info*)value;
- (void)removeChapter1InfoObject:(Chapter1Info *)value;
- (void)addChapter1Infos:(NSSet *)values;
- (void)removeChapter1Infos:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

@end