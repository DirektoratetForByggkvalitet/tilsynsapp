//
//  AppData.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "AppData.h"
#import "Rapport.h"
#import "Chapter1Info.h"
#import "UserInfo.h"
#import "Template.h"
#import "Photo.h"
#import "Conclusion.h"
#import "Manager.h"
#import "Checklist.h"
#import "AuditType.h"
#import "Question.h"
#import "ArchiveListRetriever.h"
#import "WebServiceManager.h"

@implementation AppData
@synthesize currentReport = _currentReport;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize userInfo = _userInfo;
@synthesize reportHomeViewController = _reportHomeViewController;

+(AppData*)getInstance
{
    static AppData* sp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sp = [AppData new];
    });
    return sp;
}

- (void)deleteCurrentReport
{
    if (!_currentReport) {
        return;
    }
    [_managedObjectContext deleteObject:_currentReport];
    _currentReport = nil;
}

- (NSArray*)fetchTemplates
{
    NSSet *templateSet = _currentReport.templates;
    NSArray *a = [templateSet allObjects];
    
    // sort Templates
    a = [a sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Template *first = (Template*)a;
        Template *second = (Template*)b;
        return [first.templateId compare:second.templateId];
    }];
    
    return a;
}

-(UserInfo*)fetchUserInfo
{
    if (_userInfo != nil) {
        return _userInfo;
    }
    
    assert(_managedObjectContext != nil);
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserInfo"];
    
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    assert([users count] == 1);
    
    _userInfo = (UserInfo *)[users objectAtIndex:0];
    return _userInfo;
}

-(Photo*)newPhoto
{
    assert(_managedObjectContext != nil);
    
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:_managedObjectContext];
    return photo;
}

-(Manager*)newManager
{
    assert(_managedObjectContext != nil);
    
    Manager *man = (Manager*)[NSEntityDescription insertNewObjectForEntityForName:@"Manager" inManagedObjectContext:_managedObjectContext];
    return man;
}

-(void)setCurrentReport:(Rapport *)currentReport
{
    _currentReport = currentReport;
}

-(NSString*)getTitleForReport:(Rapport *)report
{
    NSString *title = @"";
    if (report) {
        NSString *a = report.chapter1Info.kommune_sakanr;
        NSString *b = report.chapter1Info.stedig_tilsyn_varslet;
        if (a == nil) {
            a = @"";
        }
        if (b == nil) {
            b = @"";
        }
        title = [NSString stringWithFormat:@"%@ %@", a, b];
    }
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSString*)getTitle
{
    return [self getTitleForReport:_currentReport];
}

// this is needed because for example the character '/' in the filename
// will play havoc when trying to save it
- (NSString *)sanitizeFileNameString:(NSString *)fileName
{
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
    return [[fileName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

-(NSString*)getUniquePDFFileNameForCurrentReport
{
    NSArray *filesInDefaultFolder = [ArchiveListRetriever getDefaultFolder].files;
    NSString *reportTitle = [self getTitle];
    reportTitle = [self sanitizeFileNameString:reportTitle];
    if ([reportTitle isEqualToString:@""]) {
        // somehow our report title is empty? We enforce the creation of a report
        // title in chapter 5, so this should never happen
        NSLog(@"AppData::getUniquePDFFileNameForCurrentReport: report title is empty!");
        assert(0);
        return nil;
    }
    
    NSString *tmpReportTitle = [self getTitle];
    BOOL taken = YES;
    int i = 0;
    while (taken) {
        taken = NO;
        for (ArchiveFileInfo *fileInfo in filesInDefaultFolder) {
            NSString *fn = fileInfo.name;
            fn = [fn stringByDeletingPathExtension];
            if ([fn isEqualToString:reportTitle]) {
                taken = YES;
                break;
            }
        }
        if (taken) {
            reportTitle = [tmpReportTitle stringByAppendingFormat:@"(%d)", ++i];
        }
    }
    return reportTitle;
}

+ (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}

// sets up a new report instance, and all of it's relationships
-(void)genReportWithDelegate:(id<ReportGeneratedProtocol>)callback
{
    [self fetchUserInfo];
    
    _currentReport = [NSEntityDescription insertNewObjectForEntityForName:@"Rapport" inManagedObjectContext:_managedObjectContext];
    _currentReport.rapportNumber = [AppData uuidString];
    
    Conclusion *conclusion = [NSEntityDescription insertNewObjectForEntityForName:@"Conclusion" inManagedObjectContext:_managedObjectContext];
    [_currentReport setConclusion:conclusion];
    
    NSError *error;
    
    Chapter1Info* info = (Chapter1Info*)[NSEntityDescription insertNewObjectForEntityForName:@"Chapter1Info" inManagedObjectContext:_managedObjectContext];
    
    // add a default manager
    Manager *m = [self newManager];
    NSMutableSet* tempSet = [NSMutableSet setWithSet:info.managers];
    [tempSet addObject:m];
    info.managers = tempSet;
    
    [_currentReport setChapter1Info:info];
    [_userInfo addRapportsObject:_currentReport];
    [_managedObjectContext save:&error];
    
    WebServiceManager *webServiceManager = [WebServiceManager getInstance];
    [webServiceManager updateWithCallback:^(BOOL success){
        NSMutableSet *templates = [webServiceManager getCopyOfAllTemplates];
        if (!templates) {
            [callback reportNotGenerated];
            return;
        }
        [_currentReport addTemplates:templates];
        NSError *error2;
        [_managedObjectContext save:&error2];
        NSLog(@"error: %@ %@" , error2.description, error2.localizedDescription);
        [callback reportGenerated];
    }];
}

- (void)save
{
    [_managedObjectContext save:nil];
}

+ (NSString*)filePathForKey:(NSString *)key
{
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [dirs objectAtIndex:0];
    return [dir stringByAppendingPathComponent:key];
}

-(NSArray*)getAllPhotosForReport:(Rapport*)report
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (Template *template in report.templates) {
        for (Checklist *checklist in template.checklists) {
            for (AuditType *auditType in checklist.audiTypes) {
                for (Question *question in auditType.questions) {
                    for (Photo *photo in question.photos) {
                        if (photo.id != nil) {
                            [photos addObject:photo];
                        }
                    }
                }
            }
        }
    }
    return photos;
}

-(int)getNumberReportPages
{
    NSArray *templates = [_currentReport.templates allObjects];
    int count = 0;
    for (int i = 0; i < [templates count]; i++) {
        Template *template = [templates objectAtIndex:i];
        NSArray *checklists = [template.checklists allObjects];
        for (int j = 0; j < [checklists count]; j++) {
            Checklist *checklist = [checklists objectAtIndex:j];
            NSArray *auditTypes = [checklist.audiTypes allObjects];
            for (int k = 0; k < [auditTypes count]; k++) {
                AuditType *auditType = [auditTypes objectAtIndex:k];
                if (auditType.isChecked) {
                    count++;
                }
            }
        }
    }
    return count;
}

@end
