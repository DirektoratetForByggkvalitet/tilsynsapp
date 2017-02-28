//
//  KommuneTextField.h
//  DiBK
//
//  Created by david stummer on 12/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

@class ReportPickerView, KommuneTextFieldDelegate, Municipality;

@interface KommuneTextField : UITextField<UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    KommuneTextFieldDelegate *kommuneTextFieldDelegate;
    ReportPickerView *reportPickerView;
    UIPopoverController *popoverController;
    NSMutableArray *allKommunes;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(void)touchesBegan;
-(void)setSelectKommuneWithId:(NSString*)idStr;
@property (nonatomic,strong)Municipality *selectedKommune;
@end
