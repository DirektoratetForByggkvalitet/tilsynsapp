//
//  ReportDatePickerView.m
//  DiBK
//
//  Created by david stummer on 07/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ReportDatePickerView.h"

@implementation ReportDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

// if the user clicked on the already selected component, we need to send the didSelectRow event
- (BOOL)userClickedOnAlreadySelectedRow
{
    // http://gonecoding.com/post/23925632233/adding-tap-to-select-to-a-uipickerview-in-ios
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect selectorFrame = CGRectInset(self.frame, 0.0, self.bounds.size.height * 0.85 / 2.0 );
    return CGRectContainsPoint(selectorFrame, touchPoint);
}

-(void)pickerTapped:(id)sender
{
    if ([self userClickedOnAlreadySelectedRow]) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
