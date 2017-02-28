//
//  ColorScheme.h
//  DiBK
//
//  Created by david stummer on 02/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kColorSchemeDark = 0,
    kColorSchemeLight
}
ColorScheme;

typedef enum
{
    kTagCheckbox = 10,
    kTagComboBox = 11,
    kTagComboBoxLong = 12,
    kTagRadioButton = 13,
    kTagDoNotGiveBorder = 14
}
UITags;

@interface ColorSchemeManager : NSObject

+ (void)switchColorScheme;
+ (ColorScheme)getCurrentColorScheme;
+ (UIColor*)getBorderColor;
+ (UIColor*)getBorderColorDisabled;
+ (UIColor*)getTextColor;
+ (UIColor*)getBgColor;
+ (UIImage*)getComboBoxImage;
+ (UIImage*)getComboBoxLongImage;
+ (UIImage*)getCheckboxImage:(BOOL)checked;
+ (UIImage*)getRadioButtonImage:(BOOL)checked;
+ (UIImage*)getRadioButtonImageForQuestions:(BOOL)checked;
+ (UIImage*)getTextFieldCancelImage;
+ (void)updateView:(UIView*)view;
+ (UIColor*)getFooterPagingTextColor;
+ (void)setBorderSelected:(UIView*)v yes:(BOOL)yes;
+ (void)setOverlayBorderSelected:(UIView*)v yes:(BOOL)yes;
+ (UIImage*)reportHomeScreenBg;
+ (UIColor*)getDarkBlueColor;

@end
