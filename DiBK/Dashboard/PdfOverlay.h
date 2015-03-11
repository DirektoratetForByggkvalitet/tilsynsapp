//
//  PdfOverlay.h
//  DiBK
//
//  Created by david stummer on 17/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Rapport;

@interface PdfOverlay : UIView <UIWebViewDelegate>
{
    UIWebView *webView;
    UIButton *shareButton;
    UIButton *openButton;
}

- (void)showWithPath:(NSString*)path;

@end
