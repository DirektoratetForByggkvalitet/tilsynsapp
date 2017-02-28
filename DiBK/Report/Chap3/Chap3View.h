//
//  Chap3QuestionsView.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormScrollView, CameraOverlayView, QuestionCommentsView, EditOverlayView;

@interface Chap3View : UIView
{
    FormScrollView* _scrollView;
    UILabel* _scoreLabel;
    UIViewController *controller;
}

@property(strong,nonatomic)UILabel *munLabel;
@property(strong,nonatomic)UIButton *rightNav;
@property(strong,nonatomic)EditOverlayView *editOverlayView;
@property(strong,nonatomic)QuestionCommentsView *questionCommentsView;
@property(strong, nonatomic)CameraOverlayView *cameraOverlayView;
@property(strong, nonatomic)UIView *navBarView;
@property(strong, nonatomic)UIButton* backButton;
@property(strong, nonatomic)UIButton *frontPageButton;
@property(strong, nonatomic)FormScrollView* formScrollView;

- (void)pageChanged:(int)page withTotal:(int)total;
- (id)initWithFrame:(CGRect)frame andController:(UIViewController *)c;

@end
