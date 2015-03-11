//
//  ImageUtils.m
//  DiBK
//
//  Created by david stummer on 23/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ImageUtils.h"
#import "FileSystemUtils.h"

@implementation ImageUtils

+ (UIImage*)retrieveFullsizeImageFromFileForID:(NSString*)photoId
{
    if ([photoId isEqualToString:@""]) {
        return nil;
    }
    
    NSString *path = [self imagePathForKey:photoId];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

+ (UIImage*)retrieveThumbnailImageFromFileForID:(NSString*)photoId
{
    if ([photoId isEqualToString:@""]) {
        return nil;
    }
    photoId = [photoId stringByAppendingString:@"-thumb"];
    
    NSString *path = [self imagePathForKey:photoId];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

+ (NSString*)imagePathForKey:(NSString *)key
{
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"ImageCaches"];
    [FileSystemUtils createPath:dir];
    return [dir stringByAppendingPathComponent:key];
}

+ (void)deleteImageForID:(NSString*)photoId
{
    if (photoId) {
        // we must delete any existing images
        NSString *fullSizePath = [self imagePathForKey:photoId];
        NSString *thumbPath = [[self imagePathForKey:photoId] stringByAppendingString:@"-thumb"];
        NSError *error;
        BOOL ret;
        ret = [[NSFileManager defaultManager] removeItemAtPath:fullSizePath error:&error];
        NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
        ret = [[NSFileManager defaultManager] removeItemAtPath:thumbPath error:&error];
        NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
    }
}

+ (void)saveImageToFile:(UIImage*)image withName:(NSString*)name
{
    NSString *imagePath = [self imagePathForKey:name];
    NSLog(@"imagePath: %@", imagePath);
    NSData *d = UIImageJPEGRepresentation(image, 0.5);
    [d writeToFile:imagePath atomically:YES];
}

+ (void)saveImageThumbnailToFile:(UIImage*)image withName:(NSString*)name
{
    NSString *imagePath = [self imagePathForKey:name];
    NSLog(@"thumb imagePath: %@", imagePath);
    NSData *d = UIImagePNGRepresentation(image);
    [d writeToFile:imagePath atomically:YES];
}

+ (UIImage*)genThumbnail:(UIImage*)image
{
    CGSize origImageSize = [image size];
    
    CGRect newRect = CGRectMake(0, 0, 120, 120);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
