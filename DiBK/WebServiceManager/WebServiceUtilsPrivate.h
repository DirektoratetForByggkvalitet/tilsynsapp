//
//  WebServiceUtils.h
//  DiBK
//
//  Created by david stummer on 08/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceUtilsPrivate : NSObject

+ (BOOL)cachedFilesExist;
+(NSString*)getKommuneJsonFilePath;
+(NSString*)getLanguageBokmalJsonFilePath;
+(NSString*)getLanguageNynorskJsonFilePath;
+(NSString*)getCachesFolder;
+(void)saveKommuneJsonToCoreData;
+(NSMutableSet*)getCopyOfAllTemplates;
+(NSDictionary*)extractLabelsArrForLangBokmal;
+(NSDictionary*)extractLabelsArrForLangNynorsk;
+(NSDictionary*)extractListsArrForLangBokmal;
+(NSDictionary*)extractListsArrForLangNynorsk;
+(NSArray*)extractInfoForLangBokmal;
+(NSArray*)extractInfoForLangNynorsk;

@end
