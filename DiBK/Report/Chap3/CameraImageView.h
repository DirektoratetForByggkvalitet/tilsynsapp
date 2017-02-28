//
//  CameraImageView.h
//  DiBK
//
//  Created by david stummer on 01/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo, QuestionView;

@interface CameraImageView : UIImageView
{
    UIPopoverController *imagePickerPopover;
}

@property(nonatomic,strong)QuestionView *questionView;
@property (nonatomic) NSInteger index;
@property(strong,nonatomic)Photo *photo;
@property(strong,nonatomic)NSString *text;

- (void)setCameraImage:(UIImage*)image;

@end