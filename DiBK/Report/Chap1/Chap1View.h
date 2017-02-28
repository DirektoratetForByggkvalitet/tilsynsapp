//
//  DiBKRapportPartView.h
//  DiBK
//
//  Created by Grafiker2 on 05.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chap1ScrollView;

@interface Chap1View : UIView
{
    UILabel *_caseNumberLabel;
    UILabel *_aboutRapport;
    UILabel* _scoreLabel;
}

@property(strong,nonatomic)UIButton *rightNav;
@property(strong, nonatomic)UIView *navBarView;
@property(strong, nonatomic)UIButton *backButton;
@property(strong, nonatomic)UIButton *frontPageButton;
@property(strong, nonatomic)UILabel *rapportTitleLabel;
@property(strong, nonatomic)UILabel *rapportPartLabel;
@property(strong, nonatomic)UILabel *municipalityLabel;
@property(strong, nonatomic)Chap1ScrollView *scrollView;

- (void)pageChanged:(int)page withTotal:(int)total;

@end
