//
//  WebServiceUtils.m
//  DiBK
//
//  Created by david stummer on 08/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "WebServiceUtilsPrivate.h"
#import "FileSystemUtils.h"
#import "AppData.h"
#import "Municipality.h"
#import "LabelManager.h"
#import "Template.h"
#import "Theme.h"
#import "Checklist.h"
#import "AuditType.h"
#import "Pursuant.h"
#import "Question.h"
#import "CheckPoint.h"
#import "ThemeReference.h"
#import "ChecklistSubtitle.h"

@implementation WebServiceUtilsPrivate

+ (BOOL)cachedFilesExist
{
    BOOL f1Exists = [[NSFileManager defaultManager] fileExistsAtPath:[self getKommuneJsonFilePath]];
    BOOL f2Exists = [[NSFileManager defaultManager] fileExistsAtPath:[self getLanguageBokmalJsonFilePath]];
    BOOL f3Exists = [[NSFileManager defaultManager] fileExistsAtPath:[self getLanguageNynorskJsonFilePath]];
    return f1Exists && f2Exists && f3Exists;
}

+(NSString*)getCachesFolder
{
    NSString *f = [FileSystemUtils downloadCacheDir];
    [FileSystemUtils createPath:f];
    return f;
}

+(NSString*)getKommuneJsonFilePath
{
    return [[self getCachesFolder] stringByAppendingPathComponent:@"kommunes.json"];
}

+(NSString*)getLanguageBokmalJsonFilePath
{
    return [[self getCachesFolder] stringByAppendingPathComponent:@"general_lang1.json"];
}

+(NSString*)getLanguageNynorskJsonFilePath
{
    return [[self getCachesFolder] stringByAppendingPathComponent:@"general_lang2.json"];
}

+ (NSDictionary*)loadKommuneJsonFromFile
{
    NSString *path = [self getKommuneJsonFilePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

+ (NSDictionary*)loadLanguageBokmalJsonFromFile
{
    NSString *path = [self getLanguageBokmalJsonFilePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self scanForErrors:dict];
    return dict;
}

+ (void)scanForErrors:(NSDictionary*)dict
{
    if ([dict valueForKey:@"errors"]) {
        NSLog(@"Errors in json:\n%@", dict);
    }
}

+ (NSDictionary*)loadLanguageNynorskJsonFromFile
{
    NSString *path = [self getLanguageNynorskJsonFilePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self scanForErrors:dict];
    return dict;
}

+ (NSDictionary*)extractLabelsArrForLangBokmal
{
    NSDictionary *dict = [self loadLanguageBokmalJsonFromFile];
    NSDictionary *ret = [self extractLabels:dict];
    return ret;
}

+ (NSDictionary*)extractLabelsArrForLangNynorsk
{
    NSDictionary *dict = [self loadLanguageNynorskJsonFromFile];
    NSDictionary *ret = [self extractLabels:dict];
    return ret;
}

+ (NSDictionary*)extractLabels:(NSDictionary*)dict
{
    NSArray *labels = [dict valueForKey:@"labels"];
    //NSLog(@"LABELS: %@", labels);
    NSMutableDictionary *ret = [NSMutableDictionary new];
    for (NSDictionary *d in labels) {
        NSString *parentKey = d[@"parentkey"];
        if (!ret[parentKey]) {
            ret[parentKey] = [NSMutableDictionary new];
        }
        NSString *key = d[@"oldkey"];
        if ([key isKindOfClass:[NSNull class]] || key.length <= 0) {
            key = d[@"key"]; // fallback, useful because sometimes oldkey is null
        }
        ret[parentKey][key] = d;
    }
    return ret;
}

+(NSDictionary*)extractListsArrForLangBokmal
{
    NSDictionary *dict = [self loadLanguageBokmalJsonFromFile];
    NSDictionary *ret = [self extractLists:dict];
    return ret;
}

+(NSDictionary*)extractListsArrForLangNynorsk
{
    NSDictionary *dict = [self loadLanguageNynorskJsonFromFile];
    NSDictionary *ret = [self extractLists:dict];
    return ret;
}

+(NSDictionary*)extractLists:(NSDictionary*)dict
{
    NSArray *lists = [dict valueForKey:@"lists"];
    NSMutableDictionary *ret = [NSMutableDictionary new];
    for (NSDictionary *d in lists) {
        NSString *parentKey = d[@"parentkey"];
        if (!ret[parentKey]) {
            ret[parentKey] = [NSMutableDictionary new];
        }
        NSString *key = d[@"key"];
        if ([key isKindOfClass:[NSNull class]]) {
            assert(0); // cannot find "key" key
        }
        ret[parentKey][key] = d;
    }
    return ret;
}

+(NSArray*)extractInfoForLangBokmal
{
    NSDictionary *dict = [self loadLanguageBokmalJsonFromFile];
    NSArray *ret = [self extractInfo:dict];
    return ret;
}

+(NSArray*)extractInfoForLangNynorsk
{
    NSDictionary *dict = [self loadLanguageNynorskJsonFromFile];
    NSArray *ret = [self extractInfo:dict];
    return ret;
}

+(NSArray*)extractInfo:(NSDictionary*)dict
{
    NSArray *info = [dict valueForKey:@"info"];
    return info;
}

+(void)deleteExistingKommunes
{
    NSManagedObjectContext *c = [AppData getInstance].managedObjectContext;
    
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
    [all setEntity:[NSEntityDescription entityForName:@"Municipality" inManagedObjectContext:c]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [c executeFetchRequest:all error:&error];
    
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [c deleteObject:car];
    }
    NSError *saveError = nil;
    [c save:&saveError];
}

+(void)saveKommuneJsonToCoreData
{
    [self deleteExistingKommunes];
    
    NSDictionary *response = [self loadKommuneJsonFromFile];
    NSManagedObjectContext *moc = [AppData getInstance].managedObjectContext;
    NSArray *muncs = [response valueForKey:@"kommuner"];
    //NSLog(@"%@", muncs);
    
    for (int i = 0; i <[ muncs count]; i++) {
        
        Municipality *m = [NSEntityDescription insertNewObjectForEntityForName:@"Municipality" inManagedObjectContext:moc];
        
        if (![[[muncs objectAtIndex:i]valueForKey:@"adresse"]isEqual:[NSNull null]]) {
            
            m.address = [[muncs objectAtIndex:i]valueForKey:@"adresse"];
        }
        
        if (![[[muncs objectAtIndex:i]valueForKey:@"epost"]isEqual:[NSNull null]]) {
            
            m.email = [[muncs objectAtIndex:i]valueForKey:@"epost"];
        }
        if (![[[muncs objectAtIndex:i]valueForKey:@"fylke"]isEqual:[NSNull null]]) {
            
            m.county = [[muncs objectAtIndex:i]valueForKey:@"fylke"];
        }
        
        NSString *str = [[muncs objectAtIndex:i]valueForKey:@"knr"];
        m.mNr = str;
        
        if (![[[muncs objectAtIndex:i]valueForKey:@"kommunevapen"]isEqual:[NSNull null]]) {
            
            m.mWeapon = [[muncs objectAtIndex:i]valueForKey:@"kommunevapen"];
        }
        if (![[[muncs objectAtIndex:i]valueForKey:@"malform"]isEqual:[NSNull null]]) {
            
            m.language = [[muncs objectAtIndex:i]valueForKey:@"malform"];
        }
        
        if (![[[muncs objectAtIndex:i]valueForKey:@"navn"]isEqual:[NSNull null]]) {
            
            m.name = [[muncs objectAtIndex:i]valueForKey:@"navn"];
        }
        if (![[[muncs objectAtIndex:i]valueForKey:@"postnr"]isEqual:[NSNull null]]) {
            
            m.zipCode = [[muncs objectAtIndex:i]valueForKey:@"postnr"];
        }
        if (![[[muncs objectAtIndex:i]valueForKey:@"poststed"]isEqual:[NSNull null]]) {
            
            m.zipPlace = [[muncs objectAtIndex:i]valueForKey:@"poststed"];
        }
        if (![[[muncs objectAtIndex:i]valueForKey:@"tlf"]isEqual:[NSNull null]]) {
            
            m.phone = [[muncs objectAtIndex:i]valueForKey:@"tlf"];
        }
    }
    
    NSError *error;
    BOOL success = [moc save:&error];
    assert(success);
}

+(NSMutableSet*)getCopyOfAllTemplates
{
    BOOL isBokmal = [LabelManager getCurrentLanguage] == kLanguageBokmal;
    NSDictionary *response = isBokmal ? [self loadLanguageBokmalJsonFromFile] : [self loadLanguageNynorskJsonFromFile];
    //NSLog(@"RESPONSE: %@" , response);
    
    NSError *error;
    NSManagedObjectContext *moc = [AppData getInstance].managedObjectContext;
    NSString *code = isBokmal ? @"nb_NO" : @"nn_NO";
    NSArray *templates = [response valueForKey:code];
    NSMutableSet *allTemplates = [[NSMutableSet alloc] init];
    
    for (int i = 0; i < [templates count]; i++) {
        NSArray *array = [templates valueForKey:[NSString stringWithFormat:@"0%i" , i + 1]];
        
        Template *template = [NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:moc];
        template.templateLanguage = [array valueForKey:@"Malform"];
        template.templateName = [array valueForKey:@"Navn"];
        template.templateId = [NSNumber numberWithInt:i];
        
        if ([[array valueForKey:@"Tema"]isKindOfClass:[NSDictionary class]]) {
            NSArray *allKeys = [[array valueForKey:@"Tema"]allKeys];
            for (int x = 0; x < [allKeys count]; x++) {
                Theme *theme = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:moc];
                theme.themeId = [NSNumber numberWithInt:[[allKeys objectAtIndex:x]intValue]];
                theme.themeName = [[array valueForKey:@"Tema"]valueForKey:[allKeys objectAtIndex:x]];
                [template addThemesObject:theme];
            }
        } else if([[array valueForKey:@"Tema"]isKindOfClass:[NSArray class]]) {
            NSArray *themes = [array valueForKey:@"Tema"];
            for (int x = 0; x < [themes count]; x++) {
                Theme *theme = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:moc];
                theme.themeId = [NSNumber numberWithInt:x];
                theme.themeName = [themes objectAtIndex:x];
                [template addThemesObject:theme];
            }
        }
        
        NSDictionary *checklists = [array valueForKey:@"Sjekklister"];
        NSArray *allCheckListKeys = [checklists allKeys];
        for (int j = 0; j < [allCheckListKeys count]; j++) {
            NSString *key = allCheckListKeys[j];
            NSNumberFormatter *f = [NSNumberFormatter new];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *nKey = [f numberFromString:key];
            Checklist *checklist = [NSEntityDescription insertNewObjectForEntityForName:@"Checklist" inManagedObjectContext:moc];
            checklist.checklistId = nKey;
            checklist.checklistName = [[checklists valueForKey:[allCheckListKeys objectAtIndex:j]]valueForKey:@"Navn"];
            //NSString *clistname = checklist.checklistName;
            NSArray *subtitleArray = [[checklists valueForKey:[allCheckListKeys objectAtIndex:j]]valueForKey:@"Undertittel"];
            for (int k = 0; k < [subtitleArray count]; k++) {
                //ChecklistSubTitle
                // NSLog(@"UNDERTITTEL: %@" , [subtitleArray objectAtIndex:k]);
                ChecklistSubtitle *checklistSubTitle = [NSEntityDescription insertNewObjectForEntityForName:@"ChecklistSubtitle" inManagedObjectContext:moc];
                checklistSubTitle.subtitleId = [NSNumber numberWithInt:k];
                checklistSubTitle.subtitleName = [subtitleArray objectAtIndex:k];
                [checklist addSubtitlesObject:checklistSubTitle];
            }
            
            NSArray *keys = [[checklists valueForKey:[allCheckListKeys objectAtIndex:j]]allKeys];
            for (int k = 0; k < [keys count]; k++) {
                if ([[[checklists valueForKey:[allCheckListKeys objectAtIndex:j]]valueForKey:[keys objectAtIndex:k]]isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *lists = [[checklists valueForKey:[allCheckListKeys objectAtIndex:j]]valueForKey:[keys objectAtIndex:k]];
                    NSArray *allListKeys = [lists allKeys];
                    
                    NSString *key = keys[k];
                    NSNumberFormatter *f = [NSNumberFormatter new];
                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    NSNumber *nKey = [f numberFromString:key];
                    
                    AuditType *auditType = [NSEntityDescription insertNewObjectForEntityForName:@"AuditType" inManagedObjectContext:moc];
                    auditType.auditTypeId = nKey;
                    auditType.auditTypeName = [lists valueForKey:@"Navn"];
                    //NSString *atname = auditType.auditTypeName;
                    
                    //NSLog(@"Template name: %@ AuditType id:%@ name:%@", template.templateName, auditType.auditTypeId, auditType.auditTypeName);
                    
                    for (int h = 0; h < [allListKeys count]; h++) {
                        if ([[lists valueForKey:[allListKeys objectAtIndex:h]]isKindOfClass:[NSDictionary class]]) {
                            //Pursuant
                            NSArray *pursuants = [[lists valueForKey:[allListKeys objectAtIndex:h]]valueForKey:@"Hjemmel"];
                            NSMutableSet *pursuantsSet = [NSMutableSet new];
                            for (int m = 0; m < [pursuants count]; m++) {
                                Pursuant *pursuant = [NSEntityDescription insertNewObjectForEntityForName:@"Pursuant" inManagedObjectContext:moc];
                                // NSLog(@"Pursuant: %@" , [pursuants objectAtIndex:m]);
                                pursuant.pursuantId = [NSNumber numberWithInt:m];
                                pursuant.pursuantName = [pursuants objectAtIndex:m];
                                [auditType addPursuantsObject:pursuant];
                                [pursuantsSet addObject:pursuant];
                            }
                            
                            //CheckPoints
                            NSDictionary *checkPoints = [lists valueForKey:[allListKeys objectAtIndex:h]][@"Sjekkpunkt"];
                            NSMutableSet *checkpointsSet = [NSMutableSet new];
                            // here we have to check it's a dictionary. In the web service, it seems that if there are no values for Sjekkpunkt,
                            // for some reason the format is then an array
                            if ([checkPoints isKindOfClass:[NSDictionary class]]) {
                                for (NSString *key in checkPoints.allKeys) {
                                    NSString *val = [checkPoints objectForKey:key];
                                    
                                    NSNumberFormatter *f = [NSNumberFormatter new];
                                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                                    NSNumber *nKey = [f numberFromString:key];
                                    
                                    CheckPoint *checkPoint = [NSEntityDescription insertNewObjectForEntityForName:@"CheckPoint" inManagedObjectContext:moc];
                                    checkPoint.checkPointId = nKey;
                                    checkPoint.checkPointName = val;
                                    [auditType addCheckpointsObject:checkPoint];
                                    [checkpointsSet addObject:checkPoint];
                                }
                            }
                            
                            //ThemeReference
                            NSArray *themeRef = [[lists valueForKey:[allListKeys objectAtIndex:h]]valueForKey:@"TemaRef"];
                            for (int b = 0; b < [themeRef count]; b++) {
                                //NSLog(@"ThemeRef: %@" , [themeRef objectAtIndex:b]);
                                ThemeReference *themeReference = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeReference" inManagedObjectContext:moc];
                                themeReference.themeRefId = [NSNumber numberWithInt:b];
                                themeReference.themeRefNumber = [NSNumber numberWithInt:[[themeRef objectAtIndex:b]intValue]];
                                [auditType addThemeRefsObject:themeReference];
                            }
                            
                            //Question
                            NSString *questionString = [[lists valueForKey:[allListKeys objectAtIndex:h]]valueForKey:@"Sporsmal"];
                            Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:moc];
                            NSString *val = (NSString*)allListKeys[h];
                            if ([val isEqualToString:@"Navn"]) {
                                val = @"-1";
                            }
                            NSInteger index = [val integerValue];
                            question.questionIndex = question.questionId = [NSNumber numberWithInt:index];
                            question.questionName = questionString;
                            [question addCheckpoints:checkpointsSet];
                            [question addPursuants:pursuantsSet];
                            [auditType addQuestionsObject:question];
                        }
                    }
                    [checklist addAudiTypesObject:auditType];
                }else{
                }
            }
            [template addChecklistsObject:checklist];
        }
        [allTemplates addObject:template];
    }
    
    BOOL success = [moc save:&error];
    if (!success) {
        NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
        assert(0);
    }
    
    return allTemplates;
}

@end
