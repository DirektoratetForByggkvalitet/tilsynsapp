//
//  PDFPage2.m
//  DiBK
//
//  Created by david stummer on 04/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFPage2.h"
#import "AppData.h"
#import "Template.h"
#import "AuditType.h"
#import "Checklist.h"
#import "PDFUtils.h"
#import "Question.h"
#import "PDFPage2QuestionView.h"
#import "LabelManager.h"

@implementation PDFPage2

- (id)initWitAuditType:(AuditType*)at checklist:(Checklist*)cl template:(Template*)tpl isFirstPage:(BOOL)fp
{
    self = [super initWithNibName:@"PDFPage2" bundle:nil];
    if (self) {
        auditType = at;
        checklist = cl;
        template = tpl;
        firstPage = fp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = [NSString stringWithFormat:@"%@ – %@", [LabelManager getTextForParent:@"pdf_report" Key:@"checklists_title"], template.templateName];
    if (!firstPage) {
        [PDFUtils hideViewAndShiftOthersUp:lblTitle inPage:self.view];
    }
    
    lblSubtitle.text = [NSString stringWithFormat:@"%@ - %@", checklist.checklistName, auditType.auditTypeName];
    
    // load question views
    [self loadQuestionViews];
    
    [PDFUtils refitLabelAndShiftOtherViewsDown:lblSubtitle inPage:self.view];
    
    // push page down to fit
    [PDFUtils stretchDownPage:self.view];
}

-(PDFPage2QuestionView*)loadQuestionView
{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PDFPage2QuestionView" owner:self options:nil];
    PDFPage2QuestionView *v;
    for (id object in bundle) {
        if ([object isKindOfClass:[PDFPage2QuestionView class]])
            v = (PDFPage2QuestionView*)object;
    }
    assert(v);
    return v;
}

+ (NSArray*)getAllQuestionsWhichHaveBeenAnsweredForAuditType:(AuditType*)auditType
{
    NSArray *allQuestions = [[auditType.questions allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Question *first = (Question*)a;
        Question *second = (Question*)b;
        return [first.questionIndex compare:second.questionIndex];
    }];
    
    // filter out questions with 'none' set for the answer
    allQuestions = [allQuestions objectsAtIndexes:[allQuestions indexesOfObjectsPassingTest:^BOOL(Question* q, NSUInteger idx, BOOL *stop) {
        return ![q.answer isEqualToString:@"none"];
    }]];
    
    return allQuestions;
}

- (void)adjustOriginY:(int)y forView:(UIView*)view
{
    CGRect f = view.frame;
    f.origin.y = y;
    view.frame = f;
}

- (void)loadQuestionViews
{
    NSArray *questions = [PDFPage2 getAllQuestionsWhichHaveBeenAnsweredForAuditType:auditType];
    int y = lblSubtitle.frame.origin.y+lblSubtitle.frame.size.height;
    for (Question *q in questions) {
        PDFPage2QuestionView *qv = [self loadQuestionView];
        qv.tag = 99;
        qv.question = q;
        [self.view addSubview:qv];
        [self adjustOriginY:y forView:qv];
        y += qv.frame.size.height;
    }
}

+ (NSArray*)getAuditTypes
{
    NSArray *templates = [[AppData getInstance] fetchTemplates];
    NSMutableArray *checkedAuditTypes = [[NSMutableArray alloc] init];
    
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
                    [checkedAuditTypes addObject:auditType];
                }
            }
        }
    }
    
    return checkedAuditTypes;
}

+ (NSMutableArray*)getPages
{
    NSArray *auditTypes = [self getAuditTypes];
    NSMutableArray *pages = [NSMutableArray new];
    NSMutableArray *templates = [NSMutableArray new];
    for (AuditType *at in auditTypes) {
        NSArray *questionsAnswered = [PDFPage2 getAllQuestionsWhichHaveBeenAnsweredForAuditType:at];
        if (questionsAnswered.count <= 0) {
            continue;
        }
        Checklist *cl = at.checklist.allObjects[0];
        Template *tpl = cl.template.allObjects[0];
        PDFPage2 *page = [[PDFPage2 alloc] initWitAuditType:at checklist:cl template:tpl isFirstPage:![templates containsObject:tpl]];
        [pages addObject:page.view];
        [templates addObject:tpl];
    }
    return pages;
}

@end