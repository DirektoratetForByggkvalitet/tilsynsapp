//
//  DiBKRapportPartView.m
//  DiBK
//
//  Created by Grafiker2 on 05.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Chap1View.h"
#import "Chap1ScrollView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation Chap1View
@synthesize navBarView = _navBarView;
@synthesize backButton = _backButton;
@synthesize frontPageButton = _frontPageButton;
@synthesize municipalityLabel = _municipalityLabel;
@synthesize rapportPartLabel = _rapportPartLabel;
@synthesize rapportTitleLabel = _rapportTitleLabel;
@synthesize scrollView = _scrollView;
@synthesize rightNav;

static const int NAVBAR_HEIGHT = 103;
static const int PAGE_HEIGHT = 836;
static const int FOOTER_HEIGHT = 65;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 103.0f)];
        [_navBarView setBackgroundColor:[UIColor colorWithRed:81.0f/255.0f green:114.0f/255.0f blue:170.0f/255.0f alpha:1.0f]];
         
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(9, -2, 35.5f, 103.0f)];
        [_backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        
        _rapportPartLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 25.0f, 28.0f, 400.0f, 50.0f)];
        [_rapportPartLabel setBackgroundColor:[UIColor clearColor]];
        [_rapportPartLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
        [_rapportPartLabel setTextColor:[UIColor whiteColor]];
        _rapportPartLabel.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_1"];
        
        _municipalityLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, 730.0f, 40.0f)];
        [_municipalityLabel setBackgroundColor:[UIColor clearColor]];
        [_municipalityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:19.0f]];
        [_municipalityLabel setTextColor:[UIColor whiteColor]];
        [_municipalityLabel setTextAlignment:UITextAlignmentRight];

        _scrollView = [[Chap1ScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, frame.size.width, PAGE_HEIGHT)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setChap1View: self];
        
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
        [self addSubview:_rapportPartLabel];
        [self addSubview:_municipalityLabel];
        [self addSubview:_scrollView];
        
        [self setBackgroundColor:[ColorSchemeManager getBgColor]];
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
