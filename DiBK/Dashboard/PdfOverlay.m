//
//  PdfOverlay.m
//  DiBK
//
//  Created by david stummer on 17/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PdfOverlay.h"
#import "Rapport.h"
#import "PDFUtils.h"

@implementation PdfOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        // add the footer to the popover window
        UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 924, 768, 100)];
        [footer setImage:[UIImage imageNamed:@"editFooter"]];
        [self addSubview:footer];
        
        // add the close button to the footer
        int closeButtonWidth = 100;
        int closeButtonHeight = 40;
        int closeButtonXOffset = 748 - (closeButtonWidth);
        int closeButtonYOffset = 1024 - (60 + closeButtonHeight/2);
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(closeButtonXOffset, closeButtonYOffset, closeButtonWidth, closeButtonHeight)];
        [closeButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [closeButton setTitle:@"Lukk" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        // add the share button to the footer
        int shareButtonWidth = 100;
        int shareButtonHeight = 40;
        int shareButtonXOffset = 608 - (shareButtonWidth);
        int shareButtonYOffset = 1024 - (60 + shareButtonHeight/2);
        shareButton = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonXOffset, shareButtonYOffset, shareButtonWidth, shareButtonHeight)];
        [shareButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [shareButton setTitle:@"Del" forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(dropBoxClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareButton];
        
        // add the open button to the footer
        int openButtonWidth = 100;
        int openButtonHeight = 40;
        int openButtonXOffset = 20;
        int openButtonYOffset = 1024 - (60 + openButtonHeight/2);
        openButton = [[UIButton alloc] initWithFrame:CGRectMake(openButtonXOffset, openButtonYOffset, openButtonWidth, openButtonHeight)];
        [openButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [openButton setTitle:@"Åpne" forState:UIControlStateNormal];
        [openButton addTarget:self action:@selector(openButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:openButton];

        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 924)];
        webView.delegate = self;
        [self addSubview:webView];
    }
    return self;
}

- (void)closeClicked
{
    self.hidden = YES;
}

-(void) openButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFileScreen" object:nil];
}

-(void) dropBoxClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenShareFileScreen" object:nil];
}

- (void)showWithPath:(NSString *)path
{
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    self.hidden = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)unhide {
    self.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(unhide) withObject:self afterDelay:0.3f];
}

@end