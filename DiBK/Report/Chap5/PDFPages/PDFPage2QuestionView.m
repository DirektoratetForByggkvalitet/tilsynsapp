//
//  PDFPageQuestionView.m
//  DiBK
//
//  Created by david stummer on 05/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFPage2QuestionView.h"
#import "Question.h"
#import "PDFUtils.h"
#import "LabelManager.h"
#import "Photo.h"
#import "ImageUtils.h"

@implementation PDFPage2QuestionView
@synthesize question;

- (void)adjustOriginY:(int)y forView:(UIView*)view
{
    CGRect f = view.frame;
    f.origin.y = y;
    view.frame = f;
}

-(void)setQuestion:(Question *)q
{
    question = q;
    
    NSString *answer = question.answer;
    if ([answer isEqualToString:@"maybe"]) {
        answer = @"inpart";
    }
    lblQuestionAnswer.text = [LabelManager getTextForParent:@"pdf_report" Key:answer];
    
    lblQuestionText.numberOfLines = 0;
    lblQuestionText.text = [NSString stringWithFormat:@"%@ %@", question.questionIndex.stringValue, question.questionName];
    [PDFUtils refitLabelAndShiftOtherViewsDown:lblQuestionText inPage:self];
    
    lblQuestionComments.numberOfLines = 0;
    lblQuestionComments.text = question.questionComment;
    
    int y = lblQuestionComments.frame.origin.y+lblQuestionComments.frame.size.height+20;
    for (Photo *photo in question.photos) {
        if (photo.id) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(60, y, 200, 180)];
            iv.tag = 99;
            iv.image = [ImageUtils retrieveFullsizeImageFromFileForID:photo.id];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:iv];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(280, y, 280, 20)];
            lbl.numberOfLines = 0;
            lbl.font = [UIFont systemFontOfSize:11];
            [self addSubview:lbl];
            lbl.text = photo.text;
            
            if ((![lbl.text isEqual:[LabelManager getTextForParent:@"chapter_three_photo_dialog" Key:@"text_1"]]) && lbl.text.length > 0) {
                [PDFUtils refitLabelAndShiftOtherViewsDown:lbl inPage:self];
            } else {
                lbl.hidden = YES;
            }
            int biggest = MAX(iv.frame.size.height, lbl.frame.size.height);
            y += biggest + 20;
        }
    }
    
    BOOL commentExists = lblQuestionComments.text && lblQuestionComments.text.length > 0;
    if (commentExists) {
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblQuestionComments inPage:self];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblQuestionComments inPage:self];
    }
    
    [PDFUtils stretchDownPage:self];
}

@end