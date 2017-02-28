//
//  Info.m
//  DiBK
//
//  Created by david stummer on 28/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Info.h"
#import "WebServiceManager.h"
#import "LabelManager.h"
#import "Question.h"
#import "CheckPoint.h"
#import "LabelManager.h"
#import "Pursuant.h"

@implementation Info
@synthesize title,paragraphs,hjemmelParagraphs,hjemmelTitle,hjemmelExists;

-(id)init
{
    self = [super init];
    if (self) {
        paragraphs = [NSMutableArray new];
        hjemmelParagraphs = [NSMutableArray new];
        hjemmelExists = NO;
    }
    return self;
}

+(NSArray*)sortedCheckpoints:(NSSet*)cps
{
    NSArray *arr = cps.allObjects;
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        CheckPoint *first = (CheckPoint*)a;
        CheckPoint *second = (CheckPoint*)b;
        return [first.checkPointId compare:second.checkPointId];
    }];
    return arr;
}

+(void)showInfoScreenForQuestion:(Question *)question
{
    Info *i = [Info new];
    i.title = [LabelManager getTextForParent:@"general" Key:@"checklist_info_title"];
    NSSet *cps = question.checkpoints;
    if (cps && cps.count > 0) {
        NSArray *arr = [self sortedCheckpoints:cps];
        for (CheckPoint *checkpoint in arr) {
            if (!(!checkpoint.checkPointName || [checkpoint.checkPointName isEqualToString:@""])) {
                [i.paragraphs addObject:checkpoint.checkPointName];
            }
        }
    } else {
        NSString *label = [LabelManager getTextForParent:@"general" Key:@"checklist_info_missing"];
        [i.paragraphs addObject:label];
    }
    NSSet *hjemmelSet = question.pursuants;
    if (hjemmelSet && hjemmelSet.count > 0) {
        i.hjemmelExists = YES;
        i.hjemmelTitle = [LabelManager getTextForParent:@"general" Key:@"checklist_ref_title"];
        for (Pursuant *pursuant in hjemmelSet) {
            if (!(!pursuant.pursuantName || [pursuant.pursuantName isEqualToString:@""])) {
                [i.hjemmelParagraphs addObject:pursuant.pursuantName];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Info" object:i];
}

+(void)showInfoScreenForkey:(NSString *)key
{
    Info *i = [self getInfoObjectForkey:key];
    if (i) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Info" object:i];
    }
}

+ (Info*)getInfoObjectForkey:(NSString *)key
{
    WebServiceManager *wsm = [WebServiceManager getInstance];
    NSArray *info = [LabelManager getCurrentLanguage] == kLanguageBokmal ? [wsm getInfoForLanguageBokmal] : [wsm getInfoForLanguageNyorsk];
    NSDictionary *d;
    for (NSDictionary *dict in info) {
        NSString *k = dict[@"key"];
        if ([k isEqualToString:key]) {
            d = dict;
            break;
        }
    }
    if (!d) {
        NSLog(@"Info object doesn't exist for key:%@", key);
        return nil;
    }
    Info *i = [Info new];
    i.title = d[@"title"];
    i.paragraphs = d[@"paragraphs"];
    return i;
}

@end