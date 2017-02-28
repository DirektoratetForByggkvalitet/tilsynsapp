//
//  DiBKStartView.h
//  DiBK
//
//  Created by Magnus Hasfjord on 19.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KommuneTextField;

@interface StartView : UIView
{
    UIImageView *backgroundImageView;
    UIImageView *logoImageView;
}

@property(nonatomic,strong)UILabel *beforeYouStartLabel, *yourNameLabel, *yourMunicipalityLabel,
                            *chooseLanguageFormLabel, *chooseLanguageFormLabelLineView;
@property(strong, nonatomic)UIView *startingView;
@property(strong, nonatomic)UITextField *yourNameTextField;
@property(strong, nonatomic)KommuneTextField *yourMunicipalTextField;
@property(strong, nonatomic)UIButton *bokmalRadioButton;
@property(strong, nonatomic)UIButton *bokmalButton;
@property(strong, nonatomic)UIButton *nynorskRadioButton;
@property(strong, nonatomic)UIButton *nynorskButton;
@property(strong, nonatomic)UIButton *continueButton;

@end
