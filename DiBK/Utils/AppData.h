//
//  AppData.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rapport, UserInfo, ReportHomeViewController, Photo, Manager;

@protocol ReportGeneratedProtocol <NSObject>

- (void)reportGenerated;
- (void)reportNotGenerated;

@end

@interface AppData : NSObject
{
    Rapport* _currentReport;
    NSManagedObjectContext* _managedObjectContext;
    UserInfo* _userInfo;
    ReportHomeViewController* _reportHomeViewController;
}

@property(strong, nonatomic)Rapport* currentReport;
@property(strong, nonatomic)NSManagedObjectContext* managedObjectContext;
@property(strong, nonatomic)UserInfo* userInfo;
@property(strong, nonatomic)ReportHomeViewController* reportHomeViewController;

+(AppData*)getInstance;
-(void)genReportWithDelegate:(id<ReportGeneratedProtocol>)callback;
-(void)save;
- (NSArray*)fetchTemplates;
-(Photo*)newPhoto;
-(Manager*)newManager;
-(NSString*)getTitle;
-(NSString*)getTitleForReport:(Rapport*)report;
-(int)getNumberReportPages;
-(NSArray*)getAllPhotosForReport:(Rapport*)report;
+ (NSString *)uuidString;
+ (NSString*)filePathForKey:(NSString *)key;
-(void)deleteCurrentReport;
-(NSString*)getUniquePDFFileNameForCurrentReport;
-(UserInfo*)fetchUserInfo;

@end
