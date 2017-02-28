//
//  QuestionView.m
//  DiBK
//
//  Created by david stummer on 30/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "QuestionView.h"
#import "Question.h"
#import "CameraImageView.h"
#import "Photo.h"
#import <QuartzCore/QuartzCore.h>
#import "Info.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"
#import "AppData.h"

@implementation QuestionView

@synthesize expanded, cbYes, cbNo, cbMaybe, controller, cameraIcon, divider, numberLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)doExpand
{
    [self setExpanded:true];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionViewUpdated" object:self];
}

- (IBAction)cameraClicked:(id)sender
{
    // find the first empty camera image view and post the 'CameraImageView_Tapped' event. if none of
    // the five views are empty, select the first one.
    NSArray *thumbs = [NSArray arrayWithObjects:img1, img2, img3, img4, img5, nil];
    CameraImageView *cameraImageView = nil;
    for (CameraImageView *civ in thumbs) {
        Photo *photo = civ.photo;
        if (photo.id == nil || [photo.id isEqualToString:@""]) {
            cameraImageView = civ;
            break;
        }
    }
    if (cameraImageView == nil) {
        cameraImageView = img1;
    }
    NSDictionary *dict = @{ @"cameraImageView" : cameraImageView };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraIcon_Tapped" object:cameraIcon userInfo:dict];
}

// we save data here because there have been report of crashes in chapter three,
// so saving data regularly will help to mitigate data loss in the event of a crash
- (IBAction)yesClicked:(id)sender {
    question.answer = @"yes";
    [[AppData getInstance] save];
    [self setChecked];
}

- (IBAction)noClicked:(id)sender {
    question.answer = @"no";
    [[AppData getInstance] save];
    [self setChecked];
}

- (IBAction)maybeClicked:(id)sender {
    question.answer = @"maybe";
    [[AppData getInstance] save];
    [self setChecked];
}

- (IBAction)infoclicked:(id)sender {
    [Info showInfoScreenForQuestion:question];
}

- (void)setExpanded:(BOOL)e
{
    expanded = e;
    NSArray *views = @[img1,img2,img3,img4,img5];
    for (UIView *img in views) {
        img.hidden = !e;
    }
    
    CGRect f = self.frame;
    if (expanded) {
        f.size.height = img1.frame.origin.y+img1.frame.size.height+20;
    } else {
        f.size.height = btnKommentarer.frame.origin.y+btnKommentarer.frame.size.height+10;
    }
    self.frame = f;
}

-(Question*)getQuestion
{
    return question;
}

- (void)alignLabelsWithQuestionTextView
{
    CGRect f = numberLabel.frame;
    f.origin.y = tvQuestion.frame.origin.y + 9;
    numberLabel.frame = f;
    
    CGRect f2 = lblInfo.frame;
    f2.origin.y = tvQuestion.frame.origin.y + 1;
    lblInfo.frame = f2;
    
    CGRect f3 = lblPen.frame;
    f3.origin.y = f2.origin.y+f2.size.height+7;
    lblPen.frame = f3;
    
    NSArray *buttonLabels = @[btnKommentarer,cameraIcon,speechIcon,btnLegg,btnYes,btnNo,btnMaybe,cbMaybe,cbYes,cbNo];
    for (UIView *v in buttonLabels) {
        CGRect f4 = v.frame;
        f4.origin.y += tvQuestion.frame.size.height - 45;
        v.frame = f4;
    }
    
    int y = cameraIcon.frame.origin.y + cameraIcon.frame.size.height + 10;
    CGRect f4 = divider.frame;
    f4.origin.y = y;

    CGRect f5 = self.frame;
    f5.size.height = y;
    self.frame = f5;
}

- (void)setQuestion:(Question*)q
{
    question = q;
    tvQuestion.text = question.questionName;
    
    //http://stackoverflow.com/questions/18884112/dynamic-expand-uitextview-on-ios-7
    // here we also have to reset the width after calling sizeToFit
    // this is because there seems to be a bug on IOS 7 retina display which
    // in some cases pushes some of the text onto a new line
    int oldWidth = tvQuestion.frame.size.width;
    [tvQuestion sizeToFit];
    CGRect frame = tvQuestion.frame;
    frame.size.width = oldWidth;
    tvQuestion.frame = frame;
    [tvQuestion layoutIfNeeded];

    CGRect f = tvQuestion.frame;
    f.size.height = (tvQuestion.contentSize.height);
    tvQuestion.frame = f;
    
    [self alignLabelsWithQuestionTextView];
    [self prepThumbnails];
    [self setExpanded:[question hasAtLeastOnePhoto]];
    [self updateColors];
    [self checkIfFieldIsEmpty:question.questionComment];
}

- (void)updateColors
{
    [ColorSchemeManager updateView:self];
    [self setChecked];
    
    UIColor *textColor = [ColorSchemeManager getTextColor];
    
    NSArray *buttonLabels = @[btnKommentarer,btnLegg,btnYes,btnNo,btnMaybe];
    for (UIButton *btn in buttonLabels) {
        [btn setTitleColor:textColor forState:UIControlStateHighlighted];
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }

    [btnKommentarer setTitle:[LabelManager getTextForParent:@"chapter_three_screen" Key:@"text_2"] forState:UIControlStateNormal];
    [btnLegg setTitle:[LabelManager getTextForParent:@"chapter_three_screen" Key:@"text_3"] forState:UIControlStateNormal];
    [btnYes setTitle:[LabelManager getTextForParent:@"general" Key:@"yes"] forState:UIControlStateNormal];
    [btnNo setTitle:[LabelManager getTextForParent:@"general" Key:@"no"] forState:UIControlStateNormal];
    [btnMaybe setTitle:[LabelManager getTextForParent:@"general" Key:@"maybe"] forState:UIControlStateNormal];
}

-(NSString*)getQuestionComment
{
    return question.questionComment;
}

-(void)setQuestionComment:(NSString *)text
{
    question.questionComment = text;
    [self checkIfFieldIsEmpty:question.questionComment];
}

-(void) checkIfFieldIsEmpty:(NSString*)comment
{
    if(comment == NULL || [comment length] == 0) {
        [btnKommentarer setTitle:[LabelManager getTextForParent:@"chapter_three_screen" Key:@"text_2"] forState:UIControlStateNormal];
    } else {
        [btnKommentarer setTitle:[LabelManager getTextForParent:@"chapter_three_screen" Key:@"comment_added"] forState:UIControlStateNormal];
    }
}

- (IBAction)newQuestion:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionView_NewQuestion" object:self];
}

- (IBAction)setComment:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionView_SetComment" object:self];
}

- (void)prepThumbnails
{
    // each thumb needs to know it's index in order to sync with its corresponding Photo object
    NSArray *thumbs = [NSArray arrayWithObjects:img1, img2, img3, img4, img5, nil];
    NSArray *photos = [question.photos allObjects];
    for (int i = 0; i < 5; i++) {
        CameraImageView *thumb = [thumbs objectAtIndex:i];
        thumb.questionView = self;
        thumb.index = i;
        for (int j = 0; j < [photos count]; j++) {
            Photo *photo = [photos objectAtIndex:j];
            int n = [photo.index integerValue];
            if (n == i) {
                thumb.photo = photo;
                break;
            }
        }
        // push down
        CGRect f = thumb.frame;
        f.origin.y = btnKommentarer.frame.origin.y + btnKommentarer.frame.size.height + 10;
        thumb.frame = f;
    }
}

- (void)setChecked
{
    NSString *answer = question.answer;
    UIImage *radioCheckedImage = [ColorSchemeManager getRadioButtonImageForQuestions:YES];
    UIImage *radioImage = [ColorSchemeManager getRadioButtonImageForQuestions:NO];
    
    [cbYes setBackgroundImage:radioImage forState:UIControlStateNormal];
    [cbNo setBackgroundImage:radioImage forState:UIControlStateNormal];
    [cbMaybe setBackgroundImage:radioImage forState:UIControlStateNormal];
    
    if ([answer isEqualToString:@"yes"]) {
        [cbYes setBackgroundImage:radioCheckedImage forState:UIControlStateNormal];
    }
    if ([answer isEqualToString:@"no"]) {
        [cbNo setBackgroundImage:radioCheckedImage forState:UIControlStateNormal];
    }
    if ([answer isEqualToString:@"maybe"]) {
        [cbMaybe setBackgroundImage:radioCheckedImage forState:UIControlStateNormal];
    }
}

-(int)getTheHeight
{
    return self.frame.size.height;
}

@end
