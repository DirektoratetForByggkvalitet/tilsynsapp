//
//  DetailPageViewController.h
//  DiBK
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "AppData.h"
//#import "AppUtils.h"

@class Chap1ScrollView, TopView, ReportPickerView;

@interface DetailPageViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,
                                                        UIPopoverControllerDelegate,
                                                        UIPickerViewDataSource,
                                                        UIPickerViewDelegate>
{
    UIPopoverController *titaketErPickerPopoverController;
    ReportPickerView *titaketErPickerView;
    NSInteger nTopSubViews;
    UIPopoverController *managerPopoverController;
    ReportPickerView *managerPickerView;
    NSArray *managerArray, *combo2Arr;
    
    __weak IBOutlet UIImageView *ivCombo1;
    __weak IBOutlet UILabel *text_22;
    __weak IBOutlet UILabel *text_23;
    __weak IBOutlet UILabel *text_24;
    __weak IBOutlet UILabel *text_25;
    __weak IBOutlet UILabel *text_26;
    __weak IBOutlet UILabel *text_27;
    __weak IBOutlet UILabel *text_28;
    __weak IBOutlet UILabel *text_29;
    __weak IBOutlet UILabel *text_30;
    __weak IBOutlet UILabel *text_31;
    __weak IBOutlet UILabel *text_32;
    __weak IBOutlet UILabel *text_33;
    __weak IBOutlet UILabel *text_34;
    __weak IBOutlet UILabel *text_35;
    __weak IBOutlet UILabel *text_36;
    __weak IBOutlet UILabel *text_37;
    __weak IBOutlet UILabel *text_38;
}

@property BOOL btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn10, btn11, btn12;
@property (nonatomic, strong) NSMutableArray *topViewArr;
@property (nonatomic, strong) Chap1ScrollView *parentVerticalScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textViewAndreKommentarer;
@property (weak, nonatomic) IBOutlet UITextField *txtTitaketEr;
@property (weak, nonatomic) IBOutlet UIButton *btnTitaketEr;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn1;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn2;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn3;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn4;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn5;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn6;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn7;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn8;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn9;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn10;
@property (weak, nonatomic) IBOutlet UIButton *btnBtn11;
@property (weak, nonatomic) IBOutlet UIButton *btnBtnTitaketEr;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)leggFlereClicked:(id)sender;
- (IBAction)btnClick1:(id)sender;
- (IBAction)btnClick2:(id)sender;
- (IBAction)btnClick3:(id)sender;
- (IBAction)btnClick4:(id)sender;
- (IBAction)btnClick5:(id)sender;
- (IBAction)btnClick6:(id)sender;
- (IBAction)btnClick7:(id)sender;
- (IBAction)btnClick8:(id)sender;
- (IBAction)btnClick9:(id)sender;
- (IBAction)btnClick10:(id)sender;
- (IBAction)btnClick11:(id)sender;
- (IBAction)btnClickTitaketEr:(id)sender;
- (IBAction)titaketErComboClicked:(id)sender;
- (IBAction)info1clicked:(id)sender;
- (IBAction)info2clicked:(id)sender;
- (IBAction)info3clicked:(id)sender;
- (void)resignAllResponders;
- (void)removeTopView:(TopView*)topView;
- (void)addManagerWithA:(NSString*)a b:(NSString*)b c:(NSString*)c title:(NSString*)title;

@end
