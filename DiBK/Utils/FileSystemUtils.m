//
//  FileSystemUtils.m
//  DiBK
//
//  Created by david stummer on 30/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FileSystemUtils.h"

@implementation FileSystemUtils

+ (void)createPath:(NSString*)path
{
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error != nil) {
        NSLog(@"error creating directory: %@", error);
        assert(0);
    }
}

+(NSString*)docsDir
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"Documents"];
    return cacheDir;
}

+ (NSString*)downloadCacheDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dir = [dir stringByAppendingPathComponent:@"DownloadCaches"];
    [self createPath:dir];
    return dir;
}

+ (void)clearDownloadCache
{
    NSString *dir = [self downloadCacheDir];
    NSError *error;
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
    if (allFiles) {
        for (NSString *name in allFiles) {
            NSString *path = [dir stringByAppendingPathComponent:name];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
}

+ (NSString*)getCachedFilePathForName:(NSString *)fileName
{
    return [[self downloadCacheDir] stringByAppendingPathComponent:fileName];
}

// http://stackoverflow.com/questions/4875672/cgpdfdocumentref-from-nsdata
// http://stackoverflow.com/questions/3780745/saving-a-pdf-document-to-disk-using-quartz
+ (void)savePDF:(NSMutableData*)data toFile:(NSString*)path
{
    CFDataRef pdfDocumentData = (__bridge CFDataRef)data;
    
    //Create the pdf document reference
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)pdfDocumentData);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(dataProvider);
    
    //Create the pdf context
    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1); //Pages are numbered starting at 1
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CFMutableDataRef mutableData = CFDataCreateMutable(NULL, 0);
    
    //NSLog(@"w:%2.2f, h:%2.2f",pageRect.size.width, pageRect.size.height);
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData(mutableData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, &pageRect, NULL);
    
    if (CGPDFDocumentGetNumberOfPages(document) > 0)
    {
        int nPages = CGPDFDocumentGetNumberOfPages(document);
        int iPage = 1;
        while (iPage < nPages+1) {
            page = CGPDFDocumentGetPage(document, iPage);
            
            CGPDFContextBeginPage(pdfContext, NULL);
            CGContextDrawPDFPage(pdfContext, page);
            CGPDFContextEndPage(pdfContext);

            iPage++;
        }
    }
    else
    {
        NSLog(@"Failed to create the document");
    }
    
    CGContextRelease(pdfContext); //Release before writing data to disk.
    
    //Write to disk
    [(__bridge NSData *)mutableData writeToFile:path atomically:YES];
    
    //Clean up
    CGDataProviderRelease(dataProvider); //Release the data provider
    CGDataConsumerRelease(dataConsumer);
    CGPDFDocumentRelease(document);
    CFRelease(mutableData);
}

@end
