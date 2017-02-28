//
//  ListManager.m
//  DiBK
//
//  Created by david stummer on 11/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ListManager.h"
#import "WebServiceManager.h"
#import "LabelManager.h"

@implementation ListManager

+ (NSArray*)getListForParent:(NSString *)parentKey andKey:(NSString *)key
{
    NSArray *items = [self getItemsArrForParent:parentKey andKey:key];
    NSMutableArray *itemTexts = [NSMutableArray new];
    for (NSDictionary *item in items) {
        NSString *text = item[@"text"];
        if (text/* && text.length > 0*/) {
            [itemTexts addObject:text];
        }
    }
    return itemTexts;
}

+ (NSString*)getNumberValueForParent:(NSString *)parentKey andKey:(NSString *)key andText:(NSString *)text
{
    NSString *retVal = @"";
    NSArray *items = [self getItemsArrForParent:parentKey andKey:key];
    for (NSDictionary *item in items) {
        NSString *text2 = item[@"text"];
        if (text2 && [text2 isEqualToString:text]) {
            retVal = item[@"value"];
        }
    }
    return retVal;
}

+ (NSArray*)getItemsArrForParent:(NSString*)parentKey andKey:(NSString*)key
{
    WebServiceManager *man = [WebServiceManager getInstance];
    NSDictionary *lists = [LabelManager getCurrentLanguage] == kLanguageBokmal ? [man getListsForLanguageBokmal] : [man getListsForLanguageNynorsk];
    lists = lists[parentKey];
    if (!lists) {
        assert(0);
        return @[];
    }
    NSDictionary *list = lists[key];
    if (!list) {
        assert(0);
        return @[];
    }
    NSArray *items = list[@"items"];
    if (!items) {
        assert(0);
        return @[];
    }
    return items;
}

@end