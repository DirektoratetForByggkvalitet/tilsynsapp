//
//  DiBKNewRapportView.h
//  DiBK
//
//  Created by Grafiker2 on 01.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiBKRapportPartButton.h"

@interface ReportHomeView : UIView
{
    UIImageView *_backgroundImageView;
    UILabel *_descriptionLabel;
}

@property(strong, nonatomic)UIButton *backButton;
@property(strong, nonatomic)DiBKRapportPartButton *rapportPartOneButton;
@property(strong, nonatomic)DiBKRapportPartButton *rapportPartTwoButton;
@property(strong, nonatomic)DiBKRapportPartButton *rapportPartThreeButton;
@property(strong, nonatomic)DiBKRapportPartButton *rapportPartFourButton;
@property(strong, nonatomic)DiBKRapportPartButton *rapportPartFiveButton;
@property(strong, nonatomic)UILabel *makeNewRapportLabel;

@end
