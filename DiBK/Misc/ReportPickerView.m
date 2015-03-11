//
//  ReportPickerView.m
//  DiBK
//
//  Created by david stummer on 30/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

// We subclass UIPickerView here to add the didTap property. We can use this property to
// determine (in the client code) whether to dismiss the popover or not.


#import "ReportPickerView.h"

@implementation ReportPickerView
@synthesize didTap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        gestureRecognizer.delegate =self;
        [self addGestureRecognizer:gestureRecognizer];
        _didTap = NO;
    }
    return self;
}

-(BOOL)didTap
{
    if (_didTap) {
        _didTap = NO;
        return YES;
    }
    
    return NO;
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
    _didTap = YES;
    if ([self userClickedOnAlreadySelectedRow]) {
        [self.delegate pickerView:self didSelectRow:[self selectedRowInComponent:0] inComponent:0];
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}


@end