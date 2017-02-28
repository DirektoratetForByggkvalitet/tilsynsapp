//
//  PDFGenerator.h
//  DiBK
//
//  Created by david stummer on 17/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rapport;

typedef void (^PDFGeneratorCallback)(BOOL);

@interface PDFGenerator : NSObject
{
    PDFGeneratorCallback _callback;
}

-(void)generatePdfWithCallback:(PDFGeneratorCallback)callback;

@end
