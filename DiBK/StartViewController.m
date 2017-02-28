//
//  DiBKStartViewController.m
//  DiBK
//
//  Created by Magnus Hasfjord on 19.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "StartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DashboardViewController.h"
#import "UserInfo.h"
#import "ByteLoadingView.h"
#import "AppData.h"
#import "WebServiceManager.h"
#import "ByteLoadingView.h"
#import "LabelManager.h"
#import "KommuneTextField.h"
#import "Municipality.h"

@implementation StartViewController
@synthesize startView = _startView;
@synthesize managedObjectContext = _managedObjectContext;

- (void)loadView
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasHidden:) name: UIKeyboardWillHideNotification object:nil];
    _startView = [[StartView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_startView.yourNameTextField setDelegate:self];
    [_startView.bokmalRadioButton addTarget:self action:@selector(bokmalButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_startView.bokmalButton addTarget:self action:@selector(bokmalButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_startView.nynorskRadioButton addTarget:self action:@selector(nynorskButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_startView.nynorskButton addTarget:self action:@selector(nynorskButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_startView.continueButton addTarget:self action:@selector(continueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = _startView;
    _bokmalIsChosen = YES;
    _termsIsAccepted = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:@"SwitchLanguage" object:nil];
}

- (void)languageChanged
{
    [self updateLabels];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self downloadWebdata];
}

-(void)downloadWebdata
{
    WebServiceManager *man = [WebServiceManager getInstance];
    [[ByteLoadingView defaultLoadingView]showInView:self.view];
    [man updateWithCallback:^(BOOL success){
        [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
        [self updateLabels];
        [self animateStartingView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateStartingView
{
    [UIView animateWithDuration:1.0f animations:^{
        _startView.startingView.center = CGPointMake(_startView.startingView.center.x - 668.0f, _startView.startingView.center.y);
    }completion:^(BOOL finished) {
    }];
}

- (void)updateLabels
{
    _startView.beforeYouStartLabel.text = [LabelManager getTextForParent:@"start_screen" Key:@"text_1"];
    _startView.yourNameLabel.text = [LabelManager getTextForParent:@"start_screen" Key:@"text_2"];
    _startView.yourMunicipalityLabel.text = [LabelManager getTextForParent:@"start_screen" Key:@"text_3"];
    _startView.chooseLanguageFormLabel.text = [LabelManager getTextForParent:@"start_screen" Key:@"text_4"];
}

- (void)bokmalButtonsPressed:(UIButton *)sender
{
    if (!_bokmalIsChosen) {
        [_startView.bokmalRadioButton setImage:[UIImage imageNamed:@"radioButtonSelected"] forState:UIControlStateNormal];
        [_startView.nynorskRadioButton setImage:[UIImage imageNamed:@"radioButtonUnselected"] forState:UIControlStateNormal];
        _bokmalIsChosen = YES;
        [LabelManager switchLanguage];
    }
}

- (void)nynorskButtonsPressed:(UIButton *)sender
{
    if (_bokmalIsChosen) {
        [_startView.bokmalRadioButton setImage:[UIImage imageNamed:@"radioButtonUnselected"] forState:UIControlStateNormal];
        [_startView.nynorskRadioButton setImage:[UIImage imageNamed:@"radioButtonSelected"] forState:UIControlStateNormal];
        _bokmalIsChosen = NO;
        [LabelManager switchLanguage];
    }
}

- (void)continueButtonPressed:(UIButton *)sender
{

    if (_startView.yourNameTextField.text.length <= 0){
        
        NSLog(@"Fyll inn navn");
        
    }else if(_startView.yourMunicipalTextField.text.length <= 0){
        
        NSLog(@"Fyll inn kommune");

    }else{
        
        NSLog(@"You're all good!");
        
        UserInfo *user = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:_managedObjectContext];
        [[AppData getInstance] setUserInfo: user];
        user.username = _startView.yourNameTextField.text;
        user.municipality = _startView.yourMunicipalTextField.text;
        Municipality *m = _startView.yourMunicipalTextField.selectedKommune;
        if (m) {
            user.kommuneID = [m getIdStr];
        } else {
            user.kommuneID = @"";
        }
        NSString *str = user.kommuneID;
        user.isBokmal = [NSNumber numberWithBool:_bokmalIsChosen];
        
        NSError *error;
        [_managedObjectContext save:&error];
        
        DashboardViewController *dvc = [[DashboardViewController alloc]init];
        [dvc setManagedObjectContext:_managedObjectContext];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _startView.yourNameTextField) {
        
        _startView.yourNameTextField.layer.borderColor = [[UIColor colorWithRed:83.0/255.0 green:172.0/255.0 blue:184.0/255.0 alpha:1.0]CGColor];
        _startView.yourMunicipalTextField.layer.borderColor = [[UIColor blackColor]CGColor];
        
    }else if(textField == _startView.yourMunicipalTextField){
        _startView.yourMunicipalTextField.layer.borderColor = [[UIColor colorWithRed:83.0/255.0 green:172.0/255.0 blue:184.0/255.0 alpha:1.0]CGColor];
        _startView.yourNameTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    }
    
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
    _startView.yourNameTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    _startView.yourMunicipalTextField.layer.borderColor = [[UIColor blackColor]CGColor];
}

@end
