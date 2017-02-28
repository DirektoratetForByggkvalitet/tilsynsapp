//
//  KommuneTextField.m
//  DiBK
//
//  Created by david stummer on 12/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "KommuneTextField.h"
#import "ReportPickerView.h"
#import "AppUtils.h"
#import "Municipality.h"

// http://stackoverflow.com/questions/1747777/self-delegate-self-whats-wrong-in-doing-that
// cannot make uitextfield a delegate of itself (see link above)
// so instead we will create class and route the messages back to uitextfield
@interface KommuneTextFieldDelegate : NSObject<UITextFieldDelegate>
@property (nonatomic, strong) KommuneTextField *tf;
@end
@implementation KommuneTextFieldDelegate
@synthesize tf;
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [tf textFieldShouldBeginEditing:textField];
}
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
     return [tf textFieldShouldReturn:theTextField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    return [tf textFieldDidEndEditing:textField];
}
@end

@implementation KommuneTextField
@synthesize selectedKommune;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTextView];
        [self initPicker];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTextView];
        [self initPicker];
    }
    return self;
}

-(NSArray*)getKommunes
{
    if (!allKommunes) {
        allKommunes = [AppUtils getAllMunicipalities];
    }
    return allKommunes;
}

-(void)initTextView
{
    kommuneTextFieldDelegate = [KommuneTextFieldDelegate new];
    kommuneTextFieldDelegate.tf = self;
    self.delegate = kommuneTextFieldDelegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:self];
}

-(void)initPicker
{
    reportPickerView = [[ReportPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    reportPickerView.backgroundColor = [UIColor clearColor];
    reportPickerView.showsSelectionIndicator = YES;
    reportPickerView.delegate = self;
    reportPickerView.dataSource = self;
    
    UIViewController *pickerController = [[UIViewController alloc] init];
    [pickerController.view addSubview:reportPickerView];
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    popoverController.popoverContentSize = reportPickerView.frame.size;
    popoverController.delegate = self;
    popoverController.passthroughViews = @[self];
}

- (void)textFieldChanged
{
    NSArray *k = [AppUtils getAllMunicipalities];
    allKommunes = [NSMutableArray new];
    for (Municipality *m in k) {
        NSString *name = m.name;
        if (self.text.length > name.length) {
            continue;
        }
        NSString *partName =[[name substringWithRange:NSMakeRange(0, self.text.length)] lowercaseString];
        if ([partName isEqualToString:[self.text lowercaseString]]) {
            [allKommunes addObject:m];
        }
    }
    [reportPickerView reloadComponent:0];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [popoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [popoverController dismissPopoverAnimated:YES];
    [self setKommuneTextfield];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self getKommunes].count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Municipality *m = [self getKommunes][row];
    return [m getIdStr];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ReportPickerView *pv = (ReportPickerView*)pickerView;
    Municipality *m = [[self getKommunes] objectAtIndex:row];
    selectedKommune = m;
    self.text = m.name;
    if (pv.didTap) {
        [self resignFirstResponder];
        [popoverController dismissPopoverAnimated:YES];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self resignAllResponders];
}

- (void)touchesBegan
{
    [self resignAllResponders];
}

- (void)resignAllResponders
{
    [self resignFirstResponder];
    [popoverController dismissPopoverAnimated:YES];
    [self setKommuneTextfield];
}

-(void)setSelectKommuneWithId:(NSString *)idStr
{
    NSArray *all = [self getKommunes];
    for (Municipality *k in all) {
        if ([[k getIdStr] isEqualToString:idStr]) {
            selectedKommune = k;
            break;
        }
    }
}

- (void)setKommuneTextfield
{
    if (reportPickerView == nil) {
        return;
    }
    
    int row = [reportPickerView selectedRowInComponent:0];
    NSArray *ak = [self getKommunes];
    if (ak.count <= 0) {
        NSLog(@"WARNING - could not get any kommunes");
        return;
    }
    
    Municipality *m = [ak objectAtIndex:row];
    selectedKommune = m;
    self.text = m.name;
}

@end
