//
//  PDFConclusionPage.m
//  DiBK
//
//  Created by david stummer on 04/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFConclusionPage.h"
#import "LabelManager.h"
#import "AppData.h"
#import "Rapport.h"
#import "Conclusion.h"
#import "Chapter1Info.h"
#import "PDFUtils.h"

@implementation PDFConclusionPage

- (id)init
{
    self = [super initWithNibName:@"PDFConclusionPage" bundle:nil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppData *appData = [AppData getInstance];
    Rapport *currentReport = appData.currentReport;
    Conclusion *conclusion = currentReport.conclusion;
    
    lblTitle.text = [LabelManager getTextForParent:@"pdf_report" Key:@"conclusion"];

    if (!conclusion.combo1 || conclusion.combo1.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblVurderingTitle inPage:self.view];
    } else {
        lblVurderingTitle.text = [NSString stringWithFormat:@"%@ %@", [LabelManager getTextForParent:@"pdf_report" Key:@"judgement"], conclusion.combo1];
    }
    
    if (!conclusion.textview1 || conclusion.textview1.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblVerduringText inPage:self.view];
    } else {
        lblVerduringText.text = conclusion.textview1;
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblVerduringText inPage:self.view];
    }
    
    if (!conclusion.combo2 || conclusion.combo2.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblOppTitle inPage:self.view];
    } else {
        lblOppTitle.text = [NSString stringWithFormat:@"%@ %@", [LabelManager getTextForParent:@"pdf_report" Key:@"followup"], conclusion.combo2];
    }
    
    if (!conclusion.textview2 || conclusion.textview2.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblOppText inPage:self.view];
    } else {
        lblOppText.text = conclusion.textview2;
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblOppText inPage:self.view];
    }
    
    lblJaiNeiTitle.text = [LabelManager getTextForParent:@"chapter_four_screen" Key:@"text_5"];
    // resize this label and push across the ja/nei label which is to the right of it
    int height = lblJaiNeiTitle.frame.size.height;
    [lblJaiNeiTitle sizeToFit];
    [PDFUtils setHeight:height forView:lblJaiNeiTitle];
    [PDFUtils setX:lblJaiNeiTitle.frame.origin.x+lblJaiNeiTitle.frame.size.width+10 forView:lblJaiNeiText];
    
    NSString *answer = conclusion.checkbox;
    if ([answer isEqualToString:@"maybe"]) {
        answer = @"inpart";
    }
    lblJaiNeiText.text = [LabelManager getTextForParent:@"pdf_report" Key:answer];
    
    [PDFUtils stretchDownPage:self.view];
}

+ (UIView*)getPage
{
    PDFConclusionPage *page = [PDFConclusionPage new];
    return page.view;
}

@end