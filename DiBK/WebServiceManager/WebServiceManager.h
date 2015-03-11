//
//  WebServiceManager.h
//  DiBK
//
//  Created by david stummer on 07/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebServiceManagerCallback)(BOOL);

@interface WebServiceManager : NSObject<UIAlertViewDelegate>
{
    WebServiceManagerCallback callback;
    BOOL isFetching;
    
    NSDictionary *labelsBokmal, *labelsNynorsk, *listsBokmal, *listsNynorsk;
    NSArray *infoBokmal, *infoNynorsk;
}

-(void)updateWithCallback:(WebServiceManagerCallback)cb;
-(NSMutableSet*)getCopyOfAllTemplates;
-(NSDictionary*)getLabelsForLanguageBokmal;
-(NSDictionary*)getLabelsForLanguageNynorsk;
-(NSDictionary*)getListsForLanguageBokmal;
-(NSDictionary*)getListsForLanguageNynorsk;
-(NSArray*)getInfoForLanguageBokmal;
-(NSArray*)getInfoForLanguageNyorsk;

+(WebServiceManager*)getInstance;

@end
