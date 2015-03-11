//
//  ReportPickerView.h
//  DiBK
//
//  Created by david stummer on 30/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportPickerView : UIPickerView <UIGestureRecognizerDelegate>
{
    UIGestureRecognizer *gestureRecognizer;
    BOOL _didTap;
}
@property (nonatomic) BOOL didTap;
@end