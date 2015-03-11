//
//  ChecklistSubtitle.h
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChecklistSubtitle : NSManagedObject

@property (nonatomic, retain) NSNumber * subtitleId;
@property (nonatomic, retain) NSString * subtitleName;
@property (nonatomic, retain) NSManagedObject *checklist;

@end
