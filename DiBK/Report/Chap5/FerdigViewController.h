//
//  FerdigViewController.h
//  DiBK
//
//  Created by david stummer on 16/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFGenerator, KommuneTextField, ReportDatePickerView;

@interface FerdigViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>
{
    PDFGenerator *pdfGenerator;
    
    __weak IBOutlet UILabel *text_2;
    __weak IBOutlet UILabel *text_3;
    __weak IBOutlet UILabel *text_4;
    __weak IBOutlet UILabel *text_5;
    __weak IBOutlet UILabel *text_6;
    __weak IBOutlet UILabel *text_7;
    __weak IBOutlet UILabel *text_8;
    __weak IBOutlet UILabel *text_9;
    __weak IBOutlet UILabel *text_10;
    __weak IBOutlet UITextView *confirmationHelpText;
    
    ReportDatePickerView *datepicker;
    UIPopoverController *popOverForDatePicker;
    __weak IBOutlet UIButton *btnDate;
}

@property (weak, nonatomic) IBOutlet KommuneTextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (weak, nonatomic) IBOutlet UITextField *txt4;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *sendPreviewButton;

-(void)resignAllRepsonders;
-(void)slideIntoView;
-(void)slideOutOfView;
- (IBAction)dateButtonClicked:(id)sender;

@end
