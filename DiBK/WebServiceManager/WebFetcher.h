//
//  WebServiceKommunes.h
//  DiBK
//
//  Created by david stummer on 07/09/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebFetcherCallback)(void);

@interface WebFetcher : NSObject
{
    WebFetcherCallback callback;
}

- (void)fetchAllWithCallback:(WebFetcherCallback)cb;

@end
