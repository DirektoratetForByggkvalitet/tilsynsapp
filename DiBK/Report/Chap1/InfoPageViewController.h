//
//  InfoPageViewController.h
//  DiBK

#import <UIKit/UIKit.h>
#import "ReportPickerView.h"

@class KommuneTextField;

@interface InfoPageViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,
                                                     UIPopoverControllerDelegate,
                                                     UIPickerViewDataSource,
                                                     UIPickerViewDelegate>
{
    UIPopoverController *rapportGjelderPickerPopover;
    ReportPickerView *rapportenGjelderPickerView;
    NSArray *rapportenGjelderArr;
    
    __weak IBOutlet UILabel *text_2;
    __weak IBOutlet UILabel *text_3;
    __weak IBOutlet UILabel *text_4;
    __weak IBOutlet UILabel *text_5;
    __weak IBOutlet UILabel *text_6;
    __weak IBOutlet UILabel *text_7;
    __weak IBOutlet UILabel *text_8;
    __weak IBOutlet UILabel *text_9;
    __weak IBOutlet UILabel *text_10;
    __weak IBOutlet UILabel *text_11;
    __weak IBOutlet UILabel *text_12;
    __weak IBOutlet UILabel *text_13;
    __weak IBOutlet UILabel *text_14;
    __weak IBOutlet UILabel *text_15;
    __weak IBOutlet UILabel *text_16;
    __weak IBOutlet UILabel *text_17;
    __weak IBOutlet UILabel *text_18;
    __weak IBOutlet UILabel *text_19;
    __weak IBOutlet UILabel *text_20;
    __weak IBOutlet UILabel *text_21;
}

@property BOOL btn1, btn2, btn3, btn4, btn5, btn6, btn7;
@property (weak, nonatomic) IBOutlet KommuneTextField *txtRegion;
@property (weak, nonatomic) IBOutlet UITextField *datoFortatt;
@property (weak, nonatomic) IBOutlet UITextField *txtTilsynsforer;
@property (weak, nonatomic) IBOutlet UITextField *txtKommune_sakanr;
@property (weak, nonatomic) IBOutlet UITextField *txtRapportenGjelder;
@property (weak, nonatomic) IBOutlet UITextField *text_stedig_tilsyn_varslet;
@property (weak, nonatomic) IBOutlet UITextField *txtGnr;
@property (weak, nonatomic) IBOutlet UITextField *txtBnr;
@property (weak, nonatomic) IBOutlet UITextField *txtFnr;
@property (weak, nonatomic) IBOutlet UITextField *txtSnr;
@property (weak, nonatomic) IBOutlet UITextView *txtViewKommentar;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAnnet;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn1;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn2;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn3;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn4;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn5;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn6;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn7;
@property (weak, nonatomic) IBOutlet UIImageView *ivCombo1;
@property (weak, nonatomic) IBOutlet UIImageView *ivDate;

- (IBAction)btnRapportenGjelderClicked:(id)sender;
- (IBAction)btnClick1:(id)sender;
- (IBAction)btnClick2:(id)sender;
- (IBAction)btnClick3:(id)sender;
- (IBAction)btnClick4:(id)sender;
- (IBAction)btnClick5:(id)sender;
- (IBAction)btnClick6:(id)sender;
- (IBAction)btnClick7:(id)sender;
- (IBAction)info1clicked:(id)sender;
- (IBAction)info2clicked:(id)sender;
- (IBAction)info3clicked:(id)sender;
- (IBAction)info4clicked:(id)sender;
- (IBAction)info5clicked:(id)sender;
- (void)resignAllResponders;
- (UIImage*)getCheckboxImage:(BOOL)checked;

@end
