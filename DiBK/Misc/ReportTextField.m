//
//  ReportButton.m
//  DiBK
//
//  Created by david stummer on 30/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ReportTextField.h"
#import "AppUtils.h"
#import "ColorSchemeManager.h"

@implementation ReportTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // http://stackoverflow.com/questions/10274210/uitextfield-clearbuttonmode-color
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [button setImage:[ColorSchemeManager getTextFieldCancelImage] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = button;
        self.rightViewMode = _setupClearButtonMode = UITextFieldViewModeWhileEditing;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,-2,0,2);
    }
    
    return self;
}

// http://stackoverflow.com/questions/1340224/iphone-uitextfield-change-placeholder-text-color
- (void)drawPlaceholderInRect:(CGRect)rect {
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        rect.origin.y += 12;
    }
    [[ColorSchemeManager getTextColor] setFill];
    [[self placeholder] drawInRect:rect withFont:self.font];
}

// http://stackoverflow.com/questions/7401263/uitextfield-rightviewmode-odd-behaviour
- (BOOL)becomeFirstResponder
{
    BOOL ret = YES ;
    
    ret = [super becomeFirstResponder] ;
    
    if( ret && ( _setupClearButtonMode == UITextFieldViewModeWhileEditing ) )
        self.rightViewMode = UITextFieldViewModeAlways ;
    
    return ret ;
}

// http://stackoverflow.com/questions/7401263/uitextfield-rightviewmode-odd-behaviour
- (BOOL)resignFirstResponder
{
    BOOL ret = YES ;
    
    ret = [super resignFirstResponder] ;
    
    if( ret && ( _setupClearButtonMode == UITextFieldViewModeWhileEditing ) )
        self.rightViewMode = UITextFieldViewModeWhileEditing ;
    
    return ret ;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)clearTextField:(id)sender
{
    self.text = @"";
}

@end
