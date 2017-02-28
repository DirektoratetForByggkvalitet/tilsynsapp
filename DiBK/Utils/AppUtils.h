//
//  AppUtils.h
//  DiBK
//
//  Created by david stummer on 23/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIImageCallback)(UIImage*);

@class Municipality;

@interface AppUtils : NSObject

+ (NSString*)jsonStringFromDict:(NSDictionary*)json;
+ (int)getDaysSinceDate:(NSDate*)lastDate;
+ (int)getDaysSinceFileCreated:(NSString*)filePath;
+ (NSDate*)getFileCreationDate:(NSString*)filePath;
+ (NSString*)extractKommuneCodeFromString:(NSString*)str;
+ (NSArray*)getAllMunicipalities;

@end
