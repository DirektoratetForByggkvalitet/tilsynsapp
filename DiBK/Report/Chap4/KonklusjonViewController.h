//
//  KonklusjonViewController.h
//  DiBK
//

#import <UIKit/UIKit.h>

@class ReportPickerView;

@interface KonklusjonViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    BOOL cb1Selected;
    BOOL conclusionHasBeenEdited;
    BOOL followupHasBeenEdited;
    ReportPickerView *combo1PickerView;
    UIPopoverController *combo1PopoverController;
    ReportPickerView *combo2PickerView;
    UIPopoverController *combo2PopoverController;
    NSArray *combo1arr, *combo2arr, *combo1infoarr, *combo2infoarr;
    
    __weak IBOutlet UIImageView *btnCombo1;
    __weak IBOutlet UIImageView *lnlCombo1;
    __weak IBOutlet UITextView *textView1;
    __weak IBOutlet UIButton *btnCombo2;
    __weak IBOutlet UITextView *textView2;
    __weak IBOutlet UIButton *btnCb1;
    __weak IBOutlet UIButton *btnCb2;
    __weak IBOutlet UITextField *txtCombo1;
    __weak IBOutlet UITextField *txtCombo2;
    __weak IBOutlet UITextField *tvMaybe;
    __weak IBOutlet UITextField *tvNo;
    __weak IBOutlet UITextField *tvYes;
    __weak IBOutlet UILabel *text_2;
    __weak IBOutlet UILabel *text_3;
    __weak IBOutlet UILabel *text_4;
    __weak IBOutlet UILabel *text_5;
    __weak IBOutlet UILabel *text_ja;
    __weak IBOutlet UILabel *text_nei;
    __weak IBOutlet UILabel *text_delvis;
    __weak IBOutlet UIButton *btnFrontPage;
}

- (IBAction)btnCombo2Clicked:(id)sender;
- (IBAction)btnCombo1Clicked:(id)sender;
- (IBAction)btnCb2Clicked:(id)sender;
- (IBAction)btnCb1Clicked:(id)sender;
- (IBAction)navClicked:(id)sender;
- (void)resignAllResponders;
- (IBAction)info1clicked:(id)sender;
- (IBAction)info2clicked:(id)sender;
- (void)slideOutOfView;

@end
