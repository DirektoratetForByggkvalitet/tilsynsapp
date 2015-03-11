//
//  TopView.m
//  DiBK
//
//  Created by david stummer on 16/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "TopView.h"
#import "DetailPageViewController.h"
#import "LabelManager.h"

@implementation TopView

@synthesize viewController, txt1, txt2, txt3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        txt1.placeholder = [LabelManager getTextForParent:@"chapter_one_manager_screen" Key:@"text_1"];
        txt2.placeholder = [LabelManager getTextForParent:@"chapter_one_manager_screen" Key:@"text_2"];
        txt3.placeholder = [LabelManager getTextForParent:@"chapter_one_manager_screen" Key:@"text_3"];
    }
    return self;
}

- (IBAction)removeBtnClicked:(id)sender
{
    [viewController removeTopView:self];
}

@end
