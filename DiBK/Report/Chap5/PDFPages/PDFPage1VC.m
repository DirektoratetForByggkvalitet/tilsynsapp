//
//  PDFPage1.m
//  DiBK
//
//  Created by david stummer on 02/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFPage1VC.h"
#import "AppData.h"
#import "Rapport.h"
#import "Chapter1Info.h"
#import "LabelManager.h"
#import "Manager.h"
#import "PDFUtils.h"

@implementation PDFPage1VC

- (id)initWithEmblem:(UIImage*)emblem
{
    self = [super initWithNibName:@"PDFPage1VC" bundle:nil];
    if (self) {
        _emblem = emblem;
    }
    return self;
}

- (void)viewDidLoad
{
    emblemView.image = _emblem;
    
    AppData *appData = [AppData getInstance];
    Rapport *currentReport = appData.currentReport;
    Chapter1Info *chapter1Info = currentReport.chapter1Info;
    
    lblTitle.text = [LabelManager getTextForParent:@"pdf_report" Key:@"title"];
    lblKommune.text = [NSString stringWithFormat:@"%@ KOMMUNE", [chapter1Info.kommune uppercaseString]];
    lblEtter.text = [LabelManager getTextForParent:@"pdf_report" Key:@"subtitle"];
    
    if (!currentReport.dateCompletedStr || currentReport.dateCompletedStr.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblReportDate inPage:self.view];
    } else {
        lblReportDate.text = [NSString stringWithFormat:@"%@ %@", [LabelManager getTextForParent:@"pdf_report" Key:@"report_date"], currentReport.dateCompletedStr];
    }
    
    //Remove (temp) from filename if it's set
    NSString* str = [NSString stringWithFormat:@"%@ %@", [LabelManager getTextForParent:@"pdf_report" Key:@"case_no"], chapter1Info.kommune_sakanr];
    NSString* result;
    NSRange replaceRange = [str rangeOfString:@"(temp)"];
    if (replaceRange.location != NSNotFound){
        result = [str stringByReplacingCharactersInRange:replaceRange withString:@""];
        lblSaksnmr.text = result;
    } else {
        lblSaksnmr.text = chapter1Info.kommune_sakanr;
    }
    

    lblTilsynetGjelder.text = chapter1Info.rapporten_gjelder;
    if (!lblTilsynetGjelder.text || lblTilsynetGjelder.text.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblTilsynetGjelder inPage:self.view];
    }
    
    lblFortattTitle.text = [NSString stringWithFormat:@"%@", [LabelManager getTextForParent:@"pdf_report" Key:@"check_date"]];
    lblFortatt.text = chapter1Info.datoFortatt;
    if (!lblFortatt.text || lblFortatt.text.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblFortatt inPage:self.view];
        lblFortatt.hidden = lblFortattTitle.hidden = YES;
    } else {
        // change width of title (but not height) and adjust the text accordingly
        int height = lblFortattTitle.frame.size.height;
        [lblFortattTitle sizeToFit];
        [PDFUtils setHeight:height forView:lblFortattTitle];
        [PDFUtils setX:lblFortattTitle.frame.origin.x+lblFortattTitle.frame.size.width+10 forView:lblFortatt];
    }
    
    lblTilsynTitle.text = [NSString stringWithFormat:@"%@", [LabelManager getTextForParent:@"pdf_report" Key:@"leader"]];
    lblTilsyn.text = currentReport.rapportName;
    if (!lblTilsyn.text || lblTilsyn.text.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblTilsyn inPage:self.view];
        lblTilsyn.hidden = lblTilsynTitle.hidden = YES;
    } else {
        // change width of title (but not height) and adjust the text accordingly
        int height = lblTilsynTitle.frame.size.height;
        [lblTilsynTitle sizeToFit];
        [PDFUtils setHeight:height forView:lblTilsynTitle];
        [PDFUtils setX:lblTilsynTitle.frame.origin.x+lblTilsynTitle.frame.size.width+10 forView:lblTilsyn];
    }
    
    lblAdresse.text = chapter1Info.stedig_tilsyn_varslet;
    if (!lblAdresse.text || lblAdresse.text.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblAdresse inPage:self.view];
    }
    
    NSMutableString *gnrStr = [NSMutableString new];
    if (chapter1Info.gnr && chapter1Info.gnr.length > 0) {
        NSString *gnr = [LabelManager getTextForParent:@"pdf_report" Key:@"gnr"];
        [gnrStr appendString:[NSString stringWithFormat:@"%@ %@", gnr, chapter1Info.gnr]];
    }
    if (chapter1Info.bnr && chapter1Info.bnr.length > 0) {
        NSString *bnr = [LabelManager getTextForParent:@"pdf_report" Key:@"bnr"];
        [gnrStr appendString:[NSString stringWithFormat:@" %@ %@", bnr, chapter1Info.bnr]];
    }
    if (chapter1Info.fnr && chapter1Info.fnr.length > 0) {
        NSString *fnr = [LabelManager getTextForParent:@"pdf_report" Key:@"fnr"];
        [gnrStr appendString:[NSString stringWithFormat:@" %@ %@", fnr, chapter1Info.fnr]];
    }
    if (chapter1Info.snr && chapter1Info.snr.length > 0) {
        NSString *snr = [LabelManager getTextForParent:@"pdf_report" Key:@"snr"];
        [gnrStr appendString:[NSString stringWithFormat:@" %@ %@", snr, chapter1Info.snr]];
    }
    lblGnrEtc.text = gnrStr;
    if (!lblGnrEtc.text || lblGnrEtc.text.length <= 0) {
        [PDFUtils hideViewAndShiftOthersUp:lblGnrEtc inPage:self.view];
    }
    
    lblKommentar.text = chapter1Info.kommentar;
    if (lblKommentar.text && lblKommentar.text.length > 0) {
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblKommentar inPage:self.view];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblKommentar inPage:self.view];
    }
    
    lblTitleBackgrunn.text = [LabelManager getTextForParent:@"pdf_report" Key:@"background"];
    
    // check boxes
    text_14.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_14"];
    [cb_14 setImage:[self getCheckboxImage:chapter1Info.p1cb1.intValue]];
    text_15.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_15"];
    [cb_15 setImage:[self getCheckboxImage:chapter1Info.p1cb2.intValue]];
    text_16.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_16"];
    [cb_16 setImage:[self getCheckboxImage:chapter1Info.p1cb3.intValue]];
    text_17.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_17"];
    [cb_17 setImage:[self getCheckboxImage:chapter1Info.p1cb4.intValue]];
    text_18.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_18"];
    [cb_18 setImage:[self getCheckboxImage:chapter1Info.p1cb5.intValue]];
    text_19.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_19"];
    [cb_19 setImage:[self getCheckboxImage:chapter1Info.p1cb6.intValue]];
    text_20.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_20"];
    [cb_20 setImage:[self getCheckboxImage:chapter1Info.p1cb7.intValue]];
    
    // annet
    lblAnnet.text = chapter1Info.annet;
    if (lblAnnet.text && lblAnnet.text.length > 0) {
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblAnnet inPage:self.view];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblAnnet inPage:self.view];
    }
    
    // Managers (deltakere)
    NSArray *allManagers = chapter1Info.managers.allObjects;
    // b, c, a, title (OLD)
    // a, b, c      title
    CGRect lblFrame = lblDeltakere.frame;
    UILabel *lbl;
    lblDeltakere.hidden = YES;
    for (Manager *m in allManagers) {
        
        NSMutableString *managerStr = [NSMutableString new];
        if (m.a && m.a.length) {
            [managerStr appendString:m.a];
        }
        if ((m.a && m.a.length) && ((m.c && m.c.length) || (m.b && m.b.length))) {
            [managerStr appendString:@", "];
        }
        if (m.b && m.b.length) {
            [managerStr appendString:m.b];
        }
        if (m.c && m.c.length) {
            [managerStr appendString:@"    "];
            [managerStr appendString:m.c];
        }
        
        lbl = [[UILabel alloc] initWithFrame:lblFrame];
        lbl.font = lblDeltakere.font;
        lbl.text = managerStr;
        [self.view addSubview:lbl];
        
        if (m.title && m.title.length) {
            CGRect f = lblFrame;
            f.origin.x = self.view.frame.size.width - 200;
            f.size.width = 180;
            UILabel *lblRight = [[UILabel alloc] initWithFrame:f];
            lblRight.textAlignment = UITextAlignmentRight;
            lblRight.font = lblTilsyn.font;
            lblRight.text = m.title;
            [self.view addSubview:lblRight];
        }
        
        CGRect tmpLblFrame = lblFrame;
        tmpLblFrame.origin.y += 19;
        lblFrame = tmpLblFrame;
        
        [PDFUtils shiftOtherViewsFromPoint:lbl.frame.origin.y downBy:12 inPage:self.view];
    }
    if (lbl) {
        lblTitleDeltakere.text = [LabelManager getTextForParent:@"pdf_report" Key:@"participants"];
        [PDFUtils shiftOtherViewsFromPoint:lbl.frame.origin.y downBy:10 inPage:self.view];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblTitleDeltakere inPage:self.view];
        [PDFUtils hideViewAndShiftOthersUp:lblDeltakere inPage:self.view];
    }
    
    // status i byggesaken check boxes
    lblTitleStatus.text = @"Status i byggesaken";
    text_25.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_25"];
    [cb_25 setImage:[self getCheckboxImage:chapter1Info.p2cb1.intValue]];
    text_26.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_26"];
    [cb_26 setImage:[self getCheckboxImage:chapter1Info.p2cb2.intValue]];
    text_27.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_27"];
    [cb_27 setImage:[self getCheckboxImage:chapter1Info.p2cb3.intValue]];
    text_28.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_28"];
    [cb_28 setImage:[self getCheckboxImage:chapter1Info.p2cb4.intValue]];
    text_29.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_29"];
    [cb_29 setImage:[self getCheckboxImage:chapter1Info.p2cb5.intValue]];
    text_30.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_30"];
    [cb_30 setImage:[self getCheckboxImage:chapter1Info.p2cb6.intValue]];
    text_31.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_31"];
    [cb_31 setImage:[self getCheckboxImage:chapter1Info.p2cb7.intValue]];
    text_32.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_32"];
    [cb_32 setImage:[self getCheckboxImage:chapter1Info.p2cb8.intValue]];
    text_33.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_33"];
    [cb_33 setImage:[self getCheckboxImage:chapter1Info.p2cb9.intValue]];
    text_34.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_34"];
    [cb_34 setImage:[self getCheckboxImage:chapter1Info.p2cb10.intValue]];
    text_35.text = [LabelManager getTextForParent:@"chapter_one_screen" Key:@"text_35"];
    [cb_35 setImage:[self getCheckboxImage:chapter1Info.p2cb11.intValue]];
    
    // tiltaket
    if (chapter1Info.p2cb12.intValue && chapter1Info.titakenEr && chapter1Info.titakenEr.length) {
        NSString *project_is = [LabelManager getTextForParent:@"pdf_report" Key:@"project_is"];
        NSString *wo_permit = [LabelManager getTextForParent:@"pdf_report" Key:@"wo_permit"];
        lblTitaket.text = [NSString stringWithFormat:@"%@ %@ %@", project_is, chapter1Info.titakenEr, wo_permit];
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblTitaket inPage:self.view];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblTitaket inPage:self.view];
    }
    
    // andrea kommnentarer
    if (chapter1Info.andreKommentarer && chapter1Info.andreKommentarer.length) {
        lblAndreKommentarer.text = chapter1Info.andreKommentarer;
        [PDFUtils refitLabelAndShiftOtherViewsDown:lblAndreKommentarer inPage:self.view];
    } else {
        [PDFUtils hideViewAndShiftOthersUp:lblAndreKommentarer inPage:self.view];
    }
    
    // push down page height
    [PDFUtils stretchDownPage:self.view];
}

- (UIImage*)getCheckboxImage:(BOOL)checked
{
    return [UIImage imageNamed:(checked ? @"cb_dark_marked" : @"cb_dark_unmarked")];
}

+ (UIView*)getPageWithEmblem:(UIImage*)emblem
{
    PDFPage1VC *vc = [[PDFPage1VC alloc] initWithEmblem:emblem];
    return vc.view;
}

@end