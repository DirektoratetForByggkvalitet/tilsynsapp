//
//  DiBKDashboardView.h
//  DiBK
//
//  Created by Magnus Hasfjord on 21.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PdfOverlay;

@interface DashboardView : UIView
{
    UIImageView *_backgroundImage;
}

@property(nonatomic,strong)UILabel *reportLabel, *legalLabel;
@property(strong, nonatomic)PdfOverlay *pdfOverlay;
@property(strong, nonatomic)UIButton *archiveButton;
@property(strong, nonatomic)UIButton *makeNewRapportButton;
@property(strong, nonatomic)UIButton *recentRapportsButton;
@property(strong, nonatomic)UIButton *completedRapportsButton;
@property(strong, nonatomic)UIButton *completedInfoButton;
@property(strong, nonatomic)UIButton *searchButton;
@property(strong, nonatomic)UIButton *settingsButton;
@property(strong, nonatomic)UITextView *pdfDownloadInfoLabel;


@end