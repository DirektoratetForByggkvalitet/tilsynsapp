//
//  CameraImageView.m
//  DiBK
//
//  Created by david stummer on 01/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "CameraImageView.h"
#import "Photo.h"
#import "QuestionView.h"
#import "ImageUtils.h"
#import "AppData.h"
#import <QuartzCore/QuartzCore.h>

@implementation CameraImageView
@synthesize index, photo, text, questionView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setContentMode:UIViewContentModeScaleAspectFit];
        [self setupGestureRecognizer];
        [self setupBorder];
    }
    return self;
}

-(void)setText:(NSString *)t
{
    text = t;
    photo.text = text;
}

-(void)setPhoto:(Photo *)p
{
    photo = p;
    text = photo.text;
    [self later];
}

-(void)later
{
    [self setImage:[ImageUtils retrieveThumbnailImageFromFileForID:photo.id]];
}

-(void)setCameraImage:(UIImage *)image
{
    NSString *fullSizeName = [AppData uuidString];
    NSString *thumbName = [NSString stringWithFormat:@"%@-thumb", fullSizeName];
    
    UIImage *fullSizeImage = image;
    UIImage *thumbnailImage = [ImageUtils genThumbnail:image];
    
    [ImageUtils saveImageToFile:fullSizeImage withName:fullSizeName];
    [ImageUtils saveImageThumbnailToFile:thumbnailImage withName:thumbName];
    
    [ImageUtils deleteImageForID:photo.id];
    
    photo.id = fullSizeName;
    
    [self setImage:thumbnailImage];
}

-(void)setupBorder
{
    self.layer.borderColor = [UIColor colorWithRed:52.0f/255.0f green:79.0f/255.0f blue:87.0f/255.0f alpha:1].CGColor;
    self.layer.borderWidth = 0.6f;
}

-(void)setupGestureRecognizer
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    [self setUserInteractionEnabled:YES];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraImageView_Tapped" object:self];
}

@end