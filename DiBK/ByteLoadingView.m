//
//  ByteLoadingView.m
//  Cridthvidt
//
//  Created by Grafiker2 on 15.03.13.
//  Copyright (c) 2013 com.Byte.Cridthvidt. All rights reserved.
//

#import "ByteLoadingView.h"
#import <QuartzCore/QuartzCore.h>

static ByteLoadingView *defaultAsakLoadingView = nil;

#define DEFAULT_WIDTH 110
#define DEFAULT_HEIGHT 100
#define LOADING_TEXT @"Laster inn..."

@implementation ByteLoadingView

@synthesize loadingLabel = _loadingLabel;

+(ByteLoadingView *)defaultLoadingView
{
    if (defaultAsakLoadingView == nil) {
        
        defaultAsakLoadingView = [[ByteLoadingView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    }
    
    return defaultAsakLoadingView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        // Initialization code.
		double offset = DEFAULT_HEIGHT/2.0;
		_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DEFAULT_HEIGHT-2*offset/3.0, DEFAULT_WIDTH, offset/2)];
        _loadingLabel.textAlignment=UITextAlignmentCenter;
		_loadingLabel.backgroundColor=[UIColor clearColor];
		_loadingLabel.font=[UIFont boldSystemFontOfSize:14];
		_loadingLabel.textColor=[UIColor whiteColor];
        
        _loadingLabel.text = LOADING_TEXT;
		
		backgroundView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
        backgroundView.alpha=0.65;
		backgroundView.backgroundColor=[UIColor blackColor];
        backgroundView.layer.cornerRadius=10;
		
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center=CGPointMake( DEFAULT_WIDTH/2, DEFAULT_HEIGHT/3);
		[activityIndicator startAnimating];
        
		[self addSubview:backgroundView];
		[self addSubview:_loadingLabel];
        [self addSubview:activityIndicator];
		
    }
    return self;
}

-(void)setLoadingText:(NSString *)loadingText{
	_loadingLabel.text = loadingText;
}

-(void) showInView:(UIView*)view {
    view.userInteractionEnabled = NO;
	self.alpha=1.0;
    self.transform=CGAffineTransformMakeScale(1, 1);
    self.center=CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0);
    [view addSubview:self];
}

-(void) hideActivityIndicator {
    self.superview.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

@end
