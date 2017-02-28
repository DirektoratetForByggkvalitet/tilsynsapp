//
//  Theme.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Template;

@interface Theme : NSManagedObject

@property (nonatomic, retain) NSNumber * themeId;
@property (nonatomic, retain) NSString * themeName;
@property (nonatomic, retain) Template *template;

@end
