//
//  ByteLoadingView.h
//  Cridthvidt
//
//  Created by Grafiker2 on 15.03.13.
//  Copyright (c) 2013 com.Byte.Cridthvidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByteLoadingView : UIView
{
    UILabel *loadingLabel;
	UIView *backgroundView;
	UIActivityIndicatorView* activityIndicator;
}

@property(strong, nonatomic)UILabel *loadingLabel;

+(ByteLoadingView *) defaultLoadingView;
-(void)setLoadingText:(NSString *)loadingText;
-(void) hideActivityIndicator;
-(void) showInView:(UIView*)view;


@end
