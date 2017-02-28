//
//  ImageUtils.h
//  DiBK
//
//  Created by david stummer on 23/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

+ (NSString*)imagePathForKey:(NSString *)key;
+ (UIImage*)retrieveThumbnailImageFromFileForID:(NSString*)photoId;
+ (UIImage*)retrieveFullsizeImageFromFileForID:(NSString*)photoId;
+ (void)deleteImageForID:(NSString*)photoId;
+ (void)saveImageToFile:(UIImage*)image withName:(NSString*)name;
+ (void)saveImageThumbnailToFile:(UIImage*)image withName:(NSString*)name;
+ (UIImage*)genThumbnail:(UIImage*)image;

@end
