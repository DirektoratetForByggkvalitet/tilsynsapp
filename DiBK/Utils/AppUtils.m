//
//  AppUtils.m
//  DiBK
//
//  Created by david stummer on 23/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "AppUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "AppData.h"
#import "Municipality.h"

@implementation AppUtils

+ (NSString*)jsonStringFromDict:(NSDictionary*)json
{
    BOOL isValid = [NSJSONSerialization isValidJSONObject:json];
    assert(isValid);
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:nil error:&error];
    if (data == nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (int)getDaysSinceDate:(NSDate*)lastDate
{
    NSDate *todaysDate = [NSDate date];
    NSTimeInterval lastDiff = [lastDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [todaysDate timeIntervalSinceNow];
    NSTimeInterval dateDiff = todaysDiff - lastDiff;
    dateDiff /= 86400;
    int time = round(dateDiff);
    return time;
}

+ (NSDate*)getFileCreationDate:(NSString*)filePath
{
    NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate *lastDate = [fileAttribs fileCreationDate];
    return lastDate;
}

+ (int)getDaysSinceFileCreated:(NSString *)filePath
{
    NSDate *lastDate = [self getFileCreationDate:filePath];
    return [self getDaysSinceDate:lastDate];
}


+ (NSString*)getNumbersFromStr:(NSString*)str
{
    NSString *originalString = str;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }

    return strippedString;
}

+ (NSString*)extractKommuneCodeFromString:(NSString *)str
{
    NSString *code = [self getNumbersFromStr:str];
    return code;
}

+ (NSArray*)getAllMunicipalities
{
    NSArray *array = nil;
    if (array == nil) {
        NSManagedObjectContext *context = [[AppData getInstance] managedObjectContext];
        NSFetchRequest *all = [[NSFetchRequest alloc] init];
        [all setEntity:[NSEntityDescription entityForName:@"Municipality" inManagedObjectContext:context]];
        [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        array = [context executeFetchRequest:all error:&error];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Municipality *first = (Municipality*)a;
        Municipality *second = (Municipality*)b;
        return [first.name localizedCaseInsensitiveCompare:second.name];
    }];
    
    return array;
}

@end
