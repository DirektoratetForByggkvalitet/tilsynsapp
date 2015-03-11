//
//  EmblemFetcher.m
//  DiBK
//
//  Created by david stummer on 19/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "EmblemFetcher.h"
#import "AppData.h"
#import "Rapport.h"
#import "Chapter1Info.h"
#import "AppUtils.h"
#import "Municipality.h"

/*
 workflow
 1) construct url using the kommune's id
 2) get json response from this url
 3) extract the url of the emblem from the json response
 4) fetch the emblem pdf from the url extracted
 5) turn the pdf into image and call _callback with image as a parameter
*/

// this class is used to retrieve the pdf, given a url
typedef void (^EmblemPdfFetcherCallback)(NSMutableData*);
@interface EmblemPdfFetcher : NSObject<NSURLConnectionDelegate>
{
    NSURLConnection *urlConnection;
    NSMutableData *webData;
    EmblemPdfFetcherCallback _callback;
}
@end
@implementation EmblemPdfFetcher
-(void)fetchEmblemPdfWithCallback:(EmblemPdfFetcherCallback)callback andURL:(NSString*)url
{
    _callback = callback;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    webData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"tilsynsapp" password:@"b07ac2d67a81bd4d2fc45fbb5beac45ab8a42433" persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender]useCredential:credential forAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
    _callback(nil);
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _callback(webData);
}
@end



@implementation EmblemFetcher

static NSString *kUrl = @"https://app-api.dibk.no/kommuner/v1/%@";

-(void)fetchEmblemWithCallback:(UIImageCallback)callback
{
    _callback = callback;
    
    NSString *kCode = [self getKommuneCode];
    if (!kCode) {
        NSLog(@"Cannot find Municipality object for property name: %@", [self getKommuneStr]);
        _callback(nil);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:kUrl, [self getKommuneCode]];
    NSLog(@"emblem fetch url: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    webData = [NSMutableData data];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (NSString*)getKommuneCode
{
    NSString *region = [AppUtils extractKommuneCodeFromString:[self getKommuneStr]];
    if (!region) {
        return [NSNumber numberWithInt:-1];
    }
    return region;
}

- (NSString*)getKommuneStr
{
    return [AppData getInstance].currentReport.chapter1Info.kommuneID;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"tilsynsapp" password:@"b07ac2d67a81bd4d2fc45fbb5beac45ab8a42433" persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender]useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _callback(nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (!webData || webData.length <= 0) {
        _callback(nil);
    }
    
    NSString *response = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"emblem fetch response: %@" , response);
    
    NSString *pdfUrl = [self getPdfUrlFromResponse];
    NSLog(@"Emblem fetch URL:%@", pdfUrl);
    if (!pdfUrl) {
        NSLog(@"Problem retrieving emblem url from json");
        _callback(nil);
        return;
    }
    
    pdfFetcher = [[EmblemPdfFetcher alloc] init];
    [pdfFetcher fetchEmblemPdfWithCallback:^(NSMutableData* data){
        if (!data || data.length <= 0) {
            _callback(nil);
        }
        // process pdf here
        UIImage *image = [self getImageFromPdfWebData:data];
        _callback(image);
    } andURL:pdfUrl];
}

- (NSString*)getPdfUrlFromResponse
{
    NSError *error;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *meta = res[@"meta"];
    NSDictionary *body = res[@"kommune"][0];
    
    if (!res) {
        NSLog(@"getPdfFromResponse Error: %@", error.localizedDescription);
        return nil;
    }
    BOOL success = meta[@"success"];
    if (!success) {
        return nil;
    }
    NSString *url = body[@"kommunevapen"];
    return url;
}

- (UIImage*)getImageFromPdfWebData:(NSMutableData*)data
{
    // http://stackoverflow.com/questions/4875672/cgpdfdocumentref-from-nsdata
    CFDataRef myPDFData = (__bridge CFDataRef)data;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
    UIImage *image = [self buildThumbnailImageWithPdf:pdf];
    CGPDFDocumentRelease(pdf);
    CGDataProviderRelease(provider);
    return image;
}

//http://stackoverflow.com/questions/10919075/image-of-the-first-pdf-page-ios-sdk
- (UIImage *)buildThumbnailImageWithPdf:(CGPDFDocumentRef)pdfDocument
{
    BOOL hasRetinaDisplay = FALSE;  // by default
    CGFloat pixelsPerPoint = 1.0;  // by default (pixelsPerPoint is just the "scale" property of the screen)
    
    /*if ([UIScreen instancesRespondToSelector:@selector(scale)])  // the "scale" property is only present in iOS 4.0 and later
    {
        // we are running iOS 4.0 or later, so we may be on a Retina display;  we need to check further...
        if ((pixelsPerPoint = [[UIScreen mainScreen] scale]) == 1.0)
            hasRetinaDisplay = FALSE;
        else
            hasRetinaDisplay = TRUE;
    }
    else
    {
        // we are NOT running iOS 4.0 or later, so we can be sure that we are NOT on a Retina display
        pixelsPerPoint = 1.0;
        hasRetinaDisplay = FALSE;
    }*/
    
    size_t imageWidth = 320;  // width of thumbnail in points
    size_t imageHeight = 460;  // height of thumbnail in points
    
    if (hasRetinaDisplay)
    {
        imageWidth *= pixelsPerPoint;
        imageHeight *= pixelsPerPoint;
    }
    
    size_t bytesPerPixel = 4;  // RGBA
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = bytesPerPixel * imageWidth;
    
    void *bitmapData = malloc(imageWidth * imageHeight * bytesPerPixel);
    
    // in the event that we were unable to mallocate the heap memory for the bitmap,
    // we just abort and preemptively return nil:
    if (bitmapData == NULL)
        return nil;
    
    // remember to zero the buffer before handing it off to the bitmap context:
    bzero(bitmapData, imageWidth * imageHeight * bytesPerPixel);
    
    CGContextRef theContext = CGBitmapContextCreate(bitmapData, imageWidth, imageHeight, bitsPerComponent, bytesPerRow,
                                                    CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
    //CGPDFDocumentRef pdfDocument = MyGetPDFDocumentRef();  // NOTE: you will need to modify this line to supply the CGPDFDocumentRef for your file here...
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, 1);  // get the first page for your thumbnail
    
    CGAffineTransform shrinkingTransform =
    CGPDFPageGetDrawingTransform(pdfPage, kCGPDFMediaBox, CGRectMake(0, 0, imageWidth, imageHeight), 0, YES);
    
    CGContextConcatCTM(theContext, shrinkingTransform);
    
    CGContextDrawPDFPage(theContext, pdfPage);  // draw the pdfPage into the bitmap context
    //CGPDFDocumentRelease(pdfDocument);
    
    //
    // create the CGImageRef (and thence the UIImage) from the context (with its bitmap of the pdf page):
    //
    CGImageRef theCGImageRef = CGBitmapContextCreateImage(theContext);
    free(CGBitmapContextGetData(theContext));  // this frees the bitmapData we malloc'ed earlier
    CGContextRelease(theContext);
    
    UIImage *theUIImage;
    
    // CAUTION: the method imageWithCGImage:scale:orientation: only exists on iOS 4.0 or later!!!
    if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
    {
        theUIImage = [UIImage imageWithCGImage:theCGImageRef scale:pixelsPerPoint orientation:UIImageOrientationUp];
    }
    else
    {
        theUIImage = [UIImage imageWithCGImage:theCGImageRef];
    }
    
    CFRelease(theCGImageRef);
    return theUIImage;
}

@end
