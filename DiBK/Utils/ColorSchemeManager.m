//
//  ColorScheme.m
//  DiBK
//
//  Created by david stummer on 02/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ColorSchemeManager.h"

@implementation ColorSchemeManager

// utility used by this class for the dark blue color used for backgrounds
+ (UIColor*)getDarkBlueColor
{
    return [UIColor colorWithRed:2.0f/255.0f green:40.0f/255.0f blue:57.0f/255.0f alpha:1];
}

// utility used by this class
+ (UIColor*)getLightBlueColor
{
    return [UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1];
}

+ (ColorScheme)getCurrentColorScheme
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ColorScheme scheme = [defaults integerForKey:@"colorScheme"];
    return scheme;
}

+ (void)switchColorScheme
{
    ColorScheme scheme = ![self getCurrentColorScheme];
    [[NSUserDefaults standardUserDefaults] setInteger:scheme forKey:@"colorScheme"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchColorScheme" object:nil];
}

+ (UIColor*)getBorderColor
{
    return [self getCurrentColorScheme] == kColorSchemeDark ? [UIColor whiteColor] : [UIColor grayColor];
}

+ (UIColor*)getTextColor
{
    return [self getCurrentColorScheme] == kColorSchemeDark ? [UIColor whiteColor] : [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
}

+ (UIColor*)getBgColor
{
    return [self getCurrentColorScheme] == kColorSchemeDark ? [self getDarkBlueColor] : [UIColor whiteColor];
}

+ (UIImage*)getComboBoxImage
{
    NSString* name = [self getCurrentColorScheme] == kColorSchemeDark ? @"combo" : @"comboWhite";
    return [UIImage imageNamed:name];
}

+ (UIImage*)getComboBoxLongImage
{
    NSString* name = [self getCurrentColorScheme] == kColorSchemeDark ? @"comboLong" : @"comboLongWhite";
    return [UIImage imageNamed:name];
}

+ (UIImage*)getCheckboxImage:(BOOL)checked
{
    return [UIImage imageNamed:(checked ? @"cb_light_marked" : @"cb_light_unmarked")];
}

+ (UIImage*)reportHomeScreenBg
{
    return [UIImage imageNamed:[self getCurrentColorScheme] == kColorSchemeDark ? @"newRapportWithArt" : @"newRapportWithArtWhite"];
}

+ (UIImage*)getRadioButtonImage:(BOOL)checked
{
    if ([self getCurrentColorScheme] == kColorSchemeDark) {
        return [UIImage imageNamed:(checked ? @"RadioAcceptedDark" : @"RadioUnacceptedwhite")];
    }
    return [UIImage imageNamed:(checked ? @"radioCheckedBlue" : @"radioBlue")];
}

+ (UIImage*)getRadioButtonImageForQuestions:(BOOL)checked
{
    if ([self getCurrentColorScheme] == kColorSchemeDark) {
        return [UIImage imageNamed:(checked ? @"radioGreen" : @"RadioUnacceptedwhite")];
    }
    return [UIImage imageNamed:(checked ? @"radioLightBlueSelected" : @"radioLightBlue")];
}

+ (UIColor*)getFooterPagingTextColor
{
    return [self getCurrentColorScheme] == kColorSchemeDark ? [UIColor colorWithRed:202.0f/255.0f green:210.0f/255.0f blue:43.0f/255.0f alpha:1.0f] : [self getDarkBlueColor];
}

+ (UIImage*)getTextFieldCancelImage
{
    NSString *filename = [self getCurrentColorScheme] == kColorSchemeDark ? @"clear-icon" : @"clear-icon-dark";
    return [UIImage imageNamed:filename];
}

+ (UIColor*)getBorderColorDisabled
{
    return [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1];
}

+ (void)setBorderSelected:(UIView*)v yes:(BOOL)yes
{
    UIColor *borderColor = yes ? [self getLightBlueColor] : [self getBorderColor];
    v.layer.borderColor = borderColor.CGColor;
}

+ (void)setOverlayBorderSelected:(UIView*)v yes:(BOOL)yes
{
    UIColor *borderColor = yes ? [self getLightBlueColor] : [UIColor colorWithRed:154.0f/255.0f green:165.0f/255.0f blue:172.0f/255.0f alpha:1];
    v.layer.borderColor = borderColor.CGColor;
}

+ (void)updateView:(UIView *)view
{
    [self updateStyles:view];
    
    for (UIView *childView in view.subviews) {
        [self updateView:childView];
    }
}

+ (void)updateStyles:(UIView*)view
{
    UIColor *textColor = [self getTextColor];
    UIColor *borderColor = [self getBorderColor];
    
    // setup labels
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        label.textColor = textColor;
    }
    
    //setup textfields
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField*)view;
        textField.borderStyle = UITextBorderStyleNone;
        textField.layer.masksToBounds = YES;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = borderColor.CGColor;
        textField.textColor = textColor;
        // http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    //setup textviews
    if ([view isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView*)view;
        textView.layer.borderColor = borderColor.CGColor;
        textView.layer.borderWidth = textView.tag == kTagDoNotGiveBorder ? 0 : 1;
        textView.textColor = textColor;
    }
    
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)view;
        if (imageView.tag == kTagComboBox) {
            [imageView setImage:[self getComboBoxImage]];
        }
        if (imageView.tag == kTagComboBoxLong) {
            [imageView setImage:[self getComboBoxLongImage]];
        }
    }
}

@end