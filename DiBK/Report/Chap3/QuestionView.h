//
//  QuestionView.h
//  DiBK
//
//  Created by david stummer on 30/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question, CameraImageView, UtfylingViewController;

@interface QuestionView : UIView
{
    Question *question;
    
    __weak IBOutlet CameraImageView *img1;
    __weak IBOutlet CameraImageView *img2;
    __weak IBOutlet CameraImageView *img3;
    __weak IBOutlet CameraImageView *img4;
    __weak IBOutlet CameraImageView *img5;
    __weak IBOutlet UIButton *btnKommentarer;
    __weak IBOutlet UIButton *btnLegg;
    __weak IBOutlet UIButton *btnMaybe;
    __weak IBOutlet UIButton *btnNo;
    __weak IBOutlet UIButton *btnYes;
    __weak IBOutlet UITextView *tvQuestion;
    __weak IBOutlet UIButton *lblInfo;
    __weak IBOutlet UIButton *lblPen;
    __weak IBOutlet UIButton *speechIcon;
}

@property (weak, nonatomic) IBOutlet UIButton *cameraIcon;
@property (nonatomic, strong) UtfylingViewController* controller;
@property (weak, nonatomic) IBOutlet UILabel *divider;
@property (nonatomic) BOOL expanded;
@property (weak, nonatomic) IBOutlet UIButton *cbYes;
@property (weak, nonatomic) IBOutlet UIButton *cbMaybe;
@property (weak, nonatomic) IBOutlet UIButton *cbNo;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (IBAction)cameraClicked:(id)sender;
- (IBAction)yesClicked:(id)sender;
- (IBAction)noClicked:(id)sender;
- (IBAction)maybeClicked:(id)sender;
- (IBAction)infoclicked:(id)sender;
- (Question*)getQuestion;
- (void)setQuestion:(Question*)q;
- (IBAction)setComment:(id)sender;
- (NSString*)getQuestionComment;
- (void)setQuestionComment:(NSString*)text;
- (IBAction)newQuestion:(id)sender;
- (void)doExpand;
- (int)getTheHeight;

@end