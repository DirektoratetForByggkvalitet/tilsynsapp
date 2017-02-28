//
//  WebServiceKommunes.m
//  DiBK
//
//  Created by david stummer on 07/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "WebFetcher.h"
#import "WebServiceUtilsPrivate.h"

// this does the actual fetching
typedef void (^WebFetchCallback)(NSMutableData*);
@interface WebFetch : NSObject<NSURLConnectionDelegate>
{
    NSURLConnection *urlConnection;
    NSMutableData *webData;
    WebFetchCallback _callback;
}
@end
@implementation WebFetch
-(void)fetch:(WebFetchCallback)callback andURL:(NSString*)url
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
    _callback(webData);
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

@implementation WebFetcher

- (void)fetchAllWithCallback:(WebFetcherCallback)cb
{
    callback = cb;
    [self fetchKommunes];
}

- (BOOL)isValidResponse:(NSMutableData*)data
{
    if (data.length <= 0) {
        return NO;
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!json) {
        NSLog(@"error: %@ %@" , error.description, error.localizedDescription);
        return NO;
    }
    NSString *errorVal = json[@"errors"];
    if (errorVal != nil) {
        return NO;
    }
    return YES;
}

-(void)fetchKommunes
{
    NSString *filePath = [WebServiceUtilsPrivate getKommuneJsonFilePath];
    NSString *url = @"https://app-api.dibk.no/kommuner/v1/alle";
    WebFetch *fetch = [WebFetch new];
    [fetch fetch:^(NSMutableData *data) {
        if ([self isValidResponse:data]) {
            [data writeToFile:filePath atomically:YES];
        }
        [self fetchLanguageBokmal];
    } andURL:url];
}

-(void)fetchLanguageBokmal
{
    NSString *filePath = [WebServiceUtilsPrivate getLanguageBokmalJsonFilePath];
    NSString *url = @"https://app-api.dibk.no/tilsyn/v1/hent_nb_NO";
    WebFetch *fetch = [WebFetch new];
    [fetch fetch:^(NSMutableData *data) {
        if ([self isValidResponse:data]) {
            [data writeToFile:filePath atomically:YES];
        }
        [self fetchLanguageNynorsk];
    } andURL:url];
}

-(void)fetchLanguageNynorsk
{
    NSString *filePath = [WebServiceUtilsPrivate getLanguageNynorskJsonFilePath];
    NSString *url = @"https://app-api.dibk.no/tilsyn/v1/hent_nn_NO";
    WebFetch *fetch = [WebFetch new];
    [fetch fetch:^(NSMutableData *data) {
        if ([self isValidResponse:data]) {
            [data writeToFile:filePath atomically:YES];
        }
        [self execCallback];
    } andURL:url];
}

+ (NSString*)getCachedFilePathWithName:(NSString*)name
{
    NSString *path = [WebServiceUtilsPrivate getCachesFolder];
    path = [path stringByAppendingPathComponent:name];
    return path;
}

-(void)execCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        callback();
    });
}

@end
