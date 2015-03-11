//
//  Chap3QuestionsView.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap3View.h"
#import "FormScrollView.h"
#import "CameraOverlayView.h"
#import "QuestionCommentsView.h"
#import "EditOverlayView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation Chap3View
@synthesize navBarView = _navBarView;
@synthesize backButton = _backButton;
@synthesize frontPageButton = _frontPageButton;
@synthesize formScrollView = _formScrollView;
@synthesize cameraOverlayView, questionCommentsView, editOverlayView, rightNav, munLabel;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController *)c
{
    self = [super initWithFrame:frame];
    if (self) {
        controller = c;
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 103.0f)];
        [_navBarView setBackgroundColor:[UIColor colorWithRed:189.0f/255.0f green:184.0f/255.0f blue:79.0f/255.0f alpha:1.0f]];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(9, -2, 35.5f, 103.0f)];
        [_backButton setImage:[UIImage imageNamed:@"backButtonBlack"] forState:UIControlStateNormal];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 25.0f, 28.0f, 600.0f, 50.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
        [label setTextColor:[UIColor blackColor]];
        label.text = [LabelManager getTextForParent:@"chapter_three_screen" Key:@"text_1"];
        
        UILabel* _municipalityLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, 730.0f, 40.0f)];
        [_municipalityLabel setBackgroundColor:[UIColor clearColor]];
        [_municipalityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:19.0f]];
        [_municipalityLabel setTextColor:[UIColor blackColor]];
        [_municipalityLabel setTextAlignment:UITextAlignmentRight];
        [_municipalityLabel setText:@"08/1516 Fjordalleen 16"];
        munLabel = _municipalityLabel;
        
        _scrollView = [[FormScrollView alloc]initWithFrame:CGRectMake(0, 103, 768, 836)];
        [_scrollView setChap3View: self];
        [self setFormScrollView:_scrollView];
        
        UILabel *scoreBg = [ [UILabel alloc ] initWithFrame:CGRectMake(0, frame.size.height-85, frame.size.width, 85)];
        scoreBg.backgroundColor = [ColorSchemeManager getBgColor];
        [self addSubview:scoreBg];
        
        UIView *scoreBgBorder = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-85, frame.size.width, 1)];
        [scoreBgBorder setBackgroundColor:[UIColor colorWithRed:52.0f/255.0f green:79.0f/255.0f blue:87.0f/255.0f alpha:1]];
        [self addSubview:scoreBgBorder];
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-50, frame.size.height-60, 100, 15)];
        _scoreLabel.textAlignment = UITextAlignmentCenter;
        _scoreLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _scoreLabel.textColor = [ColorSchemeManager getFooterPagingTextColor];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(15.0)];
        _scoreLabel.text = [NSString stringWithFormat: @"%d/%d", 2, 2];
        [self addSubview:_scoreLabel];
        
        _frontPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_frontPageButton setTitle:[LabelManager getTextForParent:@"general" Key:@"back_menu"] forState:UIControlStateNormal];
        [_frontPageButton setFrame:CGRectMake(10, frame.size.height-72, 150, 43)];
        [_frontPageButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f]];
        [_frontPageButton addTarget:self action:@selector(navigateToFrontPage) forControlEvents:UIControlEventTouchUpInside];
        
        rightNav = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-(20+46), frame.size.height-72, 46, 43)];
        [rightNav setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        [self addSubview:rightNav];
        
        [self addSubview:_navBarView];
        [self addSubview:_backButton];
        [self addSubview:_frontPageButton];
        [self addSubview:_scrollView];
        [self addSubview:label];
        [self addSubview:_municipalityLabel];

        [self setBackgroundColor:[ColorSchemeManager getBgColor]];
        
        cameraOverlayView = [[CameraOverlayView alloc] initWithFrame:frame andController:controller];
        [cameraOverlayView setHidden:TRUE];
        [self addSubview:cameraOverlayView];
        
        questionCommentsView = [[QuestionCommentsView alloc] initWithFrame:frame andController:controller];
        [questionCommentsView setHidden:TRUE];
        [self addSubview:questionCommentsView];
        
        editOverlayView = [[EditOverlayView alloc] initWithFrame:frame andController:controller];
        [editOverlayView setHidden:TRUE];
        [self addSubview:editOverlayView];
    }
    return self;
}

- (void)pageChanged:(int)page withTotal:(int)total
{
    _scoreLabel.text = [NSString stringWithFormat: @"%d/%d", page, total];
}

-(void) navigateToFrontPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateBackToFrontPage" object:nil];
    [self endEditing:YES];
}

@end
