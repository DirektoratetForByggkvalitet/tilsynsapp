//
//  DiBKNewRapportView.m
//  DiBK
//
//  Created by Grafiker2 on 01.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ReportHomeView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "AppData.h"

@implementation ReportHomeView
@synthesize backButton = _backButton;
@synthesize rapportPartOneButton = _rapportPartOneButton;
@synthesize rapportPartTwoButton = _rapportPartTwoButton;
@synthesize rapportPartThreeButton = _rapportPartThreeButton;
@synthesize rapportPartFourButton = _rapportPartFourButton;
@synthesize rapportPartFiveButton = _rapportPartFiveButton, makeNewRapportLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _backgroundImageView = [[UIImageView alloc]initWithFrame:frame];
        [_backgroundImageView setImage:[ColorSchemeManager reportHomeScreenBg]];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(15.0f, 35.0f, 18.0f, 31.0f)];
        [_backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
        
        makeNewRapportLabel = [[UILabel alloc]initWithFrame:CGRectMake(90.0f, 70.0f, 500.0f, 60.0f)];
        [makeNewRapportLabel setBackgroundColor:[UIColor clearColor]];
        [makeNewRapportLabel setTextColor:[UIColor whiteColor]];
        [makeNewRapportLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0f]];
        [makeNewRapportLabel setText:@"Nytt tilsyn"];
        
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(makeNewRapportLabel.frame.origin.x + 1.0f, (makeNewRapportLabel.frame.origin.y + makeNewRapportLabel.frame.size.height) - 5.0f, 600.0f, 80.0f)];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [_descriptionLabel setTextColor:[UIColor whiteColor]];
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        [_descriptionLabel setText:@"Velg ønsket kapittel for utfylling"];
        _descriptionLabel.numberOfLines=0;
        _descriptionLabel.lineBreakMode=UILineBreakModeWordWrap;
        
        _rapportPartOneButton = [[DiBKRapportPartButton alloc]initWithFrame:CGRectMake(15.0f, 250.0f, 755.0f, 110.0f)];
        [_rapportPartOneButton.numberLabel setTextColor:[UIColor colorWithRed:91.0f/255.0f green:135.0f/255.0f blue:187.0f/255.0f alpha:1.0f]];
        [_rapportPartOneButton.numberLabel setText:@"1"];
        [_rapportPartOneButton.headerLabel setText:@"Informasjon"];
        [_rapportPartOneButton.descriptionLabel setText:@"Informasjon om tiltaket, foretak, deltagere og andre faktiske forhold"];
        
        _rapportPartTwoButton = [[DiBKRapportPartButton alloc]initWithFrame:CGRectMake(_rapportPartOneButton.frame.origin.x, (_rapportPartOneButton.frame.origin.y + _rapportPartOneButton.frame.size.height) + 10.0f, _rapportPartOneButton.frame.size.width, _rapportPartOneButton.frame.size.height)];
        [_rapportPartTwoButton.numberLabel setTextColor:[UIColor colorWithRed:80.0f/255.0f green:165.0f/255.0f blue:176.0f/255.0f alpha:1.0f]];
        [_rapportPartTwoButton.numberLabel setText:@"2"];
        [_rapportPartTwoButton.headerLabel setText:@"Valg av fagområder/sjekklister"];
        [_rapportPartTwoButton.descriptionLabel setText:@"Velg hva tilsynet skal omfatte av fagområder, sjekklister og eventuelt egne spørsmål"];
        
        _rapportPartThreeButton = [[DiBKRapportPartButton alloc]initWithFrame:CGRectMake(_rapportPartTwoButton.frame.origin.x, (_rapportPartTwoButton.frame.origin.y + _rapportPartTwoButton.frame.size.height) + 13.0f, _rapportPartTwoButton.frame.size.width, _rapportPartTwoButton.frame.size.height)];
        [_rapportPartThreeButton.numberLabel setTextColor:[UIColor colorWithRed:201.0f/255.0f green:209.0f/255.0f blue:43.0f/255.0f alpha:1.0f]];
        [_rapportPartThreeButton.numberLabel setText:@"3"];
        [_rapportPartThreeButton.headerLabel setText:@"Gjennomføring"];
        [_rapportPartThreeButton.descriptionLabel setText:@"Utfylling av sjekklister med kommentarer, bilder og annen dokumentasjon av funn"];

   
        _rapportPartFourButton = [[DiBKRapportPartButton alloc]initWithFrame:CGRectMake(_rapportPartThreeButton.frame.origin.x, (_rapportPartThreeButton.frame.origin.y + _rapportPartThreeButton.frame.size.height) + 13.0f, _rapportPartThreeButton.frame.size.width, _rapportPartThreeButton.frame.size.height)];
        [_rapportPartFourButton.numberLabel setTextColor:[UIColor colorWithRed:125.0f/255.0f green:164.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        [_rapportPartFourButton.numberLabel setText:@"4"];
        [_rapportPartFourButton.headerLabel setText:@"Konklusjon"];
        [_rapportPartFourButton.descriptionLabel setText:@"Sjekk informasjon, skriv oppsummering, avslutt og send rapport"];
        
        _rapportPartFiveButton = [[DiBKRapportPartButton alloc]initWithFrame:CGRectMake(_rapportPartFourButton.frame.origin.x, (_rapportPartFourButton.frame.origin.y + _rapportPartFourButton.frame.size.height) + 16.0f, _rapportPartFourButton.frame.size.width, _rapportPartFourButton.frame.size.height)];
        [_rapportPartFiveButton.numberLabel setTextColor:[UIColor colorWithRed:199.0f/255.0f green:121.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
        [_rapportPartFiveButton.numberLabel setText:@"5"];
        [_rapportPartFiveButton.headerLabel setText:@"Ferdigstilling"];
        [_rapportPartFiveButton.descriptionLabel setText:@"Bekreft og ferdigstill tilsynsrapporten"];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        [self addSubview:_backgroundImageView];
        [self addSubview:_backButton];
        [self addSubview:makeNewRapportLabel];
        [self addSubview:_descriptionLabel];
        [self addSubview:_rapportPartOneButton];
        [self addSubview:_rapportPartTwoButton];
        [self addSubview:_rapportPartThreeButton];
        [self addSubview:_rapportPartFourButton];
        [self addSubview:_rapportPartFiveButton];
        
        [self updateColors];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateColors) name:@"SwitchColorScheme" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateColors) name:@"SwitchLanguage" object:nil];
    }
    
    return self;
}

- (void)updateColors
{
    BOOL isDark = [ColorSchemeManager getCurrentColorScheme] == kColorSchemeDark;
    UIColor *titleColor = isDark ? [UIColor whiteColor] : [ColorSchemeManager getDarkBlueColor];
    [makeNewRapportLabel setTextColor:titleColor];
    [_descriptionLabel setTextColor:titleColor];
    [_backgroundImageView setImage:[ColorSchemeManager reportHomeScreenBg]];
    
    _descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_2"];
    _rapportPartOneButton.headerLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_3"];
    _rapportPartOneButton.descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_4"];
    _rapportPartTwoButton.headerLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_5"];
    _rapportPartTwoButton.descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_6"];
    _rapportPartThreeButton.headerLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_7"];
    _rapportPartThreeButton.descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_8"];
    _rapportPartFourButton.headerLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_9"];
    _rapportPartFourButton.descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_10"];
    _rapportPartFiveButton.headerLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_11"];
    _rapportPartFiveButton.descriptionLabel.text = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_12"];
}

@end
