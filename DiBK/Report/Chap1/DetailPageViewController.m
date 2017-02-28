//
//  DetailPageViewController.m
//  DiBK

#ifndef MIN
#import <NSObjCRuntime.h>
#endif
#import "DetailPageViewController.h"
#import "TopView.h"
#import "Chap1ScrollView.h"
#import "AppUtils.h"
#import "Info.h"
#import "ReportPickerView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "ListManager.h"

@implementation DetailPageViewController
@synthesize textViewAndreKommentarer, txtTitaketEr, topView, bottomView,
            btnBtn1, btnBtn2, btnBtn3, btnBtn4, btnBtn5, btnBtn6, parentVerticalScrollView,
            btnBtn7, btnBtn8, btnBtn9, btnBtn10, btnBtn11, btnBtnTitaketEr,
            btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn10, btn11, btn12,
            topViewArr;

-(void)removeInfoButtonsForPdf
{
    const int kInfoButtonTag = 1;
    for (UIView *v in self.view.subviews) {
        if (v.tag == kInfoButtonTag) {
            v.hidden = YES;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    btn1 = btn2 = btn3 = btn4 = btn5 = btn6 = btn7 = btn8 = btn9 = btn10 = btn11 = btn12 = FALSE;
    nTopSubViews = 0;
    topViewArr = [[NSMutableArray alloc] init];
    managerArray = [ListManager getListForParent:@"chapter_one_screen" andKey:@"part_role_list"];
    combo2Arr = [ListManager getListForParent:@"chapter_one_screen" andKey:@"project_is_list"];
    txtTitaketEr.enabled = NO;
    
    [self loadColorScheme];
    [self loadLabels];
}

-(void)loadLabels
{
    text_22.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_22"];
    text_23.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_23"];
    text_24.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_24"];
    text_25.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_25"];
    text_26.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_26"];
    text_27.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_27"];
    text_28.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_28"];
    text_29.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_29"];
    text_30.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_30"];
    text_31.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_31"];
    text_32.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_32"];
    text_33.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_33"];
    text_34.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_34"];
    text_35.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_35"];
    text_36.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_36"];
    text_37.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_37"];
    text_38.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_38"];
}

-(void)loadColorScheme
{
    UIColor *borderColor, *bgColor;
    borderColor = [ColorSchemeManager getBorderColor];
    bgColor = [ColorSchemeManager getBgColor];
    [self loadDarkColorSchemeWithBorderColor:borderColor andBgColor:bgColor];
}

- (void)loadDarkColorSchemeWithBorderColor:(UIColor*)borderColor andBgColor:(UIColor*)bgColor
{
    [ColorSchemeManager updateView:self.view];
    
    // checkboxes
    [btnBtn1 setImage:[ColorSchemeManager getCheckboxImage:btn1] forState:UIControlStateNormal];
    [btnBtn2 setImage:[ColorSchemeManager getCheckboxImage:btn2] forState:UIControlStateNormal];
    [btnBtn3 setImage:[ColorSchemeManager getCheckboxImage:btn3] forState:UIControlStateNormal];
    [btnBtn4 setImage:[ColorSchemeManager getCheckboxImage:btn4] forState:UIControlStateNormal];
    [btnBtn5 setImage:[ColorSchemeManager getCheckboxImage:btn5] forState:UIControlStateNormal];
    [btnBtn6 setImage:[ColorSchemeManager getCheckboxImage:btn6] forState:UIControlStateNormal];
    [btnBtn7 setImage:[ColorSchemeManager getCheckboxImage:btn7] forState:UIControlStateNormal];
    [btnBtn8 setImage:[ColorSchemeManager getCheckboxImage:btn8] forState:UIControlStateNormal];
    [btnBtn9 setImage:[ColorSchemeManager getCheckboxImage:btn9] forState:UIControlStateNormal];
    [btnBtn10 setImage:[ColorSchemeManager getCheckboxImage:btn10] forState:UIControlStateNormal];
    [btnBtn11 setImage:[ColorSchemeManager getCheckboxImage:btn11] forState:UIControlStateNormal];
    [btnBtnTitaketEr setImage:[ColorSchemeManager getCheckboxImage:btn12] forState:UIControlStateNormal];

    self.view.backgroundColor = bgColor;
    self.topView.backgroundColor = bgColor;
    self.bottomView.backgroundColor = bgColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}


// IOS 7 UITextview bug - cursor drops below the visible content
// http://stackoverflow.com/questions/18861573/cursor-outside-uitextview
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (void) textViewDidChangeSelection: (UITextView *) tView {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [tView scrollRangeToVisible: [tView selectedRange]];
    }
}

- (void)viewDidUnload {
    [self setTextViewAndreKommentarer:nil];
    [self setTxtTitaketEr:nil];
    [self setBtnTitaketEr:nil];
    [self setBtnBtn1:nil];
    [self setBtnBtn2:nil];
    [self setBtnBtn3:nil];
    [self setBtnBtn4:nil];
    [self setBtnBtn5:nil];
    [self setBtnBtn6:nil];
    [self setBtnBtn7:nil];
    [self setBtnBtn8:nil];
    [self setBtnBtn9:nil];
    [self setBtnBtn10:nil];
    [self setBtnBtn11:nil];
    [self setTopView:nil];
    [self setBottomView:nil];
    ivCombo1 = nil;
    text_22 = nil;
    text_23 = nil;
    text_24 = nil;
    text_25 = nil;
    text_26 = nil;
    text_27 = nil;
    text_28 = nil;
    text_29 = nil;
    text_30 = nil;
    text_31 = nil;
    text_32 = nil;
    text_33 = nil;
    text_34 = nil;
    text_35 = nil;
    text_36 = nil;
    text_37 = nil;
    text_38 = nil;
    [super viewDidUnload];
}

- (IBAction)titaketErComboClicked:(id)sender {
    
    if (titaketErPickerView == nil) {
        titaketErPickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        titaketErPickerView.backgroundColor = [UIColor clearColor];
        titaketErPickerView.showsSelectionIndicator = YES;
        titaketErPickerView.delegate = self;
        titaketErPickerView.dataSource = self;
        
        UIViewController *vc = [[UIViewController alloc] init];
        [vc.view addSubview:titaketErPickerView];
        
        titaketErPickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
        titaketErPickerPopoverController.popoverContentSize = titaketErPickerView.frame.size;
        titaketErPickerPopoverController.delegate = self;
    }
    
    NSInteger offset = 50 * nTopSubViews + 100;
    CGRect frame = [sender frame];
    frame.origin.y += offset;
    [titaketErPickerPopoverController presentPopoverFromRect:frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [ColorSchemeManager setBorderSelected:txtTitaketEr yes:YES];
}

- (IBAction)info1clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page2_info1"];
}

- (IBAction)info2clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page2_info2"];
}

- (IBAction)info3clicked:(id)sender {
    [Info showInfoScreenForkey:@"chapter1_page2_info3"];
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
}

- (IBAction)leggFlereClicked:(id)sender
{
    if (managerPickerView == nil) {
        managerPickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        managerPickerView.backgroundColor = [UIColor clearColor];
        managerPickerView.showsSelectionIndicator = YES;
        managerPickerView.delegate = self;
        managerPickerView.dataSource = self;
        
        UIViewController *vc = [[UIViewController alloc] init];
        [vc.view addSubview:managerPickerView];
        
        managerPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
        managerPopoverController.popoverContentSize = managerPickerView.frame.size;
        managerPopoverController.delegate = self;
    }
    
    [managerPopoverController presentPopoverFromRect:((UIView*)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == managerPickerView) {
        return managerArray.count;
    }
    
    return combo2Arr.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == managerPickerView) {
        return managerArray[row];
    }
    
    return combo2Arr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ReportPickerView *pv = (ReportPickerView*)pickerView;
    
    if (pv == managerPickerView && pv.didTap) {
        TopView *tv = [self addView];
        tv.title.text = managerArray[row];
        [self loadColorScheme];
        [managerPopoverController dismissPopoverAnimated:YES];
    }
    
    if (pv == titaketErPickerView) {
        [[self txtTitaketEr] setText:combo2Arr[row]];
        [ColorSchemeManager setBorderSelected:txtTitaketEr yes:NO];
        if (pv.didTap) {
            [titaketErPickerPopoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == titaketErPickerPopoverController) {
        [ColorSchemeManager setBorderSelected:txtTitaketEr yes:NO];
    }
}

- (void)removeTopView:(TopView*)tv
{
    NSArray *allTopViews = [NSMutableArray arrayWithArray:topViewArr];
    topViewArr = [[NSMutableArray alloc] init];
    nTopSubViews = 0;
    for (TopView *tv2 in allTopViews) {
        [tv2 removeFromSuperview];
    }
    
    for (TopView *tv2 in allTopViews) {
        if (tv2 == tv) {
            continue;
        }
        [self addManagerWithA:tv2.txt1.text b:tv2.txt2.text c:tv2.txt3.text title:tv2.title.text];
    }
}

static const int kTopViewHeight = 95;
- (TopView*)addView
{
    NSInteger offset = kTopViewHeight * nTopSubViews;
    
    CGRect frame = topView.frame;
    frame.size.height = 100 + offset;
    topView.frame = frame;
    
    frame = bottomView.frame;
    frame.origin.y = 186 + offset;
    bottomView.frame = frame;
    
    
    // http://stackoverflow.com/a/3191405
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"TopView" owner:self options:nil];
    
    TopView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[TopView class]])
            blah = (TopView *)object;
    }
    assert(blah != nil && "blah can't be nil");
    blah.viewController = self;
    [topView addSubview: blah];
    [topViewArr addObject:blah];
    
    frame = blah.frame;
    frame.origin.y = offset;
    blah.frame = frame;
    
    nTopSubViews++;
    
    [parentVerticalScrollView increaseHeightOfDetailPage:nTopSubViews];
    
    return blah;
}

- (void)addManagerWithA:(NSString*)a b:(NSString*)b c:(NSString*)c title:(NSString*)title
{
    if (title == nil || [title isEqualToString:@""]) {
        title = managerArray[0];
    }
    
    TopView *tv = [self addView];
    tv.txt1.text = a;
    tv.txt2.text = b;
    tv.txt3.text = c;
    tv.title.text = title;
    [self loadColorScheme];
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

- (IBAction)btnClick8:(id)sender {
    if(btn8){
        [btnBtn8 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn8 = FALSE;
    }
    else{
        [btnBtn8 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn8 = TRUE;
    }
}

- (IBAction)btnClick9:(id)sender {
    if(btn9){
        [btnBtn9 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn9 = FALSE;
    }
    else{
        [btnBtn9 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn9 = TRUE;
    }
}

- (IBAction)btnClick10:(id)sender {
    if(btn10){
        [btnBtn10 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn10 = FALSE;
    }
    else{
        [btnBtn10 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn10 = TRUE;
    }
}

- (IBAction)btnClick11:(id)sender {
    if(btn11){
        [btnBtn11 setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn11 = FALSE;
    }
    else{
        [btnBtn11 setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn11 = TRUE;
    }
}

- (IBAction)btnClickTitaketEr:(id)sender {
    if(btn12){
        [btnBtnTitaketEr setImage:[ColorSchemeManager getCheckboxImage:FALSE] forState:normal];
        
        btn12 = FALSE;
    }
    else{
        [btnBtnTitaketEr setImage:[ColorSchemeManager getCheckboxImage:TRUE] forState:normal];
        btn12 = TRUE;
    }
}

-(void)resignAllResponders
{
    [textViewAndreKommentarer resignFirstResponder];
    for (TopView *tv in topViewArr) {
        [tv.txt1 resignFirstResponder];
        [tv.txt2 resignFirstResponder];
        [tv.txt3 resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllResponders];
}
@end
