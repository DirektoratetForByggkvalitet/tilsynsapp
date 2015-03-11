//
//  Lang.m
//  DiBK
//
//  Created by david stummer on 03/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "LabelManager.h"
#import "WebServiceManager.h"

@implementation LabelManager

+ (NSString*)getTextForParent:(NSString*)parentKey Key:(NSString *)key
{
    WebServiceManager *man = [WebServiceManager getInstance];
    NSDictionary *labels = [self getCurrentLanguage] == kLanguageBokmal ? [man getLabelsForLanguageBokmal] : [man getLabelsForLanguageNynorsk];
    labels = labels[parentKey];
    //NSLog(@"labels: %@", labels);
    if (!labels) {
        NSLog(@"LabelManager Error: parent key missing (%@)", parentKey);
        //assert(0);
        return @"";
    }
    NSString *lblText = labels[key][@"string"];
    if (!lblText) {
        NSLog(@"LabelManager Error: child key missing (%@)", key);
        //assert(0);
        return @"";
    }
    return lblText;
}

+(Language)getCurrentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Language lang = [defaults integerForKey:@"language"];
    return lang;
}

+(NSString*)getCurrentLanguageName
{
    Language *l = [self getCurrentLanguage];
    NSString *name = l == kLanguageBokmal ? @"Bokmål" : @"Nynorsk";
    return name;
}

+(void)switchLanguage
{
    Language lang = ![self getCurrentLanguage];
    [[NSUserDefaults standardUserDefaults] setInteger:lang forKey:@"language"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchLanguage" object:nil];
}

@end