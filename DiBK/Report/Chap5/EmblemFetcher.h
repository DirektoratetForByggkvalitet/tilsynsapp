//
//  EmblemFetcher.h
//  DiBK
//
//  Created by david stummer on 19/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUtils.h"

@class EmblemPdfFetcher;

@interface EmblemFetcher : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *urlConnection;
    NSMutableData *webData;
    UIImageCallback _callback;
    EmblemPdfFetcher *pdfFetcher;
}

-(void)fetchEmblemWithCallback:(UIImageCallback)callback;

@end
