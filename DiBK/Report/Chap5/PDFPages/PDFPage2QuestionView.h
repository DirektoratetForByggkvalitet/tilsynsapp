//
//  PDFPageQuestionView.h
//  DiBK
//
//  Created by david stummer on 05/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface PDFPage2QuestionView : UIView
{
    __weak IBOutlet UILabel *lblQuestionText;
    __weak IBOutlet UILabel *lblQuestionComments;
    __weak IBOutlet UILabel *lblQuestionAnswer;
}

@property (nonatomic, strong) Question *question;

@end
