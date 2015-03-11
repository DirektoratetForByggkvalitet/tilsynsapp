//
//  QuestionCommentsView.m
//  DiBK
//
//  Created by david stummer on 06/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QuestionCommentsView.h"
#import "QuestionView.h"
#import "AppUtils.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation QuestionCommentsView
@synthesize questionView;

static int POPOVER_HEIGHT = 400;
static int POPOVER_TOP_MARGIN = 99;
static int POPOVER_HORIZ_MARGIN = 75;
static int POPOVER_WIDTH = 638;
static int LEFT_MARGIN = 40;
static int TOP_MARGIN = 45;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController *)c
{
    self = [super initWithFrame:frame];
    if (self) {
        controller = c;
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
        polaroid = [[UIView alloc] initWithFrame:CGRectMake(POPOVER_HORIZ_MARGIN, POPOVER_TOP_MARGIN, POPOVER_WIDTH, POPOVER_HEIGHT)];
        [polaroid setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:polaroid];
        
        // add the footer to the popover window
        int footerHeight = 80;
        int footerYOffset = (POPOVER_HEIGHT+POPOVER_TOP_MARGIN) - footerHeight;
        UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(POPOVER_HORIZ_MARGIN, footerYOffset, POPOVER_WIDTH, footerHeight)];
        [footer setImage:[UIImage imageNamed:@"editFooter"]];
        [self addSubview:footer];
        
        // add the close button to the footer
        int closeButtonWidth = 100;
        int closeButtonHeight = 40;
        int closeButtonXOffset = (POPOVER_HORIZ_MARGIN+POPOVER_WIDTH) - (closeButtonWidth+20);
        int closeButtonYOffset = (POPOVER_HEIGHT+POPOVER_TOP_MARGIN) - (footerHeight/2 + closeButtonHeight/2);
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(closeButtonXOffset, closeButtonYOffset, closeButtonWidth, closeButtonHeight)];
        [closeButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [closeButton setTitle:[LabelManager getTextForParent:@"general" Key:@"close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        // add the title
        int titleWidth = 200;
        int titleHeight = 50;
        int titleXOffset = POPOVER_HORIZ_MARGIN+LEFT_MARGIN;
        int titleYOffset = POPOVER_TOP_MARGIN+TOP_MARGIN;
        UIImageView *pencilIcon = [[UIImageView alloc] initWithFrame:CGRectMake(titleXOffset, titleYOffset, 30, 30)];
        [pencilIcon setImage:[UIImage imageNamed:@"pencilDark"]];
        [self addSubview:pencilIcon];
        UILabel *lblEdit = [[UILabel alloc] initWithFrame:CGRectMake(titleXOffset+40, titleYOffset-3, titleWidth, titleHeight)];
        lblEdit.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
        lblEdit.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        lblEdit.numberOfLines = 0;
        [lblEdit setText:[LabelManager getTextForParent:@"chapter_three_screen" Key:@"text_2"]];
        [lblEdit sizeToFit];
        [self addSubview:lblEdit];
        
        // text view
        int textViewXOffset = titleXOffset;
        int textViewYOffset = titleYOffset+titleHeight+10;
        int textViewWidth = POPOVER_WIDTH-(LEFT_MARGIN*2);
        int textViewHeight = 200;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewXOffset, textViewYOffset, textViewWidth, textViewHeight)];
        _textView.layer.borderColor = [UIColor colorWithRed:154.0f/255.0f green:165.0f/255.0f blue:172.0f/255.0f alpha:1].CGColor;
        _textView.layer.borderWidth = 2.0f;
        _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        _textView.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        _textView.delegate = self;
        [self addSubview:_textView];
    }
    return self;
}

-(void)setQuestionView:(QuestionView *)qv
{
    questionView = qv;
    _textView.text = [questionView getQuestionComment];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i<[touchesArray count]; i++)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        
        if (!CGRectContainsPoint(polaroid.frame, point)) {
            [self exit];
            return;
        }
    }
}

-(void)closeClicked
{
    [_textView resignFirstResponder];
    [self exit];
}

- (void)exit
{
    [questionView setQuestionComment:_textView.text];
    [self setHidden:true];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [ColorSchemeManager setOverlayBorderSelected:textView yes:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [ColorSchemeManager setOverlayBorderSelected:textView yes:NO];
}

@end
