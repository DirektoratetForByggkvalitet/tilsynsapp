//
//  CameraOverlayView.h
//  DiBK
//
//  Created by david stummer on 02/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraImageView;

@interface CameraOverlayView : UIView <UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    UIView *polaroid;
    UIPopoverController *imagePickerPopover;
    UIImageView *photo;
    UIViewController *controller;
    UITextView *textView;
    UIView *actionSheetFrame;
    BOOL userActionSheetFrame;
}

@property(nonatomic,strong)UIViewController *parentViewController;
@property(nonatomic,strong)CameraImageView *cameraImageView;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController*)c;
- (void)showPopoverWithViewController:(UIViewController*)vc;
- (void)start;
- (void)startWithActionSheetFrame:(UIView*)frame;

@end
