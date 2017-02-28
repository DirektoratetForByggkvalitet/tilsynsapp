//
//  ListManager.h
//  DiBK
//
//  Created by david stummer on 11/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListManager : NSObject

+ (NSArray*)getListForParent:(NSString*)parentKey andKey:(NSString *)key;
+ (NSString*)getNumberValueForParent:(NSString*)parentKey andKey:(NSString *)key andText:(NSString*)text;

@end
