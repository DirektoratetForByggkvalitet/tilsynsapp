//
//  QuestionCommentsView.h
//  DiBK
//
//  Created by david stummer on 06/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionView;

@interface QuestionCommentsView : UIView <UITextViewDelegate>
{
    UIViewController *controller;
    UIView *polaroid;
}

@property(nonatomic,strong)QuestionView *questionView;
@property(nonatomic,strong)UITextView *textView;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController*)c;

@end
