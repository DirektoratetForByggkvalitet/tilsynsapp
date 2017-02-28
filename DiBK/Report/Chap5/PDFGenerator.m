//
//  PDFGenerator.m
//  DiBK
//
//  Created by david stummer on 17/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFGenerator.h"
#import "Chap1ViewController.h"
#import <QuartzCore/QuartzCore.h>
#include "DetailPageViewController.h"
#include "InfoPageViewController.h"
#import "Chap3ViewController.h"
#import "FormScrollView.h"
#import "AppData.h"
#import "Rapport.h"
#import "EmblemFetcher.h"
#import "PDFUtils.h"
#import "AppData.h"
#import "ArchiveListRetriever.h"
#import "PDFPage1VC.h"
#import <CoreText/CoreText.h>
#import "ImageUtils.h"
#import "PDFConclusionPage.h"
#import "PDFPage2.h"
#import "PDFFooterView.h"
#import "Chapter1Info.h"
#import "PDFPageSplitter.h"

@implementation PDFGenerator

- (void)generatePdfWithCallback:(PDFGeneratorCallback)callback
{
    _callback = callback;
    
    EmblemFetcher *emblemFetcher = [[EmblemFetcher alloc] init];
    [emblemFetcher fetchEmblemWithCallback:^(UIImage* image){
        if (!image) {
            NSLog(@"PdfGenerator: Could not download emblem, continuing to generate the report PDF without the emblem.");
        }
        [self continuePdfGenWithIcon:image];
    }];
}

- (NSString*)setReportName
{
    AppData *appData = [AppData getInstance];
    NSString *reportName = [appData getTitle];
    reportName = [appData getUniquePDFFileNameForCurrentReport];
    reportName = [reportName stringByAppendingString:@".pdf"];
    NSLog(@"PdfGenerator: reportName: %@", reportName);
    
    appData.currentReport.pdfFilePath = [[ArchiveListRetriever getDefaultFolderPath] stringByAppendingPathComponent:reportName];
    NSLog(@"PdfGenerator: report file path: %@", appData.currentReport.pdfFilePath);
    
    return appData.currentReport.pdfFilePath;
}

-(PDFFooterView*)loadFooterView
{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PDFFooterView" owner:self options:nil];
    PDFFooterView *v;
    for (id object in bundle) {
        if ([object isKindOfClass:[PDFFooterView class]])
            v = (PDFFooterView*)object;
    }
    assert(v);
    return v;
}

- (void)addFooters:(NSMutableArray*)pages
{
    AppData *appData = [AppData getInstance];
    Rapport *currentReport = appData.currentReport;
    Chapter1Info *chapter1Info = currentReport.chapter1Info;
    
    int i = 1;
    for (UIView *page in pages) {
        PDFFooterView *footerView = [self loadFooterView];
        footerView.lblLeft.text = [NSString stringWithFormat:@"Tilsynsrapport - %@ %@", chapter1Info.kommune_sakanr, chapter1Info.stedig_tilsyn_varslet];
        footerView.lblRight.text = [NSString stringWithFormat:@"%d", i];
        i++;
        footerView.frame = CGRectMake(0, 902, 612, 30);
        [page addSubview:footerView];
        [PDFUtils setHeight:932 forView:page];
    }
}

- (NSMutableArray*)getAllPages:(UIImage*)emblem
{
    NSMutableArray *pages = [NSMutableArray new];
    [pages addObject:[PDFPage1VC getPageWithEmblem:emblem]];
    NSMutableArray *checklistPages = [PDFPage2 getPages];
    for (UIView *page in checklistPages) {
        [pages addObject:page];
    }
    [pages addObject:[PDFConclusionPage getPage]];
    UIView *bigPage = [self appendPages:pages];
    pages = [PDFPageSplitter extractPagesInPage:bigPage];
    [self addFooters:pages];
    return pages;
}

- (UIView*)appendPages:(NSMutableArray*)pages
{
    assert(pages && pages.count);
    UIView *bigPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 612, 932)];
    int height = 0;
    for (UIView *page in pages) {
        [bigPage addSubview:page];
        [PDFUtils adjustY:height forView:page];
        height += page.frame.size.height;
        [PDFUtils setHeight:height forView:bigPage];
        
    }
    return bigPage;
}

- (void)continuePdfGenWithIcon:(UIImage*)icon
{
    NSString *reportPath = [self setReportName];
    NSMutableArray *pages = [self getAllPages:icon];
    //UIView *page = [self appendPages:pages];
    
    // start the PDF rendering
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    for (UIView *page in pages) {
        UIGraphicsBeginPDFPageWithInfo(page.bounds, nil);
        [PDFUtils renderElementsInView:page forPage:page];
    }
    
    UIGraphicsEndPDFContext();
    // end the pdf rendering
    
    // save to disk
    [pdfData writeToFile:reportPath atomically:YES];
    
    _callback(YES);
}

@end