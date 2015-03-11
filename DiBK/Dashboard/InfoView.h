//
//  InfoView.h
//  DiBK
//
//  Created by david stummer on 28/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Info;

@interface InfoView : UIView
{
    Info *info;
    UIView *mainView;
    UILabel *title, *title2;
    UITextView *p1, *p2;
}


- (void)doShowWithInfo:(Info*)i;

@end
