//
//  Chapter1Info.h
//  DiBK
//
//  Created by david stummer on 11/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manager;

@interface Chapter1Info : NSManagedObject

@property (nonatomic, retain) NSString * infoName;
@property (nonatomic, retain) NSString * kommune_sakanr;
@property (nonatomic, retain) NSString * kommune;
@property (nonatomic, retain) NSString * rapporten_gjelder;
@property (nonatomic, retain) NSString * stedig_tilsyn_varslet;
@property (nonatomic, retain) NSString * gnr;
@property (nonatomic, retain) NSString * bnr;
@property (nonatomic, retain) NSString * fnr;
@property (nonatomic, retain) NSString * snr;
@property (nonatomic, retain) NSString * kommentar;
@property (nonatomic, retain) NSString * annet;
@property (nonatomic, retain) NSNumber * p1cb1;
@property (nonatomic, retain) NSNumber * p1cb2;
@property (nonatomic, retain) NSNumber * p1cb3;
@property (nonatomic, retain) NSNumber * p1cb4;
@property (nonatomic, retain) NSNumber * p1cb5;
@property (nonatomic, retain) NSNumber * p1cb6;
@property (nonatomic, retain) NSNumber * p1cb7;
@property (nonatomic, retain) NSNumber * p2cb1;
@property (nonatomic, retain) NSNumber * p2cb2;
@property (nonatomic, retain) NSNumber * p2cb3;
@property (nonatomic, retain) NSNumber * p2cb4;
@property (nonatomic, retain) NSNumber * p2cb5;
@property (nonatomic, retain) NSNumber * p2cb6;
@property (nonatomic, retain) NSNumber * p2cb7;
@property (nonatomic, retain) NSNumber * p2cb8;
@property (nonatomic, retain) NSNumber * p2cb9;
@property (nonatomic, retain) NSNumber * p2cb10;
@property (nonatomic, retain) NSNumber * p2cb11;
@property (nonatomic, retain) NSNumber * p2cb12;
@property (nonatomic) NSTimeInterval dato_fortatt;
@property (nonatomic, retain) NSString* datoFortatt;
@property (nonatomic, retain) NSString* andreKommentarer;
@property (nonatomic, retain) NSString* titakenEr;
@property (nonatomic, retain) NSString* kommuneID;
@property (nonatomic, retain) NSSet* managers;
    
@end

@interface Chapter1Info (CoreDataGeneratedAccessors)
- (void)addManagerObject:(Manager *)object;
- (void)removeManagerObject:(Manager *)object;
- (void)addManagers:(NSSet *)somethings;
- (void)removeManagers:(NSSet *)somethings;
@end
