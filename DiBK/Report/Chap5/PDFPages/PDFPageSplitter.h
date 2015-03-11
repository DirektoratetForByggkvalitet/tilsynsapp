//
//  PDFPageSplitter.h
//  DiBK
//
//  Created by david stummer on 07/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFPageSplitter : NSObject
+ (NSMutableArray*)extractPagesInPage:(UIView*)page;
@end
