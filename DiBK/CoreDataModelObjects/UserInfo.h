//
//  UserInfo.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Municipality, Rapport, Template;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * isBokmal;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * loginKey;
@property (nonatomic, retain) NSString * municipality;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *municipalities;
@property (nonatomic, retain) NSSet *rapports;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) NSString *kommuneID;
@end

@interface UserInfo (CoreDataGeneratedAccessors)

- (void)addMunicipalitiesObject:(Municipality *)value;
- (void)removeMunicipalitiesObject:(Municipality *)value;
- (void)addMunicipalities:(NSSet *)values;
- (void)removeMunicipalities:(NSSet *)values;

- (void)addRapportsObject:(Rapport *)value;
- (void)removeRapportsObject:(Rapport *)value;
- (void)addRapports:(NSSet *)values;
- (void)removeRapports:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

@end
