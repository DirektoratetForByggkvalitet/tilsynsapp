//
//  DiBKRapportPartViewController.m
//  DiBK
//
//  Created by Grafiker2 on 05.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "Chap1ViewController.h"
#import "AppData.h"
#import "Chap1ScrollView.h"
#import "InfoPageViewController.h"
#import "DetailPageViewController.h"
#import "Rapport.h"
#import "Chapter1Info.h"
#import "Manager.h"
#import "TopView.h"
#import "ColorSchemeManager.h"
#import "KommuneTextField.h"
#import "Municipality.h"

@implementation Chap1ViewController
@synthesize rapportPartView = _chap1InfoView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize user = _user;
@synthesize detailPageViewController, infoPageViewController;

static BOOL isVisible = false;

+ (void)setVisibility:(BOOL)visibility
{
    isVisible = visibility;
}

+ (BOOL)isVisible
{
    return isVisible;
}

- (void)loadView
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasHidden:) name: UIKeyboardWillHideNotification object:nil];
    _chap1InfoView = [[Chap1View alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_chap1InfoView.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    infoPageViewController = _chap1InfoView.scrollView.infoPageViewController;
    detailPageViewController = _chap1InfoView.scrollView.detailPageViewController;
    [_chap1InfoView.rightNav addTarget:self action:@selector(rightNavClicked) forControlEvents:UIControlEventTouchUpInside];
    self.view = _chap1InfoView;
    
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"ChapterOne_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"SaveTimerTriggerChap1" object:nil];
}

- (void) startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                target: self
                                                selector:@selector(doSave)
                                                userInfo: nil repeats:YES];
}

- (void) stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)rightNavClicked
{
    NSLog(@"Chapter 1 nav clicked");
    CGPoint offset = _chap1InfoView.scrollView.contentOffset;
    if (offset.x <= 0) {
        offset.x = 768;
        [_chap1InfoView.scrollView setContentOffset:offset animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChapterOne_RightNavClicked" object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self loadData];
    //[_chap1InfoView.municipalityLabel setText:[[AppData getInstance] getTitle]];
}

- (void)slideIntoView
{
    [self loadData];
    [_chap1InfoView.municipalityLabel setText:[[AppData getInstance] getTitle]];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.center = CGPointMake((self.view.center.x - [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
        
    }completion:^(BOOL finished) {
        isVisible = true;
    }];
}

-(void)doSave
{
    [self saveData];
}

- (void)slideOutOfView
{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.center = CGPointMake((self.view.center.x + [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
        
    }completion:^(BOOL finished) {
        [self saveData];
        isVisible = false;
    }];
}

- (void)loadData
{
    AppData* appData = [AppData getInstance];
    Rapport* report = [appData currentReport];
    Chapter1Info* info = report.chapter1Info;
    
    NSString *kommune = info.kommune;
    NSString *kid = info.kommuneID;
    if (kommune == nil || [kommune isEqualToString:@""]) {
        kommune = [[AppData getInstance] userInfo].municipality;
        kid = [appData userInfo].kommuneID;
    }
    
    infoPageViewController.txtRegion.text = kommune;
    [infoPageViewController.txtRegion setSelectKommuneWithId:kid];
    
    NSString *name = report.rapportName;
    if (name == nil || [name isEqualToString:@""]) {
        name = [[AppData getInstance] userInfo].username;
    }
    infoPageViewController.txtTilsynsforer.text = name;
    
    NSString *ksaks = info.kommune_sakanr;
    if (ksaks == nil || [ksaks isEqualToString:@""]) {
        ksaks = @"";
    }
    [[infoPageViewController txtKommune_sakanr] setText:ksaks];
    
    [[infoPageViewController txtRapportenGjelder] setText:[info rapporten_gjelder]];
    
    NSString *stedig = info.stedig_tilsyn_varslet;
    if (stedig == nil || [stedig isEqualToString:@""]) {
        stedig = @"";
    }
    [[infoPageViewController text_stedig_tilsyn_varslet] setText:stedig];
    
    [[infoPageViewController txtBnr] setText:[info bnr]];
    [[infoPageViewController txtGnr] setText:[info gnr]];
    [[infoPageViewController txtSnr] setText:[info snr]];
    [[infoPageViewController txtFnr] setText:[info fnr]];
    [[infoPageViewController txtViewKommentar] setText:[info kommentar]];
    [[infoPageViewController txtViewAnnet] setText:[info annet]];
    
    NSString *date = info.datoFortatt;
    NSString *dateText = date == nil ? @"" : date;
    [[infoPageViewController datoFortatt] setText:dateText];
    
    // check boxes
    BOOL p1cb1 = [[info p1cb1] boolValue];
    [[infoPageViewController btnBtn1] setImage:[ColorSchemeManager getCheckboxImage:p1cb1] forState:UIControlStateNormal];
    [infoPageViewController setBtn1:p1cb1];
    
    BOOL p1cb2 = [[info p1cb2] boolValue];
    [[infoPageViewController btnBtn2] setImage:[ColorSchemeManager getCheckboxImage:p1cb2] forState:normal];
    [infoPageViewController setBtn2:p1cb2];
    
    BOOL p1cb3 = [[info p1cb3] boolValue];
    [[infoPageViewController btnBtn3] setImage:[ColorSchemeManager getCheckboxImage:p1cb3] forState:normal];
    [infoPageViewController setBtn3:p1cb3];
    
    BOOL p1cb4 = [[info p1cb4] boolValue];
    [[infoPageViewController btnBtn4] setImage:[ColorSchemeManager getCheckboxImage:p1cb4] forState:normal];
    [infoPageViewController setBtn4:p1cb4];
    
    BOOL p1cb5 = [[info p1cb5] boolValue];
    [[infoPageViewController btnBtn5] setImage:[ColorSchemeManager getCheckboxImage:p1cb5] forState:normal];
    [infoPageViewController setBtn5:p1cb5];
    
    BOOL p1cb6 = [[info p1cb6] boolValue];
    [[infoPageViewController btnBtn6] setImage:[ColorSchemeManager getCheckboxImage:p1cb6] forState:normal];
    [infoPageViewController setBtn6:p1cb6];
    
    BOOL p1cb7 = [[info p1cb7] boolValue];
    [[infoPageViewController btnBtn7] setImage:[ColorSchemeManager getCheckboxImage:p1cb7] forState:normal];
    [infoPageViewController setBtn7:p1cb7];
    
    // check boxes pages 2
    BOOL checked = [[info p2cb1] boolValue];
    [[detailPageViewController btnBtn1] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn1:checked];
    
    checked = [[info p2cb2] boolValue];
    [[detailPageViewController btnBtn2] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn2:checked];
    
    checked = [[info p2cb3] boolValue];
    [[detailPageViewController btnBtn3] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn3:checked];
    
    checked = [[info p2cb4] boolValue];
    [[detailPageViewController btnBtn4] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn4:checked];
    
    checked = [[info p2cb5] boolValue];
    [[detailPageViewController btnBtn5] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn5:checked];
    
    checked = [[info p2cb6] boolValue];
    [[detailPageViewController btnBtn6] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn6:checked];
    
    checked = [[info p2cb7] boolValue];
    [[detailPageViewController btnBtn7] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn7:checked];
    
    checked = [[info p2cb8] boolValue];
    [[detailPageViewController btnBtn8] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn8:checked];
    
    checked = [[info p2cb9] boolValue];
    [[detailPageViewController btnBtn9] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn9:checked];
    
    checked = [[info p2cb10] boolValue];
    [[detailPageViewController btnBtn10] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn10:checked];
    
    checked = [[info p2cb11] boolValue];
    [[detailPageViewController btnBtn11] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn11:checked];
    
    checked = [[info p2cb12] boolValue];
    [[detailPageViewController btnBtnTitaketEr] setImage:[ColorSchemeManager getCheckboxImage:checked] forState:normal];
    [detailPageViewController setBtn12:checked];
    
    [[detailPageViewController textViewAndreKommentarer] setText:[info andreKommentarer]];
    [[detailPageViewController txtTitaketEr] setText:[info titakenEr]];
    
    NSArray *set = [info.managers allObjects];
    for(Manager* manager in set) {
        NSString* a = [manager a];
        NSString* b = [manager b];
        NSString* c = [manager c];
        [detailPageViewController addManagerWithA:a b:b c:c title:manager.title];
    }
}

- (void)saveData
{
    
    NSLog(@"---Save data Chap 1 is being called---");
    AppData* appData = [AppData getInstance];
    Rapport* report = [appData currentReport];
    Chapter1Info* info = report.chapter1Info;
    
    // save managers
    NSMutableArray *topViewArr = [detailPageViewController topViewArr];
    
    [info removeManagers:info.managers];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (TopView* topView in topViewArr) {
        NSString *txt1 = topView.txt1.text;
        NSString *txt2 = topView.txt2.text;
        NSString *txt3 = topView.txt3.text;
        NSManagedObjectContext *context = [[AppData getInstance] managedObjectContext];
        Manager *man = (Manager*)[NSEntityDescription insertNewObjectForEntityForName:@"Manager" inManagedObjectContext:context];
        man.a = txt1;
        man.b = txt2;
        man.c = txt3;
        man.title = topView.title.text;
        [set addObject:man];
    }
    
    [info setManagers:set];
    
    report.rapportName = [[infoPageViewController txtTilsynsforer] text];
    
    report.chapter1Info.kommune_sakanr = [[infoPageViewController txtKommune_sakanr] text];
    info.kommune = infoPageViewController.txtRegion.text;
    Municipality *m = infoPageViewController.txtRegion.selectedKommune;
    if (m) {
        Municipality *m = infoPageViewController.txtRegion.selectedKommune;
        NSString *kommunID = m ? [m getIdStr] : @"";
        info.kommuneID = kommunID;
    }
    [info setRapporten_gjelder:[[infoPageViewController txtRapportenGjelder] text]];
    [info setStedig_tilsyn_varslet:[[infoPageViewController text_stedig_tilsyn_varslet] text]];
    [info setBnr:[[infoPageViewController txtBnr] text]];
    [info setGnr:[[infoPageViewController txtGnr] text]];
    [info setSnr:[[infoPageViewController txtSnr] text]];
    [info setFnr:[[infoPageViewController txtFnr] text]];
    [info setKommentar:[[infoPageViewController txtViewKommentar] text]];
    [info setAnnet:[[infoPageViewController txtViewAnnet] text]];
    
    NSString *dateText = [infoPageViewController datoFortatt].text;
    [info setDatoFortatt:dateText];
    
    // check boxes
    info.p1cb1 =[NSNumber numberWithBool:[infoPageViewController btn1]];
    info.p1cb2 =[NSNumber numberWithBool:[infoPageViewController btn2]];
    info.p1cb3 =[NSNumber numberWithBool:[infoPageViewController btn3]];
    info.p1cb4 =[NSNumber numberWithBool:[infoPageViewController btn4]];
    info.p1cb5 =[NSNumber numberWithBool:[infoPageViewController btn5]];
    info.p1cb6 =[NSNumber numberWithBool:[infoPageViewController btn6]];
    info.p1cb7 =[NSNumber numberWithBool:[infoPageViewController btn7]];
    
    // check boxes poage 2
    info.p2cb1 =[NSNumber numberWithBool:[detailPageViewController btn1]];
    info.p2cb2 =[NSNumber numberWithBool:[detailPageViewController btn2]];
    info.p2cb3 =[NSNumber numberWithBool:[detailPageViewController btn3]];
    info.p2cb4 =[NSNumber numberWithBool:[detailPageViewController btn4]];
    info.p2cb5 =[NSNumber numberWithBool:[detailPageViewController btn5]];
    info.p2cb6 =[NSNumber numberWithBool:[detailPageViewController btn6]];
    info.p2cb7 =[NSNumber numberWithBool:[detailPageViewController btn7]];
    info.p2cb8 =[NSNumber numberWithBool:[detailPageViewController btn8]];
    info.p2cb9 =[NSNumber numberWithBool:[detailPageViewController btn9]];
    info.p2cb10 =[NSNumber numberWithBool:[detailPageViewController btn10]];
    info.p2cb11 =[NSNumber numberWithBool:[detailPageViewController btn11]];
    info.p2cb12 =[NSNumber numberWithBool:[detailPageViewController btn12]];
    
    info.andreKommentarer = [[detailPageViewController textViewAndreKommentarer] text];
    info.titakenEr = [[detailPageViewController txtTitaketEr] text];
    
    NSDate* date = [NSDate date];
    if (report.dateCreated == nil) {
        report.dateCreated = date;
    }
    report.dateLastEdited = date;
    [appData save];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [infoPageViewController resignAllResponders];
    [detailPageViewController resignAllResponders];
    [self slideOutOfView];
    [self stopTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    expectedIsChosen = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)expectedRadioButtonTapped:(UIButton *)sender
{
    if (!expectedIsChosen) {
        expectedIsChosen = YES;
    }
}

- (void)unexpectedRadioButtonTapped:(UIButton *)sender
{
    if (expectedIsChosen) {
        expectedIsChosen = NO;
    }
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notification

- (void)keyboardWasHidden:(NSNotification *)notification
{
}


@end
