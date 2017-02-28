//
//  EditOverlayView.h
//  DiBK
//
//  Created by david stummer on 07/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionView;

@interface EditOverlayView : UIView <UITextViewDelegate>
{
    UIViewController *controller;
    UIView *polaroid;
    UITextView *textView;
    BOOL cb1Selected;
    UIButton *cb1, *cb2;
    UILabel *lblSelectedQuestion;
}

@property(nonatomic,strong)QuestionView *questionView;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController*)c;

@end
