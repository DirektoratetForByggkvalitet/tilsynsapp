//
//  Chap4View.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap4View.h"
#import "LabelManager.h"

@implementation Chap4View
@synthesize navBarView = _navBarView;
@synthesize backButton = _backButton;
@synthesize munLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 103.0f)];
        [_navBarView setBackgroundColor:[UIColor colorWithRed:81.0f/255.0f green:114.0f/255.0f blue:170.0f/255.0f alpha:1.0f]];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(9, -2, 35.5f, 103.0f)];
        [_backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(_backButton.frame.origin.x + _backButton.frame.size.width + 25.0f, 28.0f, 400.0f, 50.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_1"]];
        
        UILabel* _municipalityLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, 730.0f, 40.0f)];
        [_municipalityLabel setBackgroundColor:[UIColor clearColor]];
        [_municipalityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:19.0f]];
        [_municipalityLabel setTextColor:[UIColor whiteColor]];
        [_municipalityLabel setTextAlignment:UITextAlignmentRight];
        [_municipalityLabel setText:@"08/1516 Fjordalleen 16"];
        munLabel = _municipalityLabel;
        
        [self addSubview:_navBarView];
        [self addSubview:_backButton];
        [self addSubview:label];
        [self addSubview:_municipalityLabel];
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}
@end