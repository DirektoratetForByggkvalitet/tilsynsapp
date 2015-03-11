//
//  Photo.h
//  DiBK
//
//  Created by david stummer on 31/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic) NSNumber * index;
@property(nonatomic,strong)NSString* text;

@end
