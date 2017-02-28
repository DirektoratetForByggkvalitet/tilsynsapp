//
//  DiBKDashboardView.m
//  DiBK
//
//  Created by Magnus Hasfjord on 21.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DashboardView.h"
#import "PdfOverlay.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation DashboardView
@synthesize makeNewRapportButton = _makeNewRapportButton;
@synthesize recentRapportsButton = _recentRapportsButton;
@synthesize completedRapportsButton = _completedRapportsButton;
@synthesize completedInfoButton = _completedInfoButton;
@synthesize searchButton = _searchButton;
@synthesize settingsButton = _settingsButton;
@synthesize archiveButton, pdfOverlay, reportLabel, legalLabel, pdfDownloadInfoLabel;

- (void)updateLabels
{
    BOOL isDark = [ColorSchemeManager getCurrentColorScheme] == kColorSchemeDark;
    UIColor *titleColor = isDark ? [UIColor whiteColor] : [ColorSchemeManager getDarkBlueColor];
    
    [reportLabel setTextColor:titleColor];
    reportLabel.text = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_1"];
    
    [legalLabel setTextColor:titleColor];
    legalLabel.text = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_2"];
    
    [_backgroundImage setImage:[UIImage imageNamed:isDark?@"dashboardBackgroundBlue":@"dashboardBackgroundWhite"]];
    
    [_makeNewRapportButton setImage:[UIImage imageNamed:isDark?@"newRapportButton":@"newRapportButtonWhite"] forState:UIControlStateNormal];
    NSString *newReportTitle = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_3"];
    [_makeNewRapportButton setTitle:newReportTitle forState:UIControlStateNormal];
    [_makeNewRapportButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self positionTextInButton:_makeNewRapportButton withY:70 andPushLeft:0];
    
    [_recentRapportsButton setImage:[UIImage imageNamed:isDark?@"recentRapports":@"recentRapportsWhite"] forState:UIControlStateNormal];
    NSString *recentReportsTitle = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_4"];
    [_recentRapportsButton setTitle:recentReportsTitle forState:UIControlStateNormal];
    [_recentRapportsButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self positionTextInButton:_recentRapportsButton withY:70 andPushLeft:0];
    
    [archiveButton setImage:[UIImage imageNamed:isDark?@"archive":@"archiveWhite"] forState:UIControlStateNormal];
    NSString *archiveTitle = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_5"];
    [archiveButton setTitle:archiveTitle forState:UIControlStateNormal];
    [archiveButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self positionTextInButton:archiveButton withY:10 andPushLeft:100];
    
    [_searchButton setImage:[UIImage imageNamed:isDark?@"searchButton":@"searchButtonWhite"] forState:UIControlStateNormal];
    [_settingsButton setImage:[UIImage imageNamed:isDark?@"settingsButton":@"settingsButtonWhite"] forState:UIControlStateNormal];
    
    [pdfDownloadInfoLabel setTextColor:titleColor];
    [pdfDownloadInfoLabel setUserInteractionEnabled:NO];
    
    pdfDownloadInfoLabel.text = [LabelManager getTextForParent:@"start_screen" Key:@"message"];
}

// http://stackoverflow.com/questions/2451223/uibutton-how-to-center-an-image-and-a-text-using-imageedgeinsets-and-titleedgei
-(void)positionTextInButton:(UIButton*)button withY:(CGFloat)y andPushLeft:(CGFloat)pushLeft
{
    // get the size of the elements here for readability
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    // lower the text and push it left to center it
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width-pushLeft, -y, 0.0);
    titleSize = button.titleLabel.frame.size;
    // raise the image and push it right to center it
    //button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 0), 0.0, 0.0, - titleSize.width);
    //
    UILabel *titleLabel = button.titleLabel;
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"SwitchColorScheme" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"SwitchLanguage" object:nil];
        
        _backgroundImage = [[UIImageView alloc]initWithFrame:frame];
        [_backgroundImage setImage:[UIImage imageNamed:@"dashboardBackground"]];
        [_backgroundImage setUserInteractionEnabled:YES];
        
        reportLabel = [[UILabel alloc]initWithFrame:CGRectMake(42.0f, 20.0f, round(frame.size.width / 2) + 25.0f, 100.0f)];
        [reportLabel setBackgroundColor:[UIColor clearColor]];
        [reportLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:45.0f]];
        [reportLabel setText:@"Tilsyn"];
        [reportLabel setTextColor:[UIColor whiteColor]];
        
        legalLabel = [[UILabel alloc]initWithFrame:CGRectMake(42.0f, reportLabel.frame.origin.y + reportLabel.frame.size.height - 55.0f, reportLabel.frame.size.width, 100.0f)];
        [legalLabel setBackgroundColor:[UIColor clearColor]];
        [legalLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:19.0f]];
        [legalLabel setText:@"Etter tilsyn gjennomført iht. pbl § 25-1"];
        [legalLabel setTextColor:[UIColor whiteColor]];
        
        _makeNewRapportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_makeNewRapportButton setFrame:CGRectMake(130, 146, 154.0f, 101.0f)];
        [_makeNewRapportButton setImage:[UIImage imageNamed:@"newRapportButton"] forState:UIControlStateNormal];
        [_makeNewRapportButton setTitle:@"Nytt tilsyn" forState:UIControlStateNormal];
        [_makeNewRapportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _recentRapportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recentRapportsButton setFrame:CGRectMake(round(frame.size.width / 4) - 150.0f, _makeNewRapportButton.frame.origin.y + _makeNewRapportButton.frame.size.height + 37.0f, 291.0f, 181.0f)];
        [_recentRapportsButton setImage:[UIImage imageNamed:@"recentRapports"] forState:UIControlStateNormal];
        
        archiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [archiveButton setFrame:CGRectMake(_recentRapportsButton.frame.origin.x, _recentRapportsButton.frame.origin.y+_recentRapportsButton.frame.size.height+35, 289, 116)];
        [archiveButton setImage:[UIImage imageNamed:@"archive"] forState:UIControlStateNormal];
        
        pdfDownloadInfoLabel = [[UITextView alloc]initWithFrame:CGRectMake(archiveButton.frame.origin.x, archiveButton.frame.origin.y+archiveButton.frame.size.height + 35, 289, 250)];
        [pdfDownloadInfoLabel setBackgroundColor:[UIColor clearColor]];
        [pdfDownloadInfoLabel setUserInteractionEnabled:NO];
        [pdfDownloadInfoLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:19.0f]];
        [pdfDownloadInfoLabel setText:@"Lorem ipsum dolor sit amet, utinam phaedrum voluptaria has in, suas dissentiunt no sed. Per in tale expetendis, te per nullam concludaturque. Eu veri dolore sed. Eam ex error efficiendi, in mel altera apeirian, eu minim lucilius his."];
        [pdfDownloadInfoLabel setTextColor:[UIColor whiteColor]];
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setFrame:CGRectMake(20.0f, frame.size.height - 160.0f, 45.0f, 46.0f)];
        [_searchButton setImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        
        _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingsButton setFrame:CGRectMake(_searchButton.frame.origin.x, _searchButton.frame.origin.y + _searchButton.frame.size.height + 20.0f, 47.0f, 47.0f)];
        [_settingsButton setImage:[UIImage imageNamed:@"settingsButton"] forState:UIControlStateNormal];
        
        pdfOverlay = [[PdfOverlay alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        pdfOverlay.hidden = YES;
        
        [self addSubview:_backgroundImage];
        [self addSubview:reportLabel];
        [self addSubview:legalLabel];
        [self addSubview:_makeNewRapportButton];
        [self addSubview:_recentRapportsButton];
        [self addSubview:_completedRapportsButton];
        [self addSubview:archiveButton];
        [self addSubview:_completedInfoButton];
        [self addSubview:_settingsButton];
        [self addSubview:pdfOverlay];
        [self addSubview:pdfDownloadInfoLabel];
        
        
        [self updateLabels];
    }
    return self;
}

@end