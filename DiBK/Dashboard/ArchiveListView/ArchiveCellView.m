//
//  CellView.m
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ArchiveCellView.h"
#import "ArchiveListRetriever.h"
#import "AppUtils.h"

@implementation ArchiveCellView
@synthesize lblFilename, lblDate, spinner, lblFailed;

- (void)setupCellViewWithFile:(ArchiveFileInfo*)fi
{
    fileInfo = fi;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    lblFilename.text = fileInfo.name;
    lblFilename.adjustsFontSizeToFitWidth = YES;
    
    int days = [AppUtils getDaysSinceFileCreated:fi.path];
    lblDate.text = [NSString stringWithFormat:@"%d d", days];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, 503, 1)];
    [line2 setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
    [self addSubview:line2];
    
    spinner.hidden = YES;
    spinner.hidesWhenStopped = YES;
    lblFailed.hidden = YES;
    
    if (fileInfo.isDownloadPdf1 || fileInfo.isDownloadPdf2) {
        lblDate.hidden = YES;
        if (fileInfo.isCurrentlyDownloading) {
            spinner.hidden = NO;
            [spinner startAnimating];
            NSString *noteName = fileInfo.isDownloadPdf1 ? @"PDFRetriever_PDF1Downloaded" : @"PDFRetriever_PDF2Downloaded";
            NSString *noteName2 = fileInfo.isDownloadPdf1 ? @"PDFRetriever_PDF1DownloadFailed" : @"PDFRetriever_PDF2DownloadFailed";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pdfRetrieved) name:noteName object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pdfFailed) name:noteName2 object:nil];
        }
    }
}

- (void)pdfRetrieved
{
    [spinner stopAnimating];
}

-(void)pdfFailed
{
    spinner.hidden = YES;
    lblFailed.hidden = NO;
}

@end