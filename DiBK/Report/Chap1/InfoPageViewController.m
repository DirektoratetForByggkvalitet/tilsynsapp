//
//  InfoPageViewController.m
//  DiBK


#import "InfoPageViewController.h"
#import "AppData.h"
#import "Municipality.h"
#import "AppUtils.h"
#import "Info.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "ListManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation InfoPageViewController

@synthesize txtTilsynsforer, txtRapportenGjelder,
            txtKommune_sakanr, datoFortatt, ivCombo1, ivDate,
            txtViewKommentar, txtViewAnnet, txtRegion, text_stedig_tilsyn_varslet,
            btn1, btn2, btn3, btn4, btn5, btn6, btn7, txtGnr, txtBnr, txtFnr, txtSnr,
            btnBtn1, btnBtn2, btnBtn3, btnBtn4, btnBtn5, btnBtn6, btnBtn7;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    btn1 = btn2 = btn3 = btn4 = btn5 = btn6 = btn7 = FALSE;
    
    txtRapportenGjelder.enabled = NO;
    
    [self loadColorScheme];
    [self loadLabels];
    
    rapportenGjelderArr = [ListManager getListForParent:@"chapter_one_screen" andKey:@"regarding_list"];
}

-(void)loadColorScheme
{
    [ColorSchemeManager updateView:self.view];
    
    UIColor *bgColor;
    bgColor = [ColorSchemeManager getBgColor];
    
    // checkboxes
    [btnBtn1 setImage:[ColorSchemeManager getCheckboxImage:btn1] forState:UIControlStateNormal];
    [btnBtn2 setImage:[ColorSchemeManager getCheckboxImage:btn2] forState:UIControlStateNormal];
    [btnBtn3 setImage:[ColorSchemeManager getCheckboxImage:btn3] forState:UIControlStateNormal];
    [btnBtn4 setImage:[ColorSchemeManager getCheckboxImage:btn4] forState:UIControlStateNormal];
    [btnBtn5 setImage:[ColorSchemeManager getCheckboxImage:btn5] forState:UIControlStateNormal];
    [btnBtn6 setImage:[ColorSchemeManager getCheckboxImage:btn6] forState:UIControlStateNormal];
    [btnBtn7 setImage:[ColorSchemeManager getCheckboxImage:btn7] forState:UIControlStateNormal];
    
    // set backgrond color
    self.view.backgroundColor = bgColor;
}

-(void)loadLabels
{
    text_2.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_2"];
    text_3.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_3"];
    text_4.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_4"];
    text_5.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_5"];
    text_6.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_6"];
    text_7.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_7"];
    text_8.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_8"];
    text_9.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_9"];
    text_10.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_10"];
    text_11.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_11"];
    text_12.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_12"];
    text_13.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_13"];
    text_14.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_14"];
    text_15.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_15"];
    text_16.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_16"];
    text_17.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_17"];
    text_18.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_18"];
    text_19.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_19"];
    text_20.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_20"];
    text_21.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_21"];
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtRapportenGjelder:nil];
    rapportenGjelderPickerView = nil;
    [self setText_stedig_tilsyn_varslet:nil];
    [self setTxtGnr:nil];
    [self setTxtBnr:nil];
    [self setTxtFnr:nil];
    [self setTxtSnr:nil];
    [self setTxtViewKommentar:nil];
    [self setTxtViewAnnet:nil];
    [self setBtnBtn2:nil];
    [self setBtnBtn3:nil];
    [self setBtnBtn4:nil];
    [self setBtnBtn5:nil];
    [self setBtnBtn6:nil];
    [self setBtnBtn7:nil];
    [self setTxtRegion:nil];
    [self setIvCombo1:nil];
    [self setIvDate:nil];
    text_2 = nil;
    text_3 = nil;
    text_4 = nil;
    text_5 = nil;
    text_6 = nil;
    text_7 = nil;
    text_8 = nil;
    text_9 = nil;
    text_10 = nil;
    text_11 = nil;
    text_12 = nil;
    text_13 = nil;
    text_14 = nil;
    text_15 = nil;
    text_16 = nil;
    text_17 = nil;
    text_18 = nil;
    text_19 = nil;
    text_20 = nil;
    text_21 = nil;
    [super viewDidUnload];
}

- (IBAction)btnRapportenGjelderClicked:(id)sender
{
    if (rapportenGjelderPickerView == nil)
    {
        rapportenGjelderPickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        rapportenGjelderPickerView.backgroundColor = [UIColor clearColor];
        rapportenGjelderPickerView.showsSelectionIndicator = YES;
        rapportenGjelderPickerView.delegate = self;
        rapportenGjelderPickerView.dataSource = self;
        
        UIViewController *pickerController = [[UIViewController alloc] init];
        [pickerController.view addSubview:rapportenGjelderPickerView];
        
        rapportGjelderPickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
        rapportGjelderPickerPopover.popoverContentSize = rapportenGjelderPickerView.frame.size;
        rapportGjelderPickerPopover.delegate = self;
    }
    
    [rapportGjelderPickerPopover presentPopoverFromRect:[sender frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if ([txtRapportenGjelder.text isEqualToString:@""] || txtRapportenGjelder.text == nil) {
        txtRapportenGjelder.text = [rapportenGjelderArr objectAtIndex:0];
    }
    
    [ColorSchemeManager setBorderSelected:txtRapportenGjelder yes:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:YES];
}

// IOS 7 UITextview bug - cursor drops below the visible content
// http://stackoverflow.com/questions/18861573/cursor-outside-uitextview
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (void) textViewDidChangeSelection: (UITextView *) tView {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [tView scrollRangeToVisible: [tView selectedRange]];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [ColorSchemeManager setBorderSelected:textView yes:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [ColorSchemeManager setBorderSelected:textView yes:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [ColorSchemeManager setBorderSelected:textField yes:NO];
}

- (IBAction)btnClick1:(id)sender {
    if(btn1){
        [btnBtn1 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn1 = FALSE;
    }
    else{
        [btnBtn1 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn1 = TRUE;
    }
}

- (IBAction)btnClick2:(id)sender {
    if(btn2){
        [btnBtn2 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn2 = FALSE;
    }
    else{
        [btnBtn2 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn2 = TRUE;
    }
}

- (IBAction)btnClick3:(id)sender {
    if(btn3){
        [btnBtn3 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn3 = FALSE;
    }
    else{
        [btnBtn3 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn3 = TRUE;
    }
}

- (IBAction)btnClick4:(id)sender {
    if(btn4){
        [btnBtn4 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn4 = FALSE;
    }
    else{
        [btnBtn4 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn4 = TRUE;
    }
}

- (IBAction)btnClick5:(id)sender {
    if(btn5){
        [btnBtn5 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn5 = FALSE;
    }
    else{
        [btnBtn5 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn5 = TRUE;
    }
}

- (IBAction)btnClick6:(id)sender {
    if(btn6){
        [btnBtn6 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn6 = FALSE;
    }
    else{
        [btnBtn6 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn6 = TRUE;
    }
}

- (IBAction)btnClick7:(id)sender {
    if(btn7){
        [btnBtn7 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn7 = FALSE;
    }
    else{
        [btnBtn7 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn7 = TRUE;
    }
}

- (IBAction)info1clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page1_info1"];
}

- (IBAction)info2clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page1_info2"];
}

- (IBAction)info3clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page1_info3"];
}

- (IBAction)info4clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page1_info4"];
}

- (IBAction)info5clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page1_info5"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == rapportenGjelderPickerView)
    {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == rapportenGjelderPickerView)
    {
        return rapportenGjelderArr.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == rapportenGjelderPickerView)
    {
        return [rapportenGjelderArr objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ReportPickerView *pv = (ReportPickerView*)pickerView;
    
    if (pv == rapportenGjelderPickerView)
    {
        NSString *lblText = [rapportenGjelderArr objectAtIndex:row];
        [[self txtRapportenGjelder] setText:lblText];
        [ColorSchemeManager setBorderSelected:txtRapportenGjelder yes:NO];
        if (pv.didTap) {
            [rapportGjelderPickerPopover dismissPopoverAnimated:YES];
        }
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [ColorSchemeManager setBorderSelected:txtRapportenGjelder yes:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllResponders];
}

- (void)resignAllResponders
{
    NSArray *others = @[txtViewKommentar,txtViewAnnet,txtKommune_sakanr,datoFortatt,txtGnr,txtBnr,txtFnr,txtSnr,text_stedig_tilsyn_varslet,txtTilsynsforer,txtRegion];
    for (UIView *v in others) {
        [v resignFirstResponder];
    }
}

@end
