//
//  Chap3QuestionsViewController.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap3ViewController.h"
#import "Chap3View.h"
#import "AppData.h"
#import "ReportHomeViewController.h"
#import "FormScrollView.h"
#import "UtfylingViewController.h"
#import "Template.h"
#import "Checklist.h"
#import "AuditType.h"
#import "CameraOverlayView.h"
#import "CameraImageView.h"
#import "QuestionCommentsView.h"
#import "EditOverlayView.h"
#import "ColorSchemeManager.h"

@implementation Chap3ViewController
@synthesize chap3View = _chap3View, formScrollView;

static BOOL isVisible = false;

+ (void)setVisibility:(BOOL)visibility
{
    isVisible = visibility;
}

+ (BOOL)isVisible
{
    return isVisible;
}

-(id)init
{
    self = [super init];
    if (self) {
        pageVCs = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraIconTapped:) name:@"CameraIcon_Tapped" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraImageViewTapped:) name:@"CameraImageView_Tapped" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionViewSetCommentTapped:) name:@"QuestionView_SetComment" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionViewNewQuestion:) name:@"QuestionView_NewQuestion" object:nil];
    }
    return self;
}

-(void)shutdown
{
    for (UtfylingViewController *vc in pageVCs) {
        [vc shutdown];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadView
{
    _chap3View = [[Chap3View alloc]initWithFrame:[[UIScreen mainScreen]bounds] andController:self];
    self.view = _chap3View;
    
    [_chap3View.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    formScrollView = _chap3View.formScrollView;
    
    [self updateTemplates];

    [_chap3View.rightNav addTarget:self action:@selector(rightNavClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _chap3View.munLabel.text = [[AppData getInstance] getTitle];
    
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"ChapterThree_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"SaveTimerTriggerChap3" object:nil];
}

- (void) startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                              target: self
                                            selector:@selector(doSave)
                                            userInfo: nil repeats:YES];
}

- (void) stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)rightNavClicked
{
    NSLog(@"chapter 3 nav clicked");
    [_chap3View.formScrollView scrollRight];
}

-(void)questionViewNewQuestion:(NSNotification*)note
{
    _chap3View.editOverlayView.hidden = false;
    _chap3View.editOverlayView.questionView = (QuestionView*)note.object;
}

-(void)questionViewSetCommentTapped:(NSNotification*)note
{
    _chap3View.questionCommentsView.hidden = false;
    [_chap3View.questionCommentsView.textView becomeFirstResponder];
    _chap3View.questionCommentsView.questionView = (QuestionView*)note.object;
}

-(void)cameraImageViewTapped:(NSNotification*)note
{
    [_chap3View.cameraOverlayView showPopoverWithViewController:self];
    _chap3View.cameraOverlayView.cameraImageView = (CameraImageView*)note.object;
    [_chap3View.cameraOverlayView start];
}

-(void)cameraIconTapped:(NSNotification*)note
{
    UIButton *cameraButton = (UIButton*)note.object;
    [_chap3View.cameraOverlayView showPopoverWithViewController:self];
    _chap3View.cameraOverlayView.cameraImageView = (CameraImageView*)[note.userInfo objectForKey:@"cameraImageView"];
    [_chap3View.cameraOverlayView startWithActionSheetFrame:cameraButton];
}

- (void)updateTemplates
{
    templates = [[AppData getInstance] fetchTemplates];
    
    for (int i = 0; i < [templates count]; i++) {
        Template *template = [templates objectAtIndex:i];
        NSArray *checklists = [template.checklists allObjects];
        checklists = [checklists sortedArrayUsingComparator:^(Checklist *obj1, Checklist *obj2) {
            return [obj1.checklistId compare:obj2.checklistId];
        }];
        
        for (int j = 0; j < [checklists count]; j++) {
            Checklist *checklist = [checklists objectAtIndex:j];
            
            // sort the audit types array
            NSArray *auditTypes = [[checklist.audiTypes allObjects] sortedArrayUsingComparator:^NSComparisonResult(AuditType *a, AuditType *b) {
                return [a.auditTypeId compare:b.auditTypeId];
            }];
            
            for (int k = 0; k < [auditTypes count]; k++) {
                AuditType *auditType = [auditTypes objectAtIndex:k];
                if (auditType.isChecked) {
                    UtfylingViewController *vc = [[UtfylingViewController alloc] initWithAuditType:auditType];
                    [pageVCs addObject:vc];
                    [self addChildViewController:vc];
                    [vc didMoveToParentViewController:self];
                    [formScrollView addPage:vc.view];
                }
            }
        }
    }
}

- (void)slideIntoView
{
    _chap3View.munLabel.text = [[AppData getInstance] getTitle];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake((self.view.center.x - [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
    }completion:^(BOOL finished) {
        isVisible = true;
    }];
}

- (void)slideOutOfView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake((self.view.center.x + [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
    }completion:^(BOOL finished) {
        isVisible = false;
        [[AppData getInstance] save];
    }];
}

- (void)doSave
{
    NSLog(@"--Save data Chap 3 is being called---");
    [[AppData getInstance] save];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [self slideOutOfView];
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveTimerTriggerChap2" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
