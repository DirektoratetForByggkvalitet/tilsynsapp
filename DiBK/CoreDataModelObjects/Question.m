//
//  Question.m
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Question.h"
#import "AuditType.h"
#import "Photo.h"
#import "AppData.h"

@implementation Question

@dynamic questionId;
@dynamic questionName;
@dynamic auditType, photos, answer, questionComment, questionIndex, checkpoints, pursuants;

- (void)awakeFromInsert
{
    if (self.answer.length == 0) {
        self.answer = @"none";
    }
    
    if ([self.photos count] == 0) {
        for (int i = 0; i < 5; i++) {
            Photo *photo = [[AppData getInstance] newPhoto];
            photo.index = [NSNumber numberWithInt:i];
            [self addPhotoObject:photo];
        }
    }
}

- (BOOL)hasAtLeastOnePhoto
{
    for (Photo *photo in self.photos) {
        if (photo.id.length > 0) {
            return TRUE;
        }
    }
    return FALSE;
}

// http://stackoverflow.com/questions/7385439/exception-thrown-in-nsorderedset-generated-accessors
- (void)addPhotoObject:(Photo*)value {
    NSMutableSet* tempSet = [NSMutableSet setWithSet:self.photos];
    [tempSet addObject:value];
    self.photos = tempSet;
}

@end
