//
//  DiBKDashboardViewController.m
//  DiBK
//
//  Created by Magnus Hasfjord on 21.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DashboardViewController.h"
#import "Rapport.h"
#import "Chapter1Info.h"
#import "AppData.h"
#import "ByteLoadingView.h"
#import "PdfOverlay.h"
#import "AppSettingsDialog.h"
#import "ArchiveListViewController.h"
#import "Info.h"
#import "InfoView.h"
#import "WebServiceManager.h"
#import "DropboxActivity.h"
#import "LabelManager.h"

@implementation DashboardViewController
@synthesize dashboardView = _dashboardView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize user = _user;
@synthesize popoverController;

- (void)loadView
{
    //Removing the TEK & SAK pdfs from Library. Runs once.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ( ![userDefaults valueForKey:@"version 1.2.0"] )
    {
        NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fullPath = [NSString stringWithFormat:@"%@/Caches/Documents/Regelverk", libPath];
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:fullPath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
            if (!success) {
                NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version 1.2.0"];
    }

    _dashboardView = [[DashboardView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_dashboardView.makeNewRapportButton addTarget:self action:@selector(makeNewRapportButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dashboardView.recentRapportsButton addTarget:self action:@selector(recentRapportsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dashboardView.completedRapportsButton addTarget:self action:@selector(completedRapportsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dashboardView.archiveButton addTarget:self action:@selector(archiveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dashboardView.settingsButton addTarget:self action:@selector(settingsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableViewIsShowing = NO;
    
    self.view = _dashboardView;
    
    appSettingsDialog = [[AppSettingsDialog alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [self.view addSubview:appSettingsDialog];
    
    archiveListViewController = [[ArchiveListViewController alloc] init];
    [self addChildViewController:archiveListViewController];
    [archiveListViewController didMoveToParentViewController:self];
    [self.view addSubview:archiveListViewController.view];
    
    infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [self.view addSubview:infoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPDF:) name:@"OpenPDF" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo:) name:@"Info" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openShareFileScreen) name:@"OpenShareFileScreen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFileScreen) name:@"OpenFileScreen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDropbox) name:@"LoginDropBox" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadToDropbox) name:@"UploadToDropbox" object:nil];
}

-(void) loginDropbox
{
    if (![[DBSession sharedSession] isLinked] ) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self uploadToDropbox];
    }
}

-(void) uploadToDropbox
{
    [[ByteLoadingView defaultLoadingView]setLoadingText:@"Laster opp fil..."];
    [[ByteLoadingView defaultLoadingView]showInView:self.view];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    // Upload file to Dropbox
    NSString *filename = [pdfPath lastPathComponent];
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:pdfPath];
    
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void) openShareFileScreen
{
    NSURL *pdfFile = [NSURL fileURLWithPath:pdfPath];
    NSArray *objectToShare = @[pdfFile, @"Tilsynsrapport er vedlagt"];

    NSArray *activities = @[[[DropboxActivity alloc] init]];

    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:activities];
    avc.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter];

    NSString *theFileName = [[pdfPath lastPathComponent] stringByDeletingPathExtension];
    [avc setValue: [NSString stringWithFormat:@"DiBK Rapport: %@", theFileName] forKey:@"subject"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    //UIActivityController has to be shown in a popover on iPad
    popoverController = [[UIPopoverController alloc] initWithContentViewController:avc];
    popoverController.popoverContentSize = CGSizeMake(screenWidth, screenWidth / 3);

    if (popoverController.popoverVisible == NO) {
        [popoverController presentPopoverFromRect:CGRectMake(488, 944, 100, 40) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        [popoverController dismissPopoverAnimated:YES];
    }
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {

}

-(void) openFileScreen
{
    NSURL *pdfFile = [NSURL fileURLWithPath:pdfPath];
    
    if (pdfFile)
    {
        self.controller = [UIDocumentInteractionController interactionControllerWithURL:pdfFile];
        self.controller.delegate = self;
     
        self.controller.delegate = self;
        [self.controller presentOpenInMenuFromRect:CGRectMake(100, 944, 100, 40) inView:self.view animated:YES];
    }
}

- (void)showInfo:(NSNotification*)note
{
    Info *info = (Info*)note.object;
    [infoView doShowWithInfo:info];
}

-(void)openPDF:(NSNotification*)note
{
    NSString *path = (NSString*)note.object;
    [_dashboardView.pdfOverlay showWithPath:path];

    pdfPath = path;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
    [[ByteLoadingView defaultLoadingView]setLoadingText:@"Laster inn..."];
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
    [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
    [[ByteLoadingView defaultLoadingView]setLoadingText:@"Laster inn..."];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LabelManager getTextForParent:@"general" Key:@"dropbox_error_title"]
                                                    message:[LabelManager getTextForParent:@"general" Key:@"dropbox_error"]
                                                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

    //In case user unlinks account from www.dropbox.com
    if (error.code == 401) {
        [[DBSession sharedSession] linkFromController:self];
    }
}

-(void)downloadWebdata
{
    WebServiceManager *man = [WebServiceManager getInstance];
    [[ByteLoadingView defaultLoadingView]showInView:self.view];
    [man updateWithCallback:^(BOOL success){
        [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
        [self fetchUser];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserInfo"];
    
    NSError *error;
    NSArray *fetchedUsers = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if ([fetchedUsers count] > 0) {
        _user = [fetchedUsers objectAtIndex:0];
    }
}

#pragma mark - Button action methods

- (void)existingReportSelectedInTable:(Rapport*)report
{
    if (_tableViewIsShowing) {
        [[AppData getInstance] setCurrentReport:report];
        [self reportHomeScreenStart];
    }
}

- (void)reportHomeScreenStart
{
    if (_makeNewRapportViewController == nil) {
        _makeNewRapportViewController = [[ReportHomeViewController alloc]init];
        [_makeNewRapportViewController setManagedObjectContext:_managedObjectContext];
        [_makeNewRapportViewController setRapportDelegate:self];
        [_makeNewRapportViewController setUser:_user];
        [self.view addSubview:_makeNewRapportViewController.view];
        _makeNewRapportViewController.view.center = CGPointMake(_makeNewRapportViewController.view.center.x + self.view.frame.size.width, _makeNewRapportViewController.view.center.y);
    }
    
    [self addChildViewController:_makeNewRapportViewController];
    [_makeNewRapportViewController didMoveToParentViewController:self];
    [_makeNewRapportViewController prepare];
    [self.view bringSubviewToFront:_makeNewRapportViewController.view];
    
    [UIView animateWithDuration:0.5f animations:^{
        _makeNewRapportViewController.view.center = CGPointMake((_makeNewRapportViewController.view.center.x - self.view.frame.size.width), _makeNewRapportViewController.view.center.y);
    } completion:^(BOOL finished) {
        _tableViewIsShowing = NO;
        _rapportsViewController.view.center = CGPointMake(_rapportsViewController.view.center.x + self.view.frame.size.width, _rapportsViewController.view.center.y);
        [_rapportsViewController removeFromParentViewController];
        _rapportsViewController = nil;
    }];
}

- (void)makeNewRapportButtonPressed:(UIButton *)sender
{
    if (makingReport) {
        return;
    }
    
    makingReport = YES;
    [[ByteLoadingView defaultLoadingView]showInView:self.view];
    [[AppData getInstance] genReportWithDelegate:self];
}

- (void)reportNotGenerated
{
    makingReport = NO;
    [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
    NSLog(@"Report not generated (no internet connection?) and no cache stored locally to use...");
}

- (void)reportGenerated
{
    [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
    
    if (_makeNewRapportViewController == nil) {
        _makeNewRapportViewController = [[ReportHomeViewController alloc]init];
        [_makeNewRapportViewController setManagedObjectContext:_managedObjectContext];
        [_makeNewRapportViewController setRapportDelegate:self];
        [_makeNewRapportViewController setUser:_user];
        [self.view addSubview:_makeNewRapportViewController.view];
        _makeNewRapportViewController.view.center = CGPointMake(_makeNewRapportViewController.view.center.x + self.view.frame.size.width, _makeNewRapportViewController.view.center.y);
    }
    
    [self addChildViewController:_makeNewRapportViewController];
    [_makeNewRapportViewController didMoveToParentViewController:self];
    [_makeNewRapportViewController prepare];
    [UIView animateWithDuration:0.5f animations:^{
        _makeNewRapportViewController.view.center = CGPointMake((_makeNewRapportViewController.view.center.x - self.view.frame.size.width), _makeNewRapportViewController.view.center.y);
    }completion:^(BOOL finished) {
        makingReport = NO;
    }];
}

- (void)recentRapportsButtonPressed:(UIButton *)sender
{
    [self slideInTableView];
}

- (void)completedRapportsButtonPressed:(UIButton *)sender
{
    [self slideInTableView];
}

- (void)archiveButtonPressed:(UIButton*)sender
{
    [archiveListViewController slideIn];
}

-(UserInfo*)getUser
{
    return [[AppData getInstance] fetchUserInfo];
}

- (void)slideInTableView
{
    if (!_tableViewIsShowing) {
        _tableViewIsShowing = YES;
        _rapportsViewController = [[DiBKRapportsViewController alloc]init];
        [_rapportsViewController setRapportDelegate:self];
        [self addChildViewController:_rapportsViewController];
        [_rapportsViewController didMoveToParentViewController:self];
        [self.view addSubview:_rapportsViewController.view];
        NSLog(@"nsubview: %d", self.view.subviews.count);
        [_rapportsViewController setUser:[self getUser]];
        
        // reset the center of it's view firstly
        [_rapportsViewController.view setCenter:CGPointMake(_rapportsViewController.view.frame.size.width / 2, _rapportsViewController.view.center.y)];
        _rapportsViewController.view.center = CGPointMake(_rapportsViewController.view.center.x + _rapportsViewController.rapportsView.rapportListView.frame.size.width, _rapportsViewController.view.center.y);
        [UIView animateWithDuration:0.5f animations:^{
            _rapportsViewController.view.center = CGPointMake(_rapportsViewController.view.center.x - _rapportsViewController.rapportsView.rapportListView.frame.size.width, _rapportsViewController.view.center.y);
        } completion:^(BOOL finished) {
            _tableViewIsShowing = YES;
        }];
    }
}

- (void)recentInfoButtonPressed:(UIButton *)sender
{
    [Info showInfoScreenForkey:@"incompleteReports"];
}

- (void)archiveInfoButtonPressed:(UIButton *)sender
{
    [Info showInfoScreenForkey:@"archive"];
}

- (void)completedInfoButtonPressed:(UIButton *)sender
{
    
}

- (void)searchButtonPressed:(UIButton *)sender
{
    
}

- (void)settingsButtonPressed:(UIButton *)sender
{
    [appSettingsDialog doShow];
}

#pragma mark - RapportController Delegate

- (void)animateControllerBack
{
    if (_tableViewIsShowing) {
        
        [UIView animateWithDuration:0.5f animations:^{
            
            _rapportsViewController.view.center = CGPointMake(_rapportsViewController.view.center.x + _rapportsViewController.rapportsView.rapportListView.frame.size.width, _rapportsViewController.view.center.y);
            
        } completion:^(BOOL finished) {
            
            [_rapportsViewController removeFromParentViewController];
            [_rapportsViewController.view removeFromSuperview];
            _rapportsViewController = nil;
            
            _tableViewIsShowing = NO;
        }];
        
    }
}

#pragma mark - NewRapportController Delegate

- (void)animateNewRapportControllerBack
{
    [UIView animateWithDuration:0.5f animations:^{
        
        _makeNewRapportViewController.view.center = CGPointMake((_makeNewRapportViewController.view.center.x + self.view.frame.size.width), _makeNewRapportViewController.view.center.y);
        
    }completion:^(BOOL finished) {
        
        
        [_makeNewRapportViewController removeFromParentViewController];
    }];
}

@end