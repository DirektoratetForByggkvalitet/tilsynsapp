//
//  EditOverlayView.m
//  DiBK
//
//  Created by david stummer on 07/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EditOverlayView.h"
#import "QuestionView.h"
#import "Question.h"
#import "AppUtils.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation EditOverlayView
@synthesize questionView;

static int POPOVER_HEIGHT = 600;
static int POPOVER_TOP_MARGIN = 99;
static int POPOVER_HORIZ_MARGIN = 75;
static int POPOVER_WIDTH = 638;
static int LEFT_MARGIN = 40;
static int TOP_MARGIN = 45;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController*)c
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        controller = c;
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
        POPOVER_TOP_MARGIN += frame.origin.y;
        POPOVER_HORIZ_MARGIN += frame.origin.x;
        
        // add the popover window
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
        [closeButton setTitle:@"Ferdig" forState:UIControlStateNormal];
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
        [lblEdit setText:[LabelManager getTextForParent:@"general" Key:@"edit"]];
        [lblEdit sizeToFit];
        [self addSubview:lblEdit];
        
        // remove question subtitle
        int rqXOffset = titleXOffset;
        int rqYOffset = titleYOffset+titleHeight+10;
        int rqWidth = 400;
        int rqHeight = 50;
        UILabel *removeQuestionSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(rqXOffset, rqYOffset, rqWidth, rqHeight)];
        removeQuestionSubtitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        removeQuestionSubtitle.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        removeQuestionSubtitle.numberOfLines = 0;
        removeQuestionSubtitle.text = [LabelManager getTextForParent:@"chapter_three_question_dialog" Key:@"text_1"];
        [removeQuestionSubtitle sizeToFit];
        [self addSubview:removeQuestionSubtitle];
        
        // our current question
        int qXOffset = titleXOffset;
        int qYOffset = titleYOffset+titleHeight+40;
        int qWidth = 500;
        int qHeight = 50;
        lblSelectedQuestion = [[UILabel alloc] initWithFrame:CGRectMake(qXOffset, qYOffset, qWidth, qHeight)];
        lblSelectedQuestion.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
        lblSelectedQuestion.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        lblSelectedQuestion.numberOfLines = 0;
        [self addSubview:lblSelectedQuestion];
        
        int deleteButtonXOffset = qXOffset;
        int deleteButtonYOffset = qYOffset+qHeight+9;
        int deleteButtonWidth = 170;
        int deleteButtonHeight = 38;
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(deleteButtonXOffset, deleteButtonYOffset, deleteButtonWidth, deleteButtonHeight)];
        [deleteButton setBackgroundColor:[UIColor blackColor]];
        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"HelveticeNeue" size:15]];
        [deleteButton setTitle:[LabelManager getTextForParent:@"chapter_three_question_dialog" Key:@"text_2"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton layoutSubviews];
        // move button and text
        // http://stackoverflow.com/questions/2515998/iphone-uibutton-image-position
        deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, -deleteButton.imageView.frame.size.width, 0, deleteButton.imageView.frame.size.width);
        deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, deleteButton.titleLabel.frame.size.width, 0, -deleteButton.titleLabel.frame.size.width);
        [self addSubview:deleteButton];
        
        int addNewXOffset = deleteButtonXOffset;
        int addNewYOffset = deleteButtonYOffset+deleteButtonHeight+30;
        int addNewWidth = 400;
        int addNewHeight = 50;
        UILabel *addNewLabel = [[UILabel alloc] initWithFrame:CGRectMake(addNewXOffset, addNewYOffset, addNewWidth, addNewHeight)];
        addNewLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        addNewLabel.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        addNewLabel.numberOfLines = 0;
        addNewLabel.text = [LabelManager getTextForParent:@"chapter_three_question_dialog" Key:@"text_3"];
        [addNewLabel sizeToFit];
        [self addSubview:addNewLabel];
        
        int textViewXOffset = addNewXOffset;
        int textViewYOffset = addNewYOffset+addNewHeight-10;
        int textViewWidth = POPOVER_WIDTH-(LEFT_MARGIN*2);
        int textViewHeight = 110;
        textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewXOffset, textViewYOffset, textViewWidth, textViewHeight)];
        textView.layer.borderColor = [UIColor colorWithRed:154.0f/255.0f green:165.0f/255.0f blue:172.0f/255.0f alpha:1].CGColor;
        textView.layer.borderWidth = 2.0f;
        textView.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        textView.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        textView.delegate = self;
        [self addSubview:textView];
        
        // checkboxes
        int cbXOffset = textViewXOffset;
        int cbYOffset = textViewYOffset+textViewHeight+25;
        int cbWidth = 14;
        int cbHeight = 14;
        
        cb1 = [[UIButton alloc] initWithFrame:CGRectMake(cbXOffset, cbYOffset, cbWidth, cbHeight)];
        [cb1 addTarget:self action:@selector(cb1Clicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cb1];
        
        int cbLabelXOffset = cbXOffset+cbWidth+15;
        int cbLabelYOffset = cbYOffset-18;
        int cbLabelWidth = 300;
        int cbLabelHeight = 50;
        
        UILabel *cb1Label = [[UILabel alloc] initWithFrame:CGRectMake(cbLabelXOffset, cbLabelYOffset, cbLabelWidth, cbLabelHeight)];
        [cb1Label setText:[LabelManager getTextForParent:@"chapter_three_question_dialog" Key:@"text_4"]];
        cb1Label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
        cb1Label.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        [self addSubview:cb1Label];
        
        cbYOffset += cbHeight+20;
        cb2 = [[UIButton alloc] initWithFrame:CGRectMake(cbXOffset, cbYOffset, cbWidth, cbHeight)];
        [cb2 addTarget:self action:@selector(cb2Clicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cb2];
        
        cbLabelYOffset += cbLabelHeight;
        UILabel *cb2Label = [[UILabel alloc] initWithFrame:CGRectMake(cbLabelXOffset, cbLabelYOffset-16, cbLabelWidth, cbLabelHeight)];
        [cb2Label setText:[LabelManager getTextForParent:@"chapter_three_question_dialog" Key:@"text_5"]];
        cb2Label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
        cb2Label.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        [self addSubview:cb2Label];
    }
    
    return self;
}

// refresh the ui controls here
-(void)setQuestionView:(QuestionView *)qv
{
    questionView = qv;
    NSString *questionText = [questionView getQuestion].questionName;
    lblSelectedQuestion.text = questionText;
    
    [self cb1Clicked];
    
    textView.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textView resignFirstResponder];
    
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

-(void)exit
{
    [textView resignFirstResponder];
    [self setHidden:TRUE];
}

-(void)deleteClicked
{
    [self exit];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionView_DeleteQuestion" object:questionView];
}

-(void)closeClicked
{
    [self exit];
    
    NSString *newQuestion = textView.text;
    if (![newQuestion isEqualToString:@""]) {
        NSDictionary *dict = @{ @"questionName" : newQuestion, @"insertBefore" : [NSNumber numberWithBool:cb1Selected] };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionView_AddQuestion" object:questionView userInfo:dict];
    }
}

-(void)cb1Clicked
{
    cb1Selected = TRUE;
    [self cbClicked];
}

-(void)cb2Clicked
{
    cb1Selected = FALSE;
    [self cbClicked];
}

-(void)cbClicked
{
    [cb2 setImage:[self getCheckboxImage:!cb1Selected] forState:UIControlStateNormal];
    [cb1 setImage:[self getCheckboxImage:cb1Selected] forState:UIControlStateNormal];
}

- (UIImage*)getCheckboxImage:(BOOL)checked
{
    return [UIImage imageNamed:(checked ? @"radioCheckedBlue" : @"radioBlue")];
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
