//
//  FerdigViewController.m
//  DiBK
//
//  Created by david stummer on 16/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FerdigViewController.h"
#import "AppData.h"
#import "Chapter1Info.h"
#import "Rapport.h"
#import <QuartzCore/QuartzCore.h>
#import "ByteLoadingView.h"
#import "PDFGenerator.h"
#import "PDFUtils.h"
#import "Photo.h"
#import "ImageUtils.h"
#import "AppUtils.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "KommuneTextField.h"
#import "Municipality.h"
#import "ReportDatePickerView.h"

@implementation FerdigViewController
@synthesize txt1, txt2, txt3, txt4, sendButton, sendPreviewButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadColorScheme];
    [self loadLabels];
}

-(void)loadLabels
{
    [sendButton setTitle:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_11"] forState:UIControlStateNormal];
    [sendPreviewButton setTitle:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"button_temp"] forState:UIControlStateNormal];
    text_3.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_3"];
    text_4.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_4"];
    text_5.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_5"];
    text_6.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_6"];
    text_9.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_9"];
    confirmationHelpText.text = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"confirmation_help"];
    [confirmationHelpText setBackgroundColor:[UIColor clearColor]];
    [confirmationHelpText setUserInteractionEnabled:NO];
    [confirmationHelpText setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    confirmationHelpText.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)loadColorScheme
{
    [ColorSchemeManager updateView:self.view];
    self.view.backgroundColor = [ColorSchemeManager getBgColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupTextFields];
    [self enableAll];
    Chapter1Info *info = [AppData getInstance].currentReport.chapter1Info;
    txt1.text = info.kommune;
    [txt1 setSelectKommuneWithId:info.kommuneID];
    txt2.text = info.kommune_sakanr;
    txt3.text = [AppData getInstance].currentReport.rapportName;
    txt4.text = [AppData getInstance].currentReport.dateCompletedStr;
}

- (IBAction)ferdigClicked:(id)sender
{
    if ([txt2.text isEqualToString:@""] || [txt3.text isEqualToString:@""]) {
        NSString *errStr = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_12"];
        NSString *descStr = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_13"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errStr message:descStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil, nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
        return;
    }
    Chapter1Info *info = [AppData getInstance].currentReport.chapter1Info;
    info.kommune = txt1.text;
    Municipality *m = txt1.selectedKommune;
    if (m) {
        NSString *kommunID = m ? [m getIdStr] : @"";
        info.kommuneID = kommunID;
    }
    
    //Remove (temp) from filename if it's set
    NSRange rangeOfSubstring = [txt2.text rangeOfString:@"(temp)"];
    if(rangeOfSubstring.location == NSNotFound)
    {
        info.kommune_sakanr = txt2.text;
    } else {
        info.kommune_sakanr = [txt2.text substringToIndex:rangeOfSubstring.location];
    }

    [AppData getInstance].currentReport.rapportName = txt3.text;
    [AppData getInstance].currentReport.dateCompletedStr = txt4.text;

    [[AppData getInstance] save];
    [self generatePdf];
}

- (IBAction)sendPreviewClicked:(id)sender
{
    if ([txt2.text isEqualToString:@""] || [txt3.text isEqualToString:@""]) {
        NSString *errStr = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_12"];
        NSString *descStr = [LabelManager getTextForParent:@"chapter_five_screen" Key:@"text_13"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errStr message:descStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil, nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
        return;
    }
    Chapter1Info *info = [AppData getInstance].currentReport.chapter1Info;
    info.kommune = txt1.text;
    Municipality *m = txt1.selectedKommune;
    if (m) {
        NSString *kommunID = m ? [m getIdStr] : @"";
        info.kommuneID = kommunID;
    }
    
    //Remove (temp) from filename if it's set
    NSRange rangeOfSubstring = [txt2.text rangeOfString:@"(temp)"];
    if(rangeOfSubstring.location == NSNotFound)
    {
        info.kommune_sakanr = txt2.text;
    } else {
        info.kommune_sakanr = [txt2.text substringToIndex:rangeOfSubstring.location];
    }
    
    NSString *title = [NSString stringWithFormat:@"(temp)%@", txt2.text];
    info.kommune_sakanr = title;

    [AppData getInstance].currentReport.rapportName = txt3.text;
    [AppData getInstance].currentReport.dateCompletedStr = txt4.text;
    
    [[AppData getInstance] save];
    [self generatePdfForPreview];
}

- (void)generatePdf
{
    pdfGenerator = [[PDFGenerator alloc] init];

    [[ByteLoadingView defaultLoadingView]showInView:self.view.superview];
    
    [pdfGenerator generatePdfWithCallback:^(BOOL success){
        if (!success) {
            NSLog(@"PdfGenerator: failed to generate!");
            [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
            [self couldNotGenerateReportPDF];
            return;
        }
        NSLog(@"PdfGenerator: generation successful!");
            
        [self movePhotosAndDelete];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"sucess_title"]
                                                        message:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"sucess_text"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
            
        [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Chapter5_PDFGenerated" object:nil];
    }];
}

- (void)generatePdfForPreview
{
    pdfGenerator = [[PDFGenerator alloc] init];
    
    [[ByteLoadingView defaultLoadingView]showInView:self.view.superview];
    
    [pdfGenerator generatePdfWithCallback:^(BOOL success){
        if (!success) {
            NSLog(@"PdfGenerator: failed to generate!");
            [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
            [self couldNotGenerateReportPDF];
            return;
        }
        NSLog(@"PdfGenerator: generation successful!");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"temp_title"]
                                                        message:[LabelManager getTextForParent:@"chapter_five_screen" Key:@"temp_text"]
                                                        delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        [[ByteLoadingView defaultLoadingView] hideActivityIndicator];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Chapter5_PDFGenerated" object:nil];
    }];
}

- (void)movePhotosAndDelete
{
    [self movePhotosToCameraRoll];
    [[AppData getInstance] deleteCurrentReport];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // Ok button pressed
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToDashBoard" object:nil];
    }
}

- (void)couldNotGenerateReportPDF
{
    NSString *err = @"Could not generate report PDF!";
    NSLog(@"%@", err);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LabelManager getTextForParent:@"general" Key:@"error"]
                                                    message:err delegate:nil
                                                    cancelButtonTitle:[LabelManager getTextForParent:@"general" Key:@"ok"]
                                                    otherButtonTitles:nil];
    [alert show];
}

-(void)movePhotosToCameraRoll
{
    AppData *appData = [AppData getInstance];
    NSArray *photos = [appData getAllPhotosForReport:appData.currentReport];
    for (Photo *photo in photos) {
        [ImageUtils deleteImageForID:photo.id];
    }
}

-(void)slideIntoView
{
}

-(void)slideOutOfView
{
}

- (IBAction)dateButtonClicked:(id)sender
{
    UIViewController *viewController = [[UIViewController alloc]init];
    UIView *viewForDatePicker = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    
    datepicker = [[ReportDatePickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.hidden = NO;
    datepicker.date = [NSDate date];
    [datepicker addTarget:self action:@selector(labelChange:) forControlEvents:UIControlEventValueChanged];
    
    [viewForDatePicker addSubview:datepicker];
    [viewController.view addSubview:viewForDatePicker];
    
    popOverForDatePicker = [[UIPopoverController alloc]initWithContentViewController:viewController];
    popOverForDatePicker.delegate = self;
    [popOverForDatePicker setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
    [popOverForDatePicker presentPopoverFromRect:btnDate.frame inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown|UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight) animated:YES];
}

-(void)labelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateStr = [df stringFromDate:datepicker.date];
    NSLog(@"%@", dateStr);
    txt4.text = dateStr;
}

- (void)setupTextFields
{
    NSArray *allTextFields = @[txt1, txt2, txt3, txt4];
    UIColor *disabledColor = [ColorSchemeManager getBorderColorDisabled];
    for (UITextField *textField in allTextFields) {
        textField.enabled = NO;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = disabledColor.CGColor;
        textField.textColor = disabledColor;
        // http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)enableAll
{
    BOOL doEnable = YES;
    UIColor *disabledColor = [ColorSchemeManager getBorderColorDisabled];
    UIColor *borderColor = [ColorSchemeManager getBorderColor];
    UIColor *textColor = [ColorSchemeManager getTextColor];
    
    NSArray *allTextFields = @[txt1, txt2, txt3, txt4];
    for (UITextField *textField in allTextFields) {
        textField.enabled = doEnable;
        textField.textColor = doEnable ? textColor : disabledColor;
        textField.layer.borderColor = doEnable ? borderColor.CGColor : disabledColor.CGColor;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxt1:nil];
    [self setTxt2:nil];
    [self setTxt3:nil];
    [self setTxt4:nil];
    [self setSendButton:nil];
    text_2 = nil;
    text_3 = nil;
    text_4 = nil;
    text_5 = nil;
    text_6 = nil;
    text_7 = nil;
    text_8 = nil;
    text_9 = nil;
    text_10 = nil;
    [super viewDidUnload];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignAllRepsonders];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllRepsonders];
}

- (void)resignAllRepsonders
{
    [txt1 resignFirstResponder];
    [txt2 resignFirstResponder];
    [txt3 resignFirstResponder];
    [txt4 resignFirstResponder];
}

@end
