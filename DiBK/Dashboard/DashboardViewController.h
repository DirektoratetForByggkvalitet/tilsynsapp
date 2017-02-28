//
//  DiBKDashboardViewController.h
//  DiBK
//
//  Created by Magnus Hasfjord on 21.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardView.h"
#import "UserInfo.h"
#import "DiBKRapportsViewController.h"
#import "ReportHomeViewController.h"
#import "AppData.h"
#import <DropboxSDK/DropboxSDK.h>

@class AppSettingsDialog, ArchiveListViewController, InfoView;

@interface DashboardViewController : UIViewController<DiBKRapportsDelegateProtocol, NewRapportControllerDelegateProtocol, ReportGeneratedProtocol, DBRestClientDelegate, UIDocumentInteractionControllerDelegate>
{
    DiBKRapportsViewController *_rapportsViewController;
    ReportHomeViewController *_makeNewRapportViewController;
    AppSettingsDialog *appSettingsDialog;
    ArchiveListViewController *archiveListViewController;
    InfoView *infoView;
    BOOL makingReport;
    BOOL _tableViewIsShowing;
    NSString *pdfPath;
}

@property(strong, nonatomic)DashboardView *dashboardView;
@property(strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic)UserInfo *user;
@property (nonatomic, strong) DBRestClient *restClient;
@property(strong, nonatomic)UIPopoverController *popoverController;
@property (nonatomic, strong) UIDocumentInteractionController *controller;

- (void)fetchUser;
- (void)makeNewRapportButtonPressed:(UIButton *)sender;
- (void)recentRapportsButtonPressed:(UIButton *)sender;
- (void)recentInfoButtonPressed:(UIButton *)sender;
- (void)completedInfoButtonPressed:(UIButton *)sender;
- (void)searchButtonPressed:(UIButton *)sender;
- (void)settingsButtonPressed:(UIButton *)sender;
- (void)existingReportSelectedInTable:(Rapport*)report;
- (void)downloadWebdata;

@end
