//
//  KonklusjonViewController.m
//  DiBK
//


#import "KonklusjonViewController.h"
#import "AppData.h"
#import "Template.h"
#import "Checklist.h"
#import "AuditType.h"
#import "Question.h"
#import "Rapport.h"
#import "Conclusion.h"
#import "AppUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "Info.h"
#import "ReportPickerView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "ListManager.h"

@implementation KonklusjonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    conclusionHasBeenEdited = [[NSUserDefaults standardUserDefaults] boolForKey:@"conclusionHasBeenEdited"];
    followupHasBeenEdited = [[NSUserDefaults standardUserDefaults] boolForKey:@"followupHasBeenEdited"];
    
    [self populateBoxes];
    
    AppData *appData = [AppData getInstance];
    Conclusion *conclusion = appData.currentReport.conclusion;

    txtCombo1.text = conclusion.combo1;
    txtCombo2.text = conclusion.combo2;
    textView1.text = conclusion.textview1;
    textView2.text = conclusion.textview2;
    cb1Selected = [conclusion.checkbox isEqualToString:@"yes"];
    combo1arr = [ListManager getListForParent:@"chapter_four_screen" andKey:@"conclusion_list"];
    combo2arr = [ListManager getListForParent:@"chapter_four_screen" andKey:@"followup_list"];
    combo1infoarr = [ListManager getListForParent:@"chapter_four_screen" andKey:@"conclusion_list_text"];
    combo2infoarr = [ListManager getListForParent:@"chapter_four_screen" andKey:@"followup_list_text"];
    
    [btnFrontPage.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f]];
    [btnFrontPage setTitle:[LabelManager getTextForParent:@"general" Key:@"back_menu"] forState:UIControlStateNormal];
    
    [self loadColorScheme];
    [self loadLabels];
}

-(void)loadColorScheme
{
    [ColorSchemeManager updateView:self.view];
    self.view.backgroundColor = [ColorSchemeManager getBgColor];
    // reset our colourful textfields
    tvYes.textColor = [UIColor colorWithRed:167.0f/255.0f green:221.0f/255.0f blue:50.0f/255.0f alpha:1];
    tvNo.textColor = [UIColor colorWithRed:255.0f/255.0f green:187.0f/255.0f blue:50.0f/255.0f alpha:1];
    tvMaybe.textColor = [UIColor colorWithRed:24.0f/255.0f green:156.0f/255.0f blue:188.0f/255.0f alpha:1];
    // checkboxes
    [self cbClicked];
}

// IOS 7 UITextview bug - cursor drops below the visible content
// http://stackoverflow.com/questions/18861573/cursor-outside-uitextview
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (void) textViewDidChangeSelection: (UITextView *) tView {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [tView scrollRangeToVisible: [tView selectedRange]];
    }
}

-(void)loadLabels
{
    text_2.text = [LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_2"];
    text_3.text = [LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_3"];
    text_4.text = [LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_4"];
    text_5.text = [LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_5"];
    text_ja.text = [LabelManager getTextForParent:@"general" Key:@"yes"];
    text_nei.text = [LabelManager getTextForParent:@"general" Key:@"no"];
    text_delvis.text = [LabelManager getTextForParent:@"general" Key:@"maybe"];
}

-(void)slideOutOfView
{
    NSLog(@"--Save data Chap 4 is being called---");
    
    AppData *appData = [AppData getInstance];
    Conclusion *conclusion = appData.currentReport.conclusion;
    conclusion.combo1 = txtCombo1.text;
    conclusion.combo2 = txtCombo2.text;
    conclusion.textview1 = textView1.text;
    conclusion.textview2 = textView2.text;
    if (cb1Selected) {
        conclusion.checkbox = @"yes";
    } else {
        conclusion.checkbox = @"no";
    }
    [appData save];
    [textView1 resignFirstResponder];
    [textView2 resignFirstResponder];
}

- (IBAction)btnCb2Clicked:(id)sender {
    cb1Selected = FALSE;
    [self cbClicked];
}

- (IBAction)btnCb1Clicked:(id)sender {
    cb1Selected = TRUE;
    [self cbClicked];
}

- (IBAction)navClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChapterFour_RightNavClicked" object:nil];
}

- (IBAction)info1clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter4_info1"];
}

- (IBAction)info2clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter4_info2"];
}

-(void)cbClicked
{
    [btnCb1 setImage:[ColorSchemeManager getRadioButtonImage:cb1Selected] forState:UIControlStateNormal];
    [btnCb2 setImage:[ColorSchemeManager getRadioButtonImage:!cb1Selected] forState:UIControlStateNormal];
}

-(void)resignAllResponders
{
    [textView1 resignFirstResponder];
    [textView2 resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllResponders];
}

- (IBAction)btnFrontPageClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateBackToFrontPage" object:nil];
    [self.view endEditing:YES];
}

- (IBAction)btnCombo1Clicked:(id)sender
{
    if (combo1PickerView == nil)
    {
        combo1PickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        combo1PickerView.backgroundColor = [UIColor clearColor];
        combo1PickerView.showsSelectionIndicator = YES;
        combo1PickerView.delegate = self;
        combo1PickerView.dataSource = self;
        
        UIViewController *pickerController = [[UIViewController alloc] init];
        [pickerController.view addSubview:combo1PickerView];
        
        combo1PopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
        combo1PopoverController.popoverContentSize = combo1PickerView.frame.size;
        combo1PopoverController.delegate = self;
    }
    
    [combo1PopoverController presentPopoverFromRect:[sender frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if (txtCombo1.text == nil || [txtCombo1.text isEqualToString:@""]) {
        txtCombo1.text = combo1arr[0];
    }
    
    [ColorSchemeManager setBorderSelected:txtCombo1 yes:YES];
}

- (IBAction)btnCombo2Clicked:(id)sender
{
    if (combo2PickerView == nil)
    {
        combo2PickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 600, 216)];
        combo2PickerView.backgroundColor = [UIColor clearColor];
        combo2PickerView.showsSelectionIndicator = YES;
        combo2PickerView.delegate = self;
        combo2PickerView.dataSource = self;
        
        UIViewController *pickerController = [[UIViewController alloc] init];
        [pickerController.view addSubview:combo2PickerView];
        
        combo2PopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
        combo2PopoverController.popoverContentSize = combo2PickerView.frame.size;
        combo2PopoverController.delegate = self;
    }
    
    [combo2PopoverController presentPopoverFromRect:[sender frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if (txtCombo2.text == nil || [txtCombo2.text isEqualToString:@""]) {
        txtCombo2.text = combo2arr[0];
    }
    
    [ColorSchemeManager setBorderSelected:txtCombo2 yes:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == combo1PopoverController) {
        [ColorSchemeManager setBorderSelected:txtCombo1 yes:NO];
    }
    if (popoverController == combo2PopoverController) {
        [ColorSchemeManager setBorderSelected:txtCombo2 yes:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [ColorSchemeManager setBorderSelected:textView yes:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [ColorSchemeManager setBorderSelected:textView yes:NO];
    
    if(textView == textView1) {
        if(![textView.text isEqualToString:@""] && conclusionHasBeenEdited == false) {
            conclusionHasBeenEdited = true;
        } else {
            conclusionHasBeenEdited = false;
        }
    } else
    if(textView == textView2) {
        if(![textView.text isEqualToString:@""] && followupHasBeenEdited == false) {
            followupHasBeenEdited = true;
        } else {
            followupHasBeenEdited = false;
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:conclusionHasBeenEdited forKey:@"conclusionHasBeenEdited"];
    [[NSUserDefaults standardUserDefaults] setBool:followupHasBeenEdited forKey:@"followupHasBeenEdited"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == combo1PickerView) {
        return combo1arr.count;
    }
    if (pickerView == combo2PickerView) {
        return combo2arr.count;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == combo1PickerView) {
        return [combo1arr objectAtIndex:row];
    }
    if (pickerView == combo2PickerView) {
        return [combo2arr objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ReportPickerView *pv = (ReportPickerView*)pickerView;
    
    if (pickerView == combo1PickerView)
    {
        txtCombo1.text = [combo1arr objectAtIndex:row];
        
        if(conclusionHasBeenEdited == false) {
            textView1.text = [combo1infoarr objectAtIndex:row];
        }
        
        [ColorSchemeManager setBorderSelected:txtCombo1 yes:NO];
        if (pv.didTap) {
            [combo1PopoverController dismissPopoverAnimated:YES];
        }
    }
    
    if (pickerView == combo2PickerView) {
        txtCombo2.text = [combo2arr objectAtIndex:row];
        
        if(followupHasBeenEdited == false) {
            textView2.text = [combo2infoarr objectAtIndex:row];
        }
        
        [ColorSchemeManager setBorderSelected:txtCombo2 yes:NO];
        if (pv.didTap) {
            [combo2PopoverController dismissPopoverAnimated:YES];
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:conclusionHasBeenEdited forKey:@"conclusionHasBeenEdited"];
    [[NSUserDefaults standardUserDefaults] setBool:followupHasBeenEdited forKey:@"followupHasBeenEdited"];
}

- (void)populateBoxes
{
    AppData *appData = [AppData getInstance];
    int nYes = 0, nNo = 0, nMaybe = 0;
    
    NSArray *templates = [appData fetchTemplates];
    for (Template *template in templates) {
        NSSet *checklists = template.checklists;
        for (Checklist *checklist in checklists) {
            NSSet *auditTypes = checklist.audiTypes;
            for (AuditType *auditType in auditTypes) {
                if (auditType.isChecked) {
                    NSSet *questions = auditType.questions;
                    for (Question *question in questions) {
                        NSString *answer = question.answer;
                        if ([answer isEqual: @"yes"]) {
                            nYes++;
                        } else if ([answer isEqual: @"no"]) {
                            nNo++;
                        } else if ([answer isEqual: @"maybe"]) {
                            nMaybe++;
                        }
                    }
                }
            }
        }
    }
    
    tvYes.text = [NSString stringWithFormat:@"%d", nYes];
    tvNo.text = [NSString stringWithFormat:@"%d", nNo];
    tvMaybe.text = [NSString stringWithFormat:@"%d", nMaybe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    btnCombo1 = nil;
    lnlCombo1 = nil;
    textView1 = nil;
    btnCombo2 = nil;
    textView2 = nil;
    btnCb1 = nil;
    btnCb2 = nil;
    tvYes = nil;
    tvNo = nil;
    tvMaybe = nil;
    txtCombo1 = nil;
    txtCombo2 = nil;
    text_2 = nil;
    text_3 = nil;
    text_4 = nil;
    text_5 = nil;
    text_ja = nil;
    text_nei = nil;
    text_delvis = nil;
    [super viewDidUnload];
}

@end
