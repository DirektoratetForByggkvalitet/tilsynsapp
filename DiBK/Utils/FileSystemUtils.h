//
//  FileSystemUtils.h
//  DiBK
//
//  Created by david stummer on 30/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemUtils : NSObject

+ (void)clearDownloadCache;
+ (void)createPath:(NSString*)path;
+ (NSString*)getCachedFilePathForName:(NSString*)fileName;
+(NSString*)docsDir;
+ (NSString*)downloadCacheDir;
+ (void)savePDF:(NSMutableData*)data toFile:(NSString*)path;

@end
