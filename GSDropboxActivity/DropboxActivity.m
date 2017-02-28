//
//  DropboxActivity.m
//  DiBK Tilsyn
//
//  Created by Ina Roesjorde on 18/06/14.
//  Copyright (c) 2014 no.dibk. All rights reserved.
//

#import "DropboxActivity.h"

@implementation DropboxActivity

+ (NSString *)activityTypeString
{
    return @"no.DiBK.Tilsynsapp.DropboxActivity";
}

- (NSString *)activityType {
    return [DropboxActivity activityTypeString];
}

- (NSString *)activityTitle {
    return @"Dropbox";
}

- (UIImage *)activityImage {
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] integerValue] <= 6) {
        return [UIImage imageNamed:@"DropboxActivityIcon-iOS6"];
    } else {
        return [UIImage imageNamed:@"DropboxActivityIcon"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
};

- (void) performActivity
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginDropBox" object:nil];
}

@end