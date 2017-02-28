//
//  Conclusion.m
//  DiBK
//
//  Created by david stummer on 08/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Conclusion.h"


@implementation Conclusion

@dynamic nYes;
@dynamic nNo;
@dynamic nMaybe;
@dynamic combo1;
@dynamic checkbox;
@dynamic textview2;
@dynamic textview1;
@dynamic combo2;

- (void)awakeFromInsert
{
    if (self.checkbox.length == 0) {
        self.checkbox = @"yes";
    }
}

@end
