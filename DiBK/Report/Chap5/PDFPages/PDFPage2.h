//
//  PDFPage2.h
//  DiBK
//
//  Created by david stummer on 04/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuditType, Checklist, Template;

@interface PDFPage2 : UIViewController
{
    AuditType *auditType;
    Checklist *checklist;
    Template *template;
    BOOL firstPage;
    
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblSubtitle;
}

+ (NSMutableArray*)getPages;

@end
