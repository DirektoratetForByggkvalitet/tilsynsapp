//
//  DiBKStartView.m
//  DiBK
//
//  Created by Magnus Hasfjord on 19.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "StartView.h"
#import "KommuneTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation StartView
@synthesize startingView = _startingView;
@synthesize yourNameTextField = _yourNameTextField;
@synthesize yourMunicipalTextField = _yourMunicipalTextField;
@synthesize bokmalRadioButton = _bokmalRadioButton;
@synthesize bokmalButton = _bokmalButton;
@synthesize nynorskRadioButton = _nynorskRadioButton;
@synthesize nynorskButton = _nynorskButton;
@synthesize continueButton = _continueButton;
@synthesize beforeYouStartLabel, yourNameLabel, yourMunicipalityLabel, chooseLanguageFormLabel, chooseLanguageFormLabelLineView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundImageView = [[UIImageView alloc]initWithFrame:frame];
        [backgroundImageView setImage:[UIImage imageNamed:@"startBackground"]];
        [backgroundImageView setUserInteractionEnabled:YES];
        
        logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(58.0f, 40.0f, 184.0f, 219.0f)];
        [logoImageView setImage:[UIImage imageNamed:@"dibkLogoBlue"]];
        
        _startingView = [[UIView alloc]initWithFrame:CGRectMake(768.0f, 0.0f, frame.size.width, frame.size.height)];
        [_startingView setBackgroundColor:[UIColor whiteColor]];
        [_startingView setAlpha:0.94f];
        
        beforeYouStartLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImageView.frame.origin.x + logoImageView.frame.size.width, logoImageView.frame.origin.y + round(logoImageView.frame.origin.y / 2), 500.0f, 100.0f)];
        [beforeYouStartLabel setBackgroundColor:[UIColor clearColor]];
        [beforeYouStartLabel setTextAlignment:NSTextAlignmentLeft];
        [beforeYouStartLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:44.0f]];
        [beforeYouStartLabel setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        [beforeYouStartLabel setText:@"Før du starter..."];
        
        yourNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75.0f, logoImageView.frame.origin.y + logoImageView.frame.size.height + 15.0f, 500.0f, 100.0f)];
        [yourNameLabel setBackgroundColor:[UIColor clearColor]];
        [yourNameLabel setTextAlignment:NSTextAlignmentLeft];
        [yourNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:32.0f]];
        [yourNameLabel setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        [yourNameLabel setText:@"Ditt navn"];
        
        UIView *yourNameLabelLineView = [[UIView alloc]initWithFrame:CGRectMake(yourNameLabel.frame.origin.x, yourNameLabel.frame.origin.y + 65.0f, 130.0f, 1.0f)];
        [yourNameLabelLineView setBackgroundColor:[UIColor colorWithRed:83.0/255.0 green:172.0/255.0 blue:184.0/255.0 alpha:1.0]];
        
        _yourNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(yourNameLabel.frame.origin.x, yourNameLabel.frame.origin.y + yourNameLabel.frame.size.height - 10.0f, 275.0f, 40.0f)];
        _yourNameTextField.layer.borderColor= [[UIColor blackColor]CGColor];
        _yourNameTextField.layer.borderWidth = 1.0f;
        _yourNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _yourNameTextField.leftView = paddingView;
        _yourNameTextField.leftViewMode = UITextFieldViewModeAlways;
        [_yourNameTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:25.0f]];
        
        yourMunicipalityLabel = [[UILabel alloc]initWithFrame:CGRectMake(yourNameLabel.frame.origin.x, _yourNameTextField.frame.origin.y + 55.0f, yourNameLabel.frame.size.width, yourNameLabel.frame.size.height)];
        [yourMunicipalityLabel setBackgroundColor:[UIColor clearColor]];
        [yourMunicipalityLabel setTextAlignment:NSTextAlignmentLeft];
        [yourMunicipalityLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:32.0f]];
        [yourMunicipalityLabel setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        [yourMunicipalityLabel setText:@"Din kommune"];
        
        UIView *yourMunicipalityLineView = [[UIView alloc]initWithFrame:CGRectMake(yourMunicipalityLabel.frame.origin.x, yourMunicipalityLabel.frame.origin.y + 65.0f, 200.0f, 1.0f)];
        [yourMunicipalityLineView setBackgroundColor:[UIColor colorWithRed:83.0/255.0 green:172.0/255.0 blue:184.0/255.0 alpha:1.0]];
        
        _yourMunicipalTextField = [[KommuneTextField alloc]initWithFrame:CGRectMake(yourMunicipalityLabel.frame.origin.x, yourMunicipalityLabel.frame.origin.y + yourMunicipalityLabel.frame.size.height - 10.0f, _yourNameTextField.frame.size.width, _yourNameTextField.frame.size.height)];
        _yourMunicipalTextField.layer.borderColor=[[UIColor blackColor]CGColor];
        _yourMunicipalTextField.layer.borderWidth = 1.0f;
        _yourMunicipalTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _yourMunicipalTextField.leftView = paddingView2;
        _yourMunicipalTextField.leftViewMode = UITextFieldViewModeAlways;
        [_yourMunicipalTextField setFont:_yourNameTextField.font];
        
        chooseLanguageFormLabel = [[UILabel alloc]initWithFrame:CGRectMake(yourMunicipalityLabel.frame.origin.x, _yourMunicipalTextField.frame.origin.y + 75.0f, yourMunicipalityLabel.frame.size.width, yourMunicipalityLabel.frame.size.height)];
        [chooseLanguageFormLabel setBackgroundColor:[UIColor clearColor]];
        [chooseLanguageFormLabel setTextAlignment:NSTextAlignmentLeft];
        [chooseLanguageFormLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:32.0f]];
        [chooseLanguageFormLabel setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        [chooseLanguageFormLabel setText:@"Velg målform"];
        
        chooseLanguageFormLabelLineView = [[UIView alloc]initWithFrame:CGRectMake(chooseLanguageFormLabel.frame.origin.x, chooseLanguageFormLabel.frame.origin.y + 65.0f, 120.0f, 1.0f)];
        [chooseLanguageFormLabelLineView setBackgroundColor:[UIColor colorWithRed:83.0/255.0 green:172.0/255.0 blue:184.0/255.0 alpha:1.0]];
        
        _bokmalRadioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bokmalRadioButton setFrame:CGRectMake(chooseLanguageFormLabel.frame.origin.x + 5.0f, chooseLanguageFormLabel.frame.origin.y + chooseLanguageFormLabel.frame.size.height, 21.0f, 23.0f)];
        [_bokmalRadioButton setImage:[UIImage imageNamed:@"radioButtonSelected"] forState:UIControlStateNormal];
        
        _bokmalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bokmalButton setFrame:CGRectMake(_bokmalRadioButton.frame.origin.x + 20.0f, _bokmalRadioButton.frame.origin.y - 10.0f, 100.0f, 44.0f)];
        [[_bokmalButton titleLabel]setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0f]];
        [_bokmalButton setTitle:@"Bokmål" forState:UIControlStateNormal];
        [_bokmalButton setTitleColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        _nynorskRadioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nynorskRadioButton setFrame:CGRectMake(_bokmalButton.frame.origin.x + _bokmalButton.frame.size.width + 25.0f, _bokmalRadioButton.frame.origin.y, _bokmalRadioButton.frame.size.width, _bokmalRadioButton.frame.size.height)];
        [_nynorskRadioButton setImage:[UIImage imageNamed:@"radioButtonUnselected"] forState:UIControlStateNormal];
        
        _nynorskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nynorskButton setFrame:CGRectMake(_nynorskRadioButton.frame.origin.x + 20.0f, _nynorskRadioButton.frame.origin.y - 10.0f, 100.0f, 44.0f)];
        [[_nynorskButton titleLabel]setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0f]];
        [_nynorskButton setTitle:@"Nynorsk" forState:UIControlStateNormal];
        [_nynorskButton setTitleColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueButton setFrame:CGRectMake(_nynorskButton.frame.origin.x + _nynorskButton.frame.size.width + 70.0f, _nynorskButton.frame.origin.y + _nynorskButton.frame.size.height + 140.0f, 131.0f, 48.0f)];
        [_continueButton setImage:[UIImage imageNamed:@"continueButton"] forState:UIControlStateNormal];
        
        [self addSubview:backgroundImageView];
        [self addSubview:logoImageView];
        
        [backgroundImageView addSubview:_startingView];
        [_startingView addSubview:beforeYouStartLabel];
        [_startingView addSubview:yourNameLabel];
        [_startingView addSubview:yourNameLabelLineView];
        [_startingView addSubview:_yourNameTextField];
        [_startingView addSubview:yourMunicipalityLabel];
        [_startingView addSubview:yourMunicipalityLineView];
        [_startingView addSubview:_yourMunicipalTextField];
        [_startingView addSubview:chooseLanguageFormLabel];
        [_startingView addSubview:chooseLanguageFormLabelLineView];
        [_startingView addSubview:_bokmalRadioButton];
        [_startingView addSubview:_bokmalButton];
        [_startingView addSubview:_nynorskRadioButton];
        [_startingView addSubview:_nynorskButton];
        [_startingView addSubview:_continueButton];
  
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_yourMunicipalTextField touchesBegan];
}

@end
