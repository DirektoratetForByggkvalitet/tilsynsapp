//
//  WebServiceManager.m
//  DiBK
//
//  Created by david stummer on 07/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "WebServiceManager.h"
#import "WebFetcher.h"
#import "Reachability.h"
#import "LabelManager.h"
#import "WebServiceUtilsPrivate.h"

@implementation WebServiceManager

+(WebServiceManager*)getInstance
{
    static WebServiceManager* sp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sp = [WebServiceManager new];
    });
    return sp;
}

-(id)init
{
    self = [super init];
    if (self) {
        isFetching = NO;
    }
    return self;
}

-(BOOL)isStoredOnDisk	
{
    return [WebServiceUtilsPrivate cachedFilesExist];
}

-(void)updateWithCallback:(WebServiceManagerCallback)cb
{
    if (isFetching) {
        assert(0);
        return;
    }
    
    callback = cb;
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        [reach stopNotifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchFromInternet];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        [reach stopNotifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isStoredOnDisk]) {
                [self processData];
            } else {
                [self cannotContinue];
            }
        });
    };
    
    [reach startNotifier];
}

- (void)cannotContinue
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [LabelManager getTextForParent:@"general" Key:@"error"]
                                                    message: [LabelManager getTextForParent:@"web_service_manager" Key:@"text_1"]
                                                   delegate: self
                                          cancelButtonTitle:[LabelManager getTextForParent:@"general" Key:@"ok"]
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    exit(0);
}

-(void)fetchFromInternet
{
    WebFetcher *fetcher = [WebFetcher new];
    [fetcher fetchAllWithCallback:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processData];
        });
    }];
}

-(void)processData
{
    [self clearMemoryCache];
    [WebServiceUtilsPrivate saveKommuneJsonToCoreData];
    callback(YES);
}

-(void)clearMemoryCache
{
    labelsBokmal = nil;
    labelsNynorsk = nil;
    infoBokmal = nil;
    infoNynorsk = nil;
    listsBokmal = nil;
    listsNynorsk = nil;
}

-(NSDictionary*)getLabelsForLanguageBokmal
{
    if (labelsBokmal == nil) {
        labelsBokmal = [WebServiceUtilsPrivate extractLabelsArrForLangBokmal];
    }
    return labelsBokmal;
}

-(NSDictionary*)getLabelsForLanguageNynorsk
{
    if (labelsNynorsk == nil) {
        labelsNynorsk = [WebServiceUtilsPrivate extractLabelsArrForLangNynorsk];
    }
    return labelsNynorsk;
}

-(NSDictionary*)getListsForLanguageBokmal
{
    if (listsBokmal == nil) {
        listsBokmal = [WebServiceUtilsPrivate extractListsArrForLangBokmal];
    }
    return listsBokmal;
}

-(NSDictionary*)getListsForLanguageNynorsk
{
    if (listsNynorsk == nil) {
        listsNynorsk = [WebServiceUtilsPrivate extractListsArrForLangNynorsk];
    }
    return listsNynorsk;
}

-(NSArray*)getInfoForLanguageBokmal
{
    if (infoBokmal == nil) {
        infoBokmal = [WebServiceUtilsPrivate extractInfoForLangBokmal];
    }
    return infoBokmal;
}

-(NSArray*)getInfoForLanguageNyorsk
{
    if (infoNynorsk == nil) {
        infoNynorsk = [WebServiceUtilsPrivate extractInfoForLangNynorsk];
    }
    return infoNynorsk;
}

-(NSMutableSet*)getCopyOfAllTemplates
{
    return [WebServiceUtilsPrivate getCopyOfAllTemplates];
}

@end
