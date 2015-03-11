//
//  CameraOverlayView.m
//  DiBK
//
//  Created by david stummer on 02/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "CameraOverlayView.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraImageView.h"
#import "QuestionView.h"
#import "ImageUtils.h"
#import "Photo.h"
#import "AppUtils.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation CameraOverlayView
@synthesize cameraImageView, parentViewController;

static int POPOVER_HEIGHT = 505;
static int POPOVER_TOP_MARGIN = 99;
static int POPOVER_HORIZ_MARGIN = 75;
static int POPOVER_WIDTH = 638;
UIButton *deleteButton;

- (id)initWithFrame:(CGRect)frame andController:(UIViewController*)c
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        controller = c;
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
        polaroid = [[UIView alloc] initWithFrame:CGRectMake(POPOVER_HORIZ_MARGIN, POPOVER_TOP_MARGIN, POPOVER_WIDTH, POPOVER_HEIGHT)];
        [polaroid setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:polaroid];
        
        // add the footer to the popover window
        int footerHeight = 80;
        int footerYOffset = (POPOVER_HEIGHT+POPOVER_TOP_MARGIN) - footerHeight;
        UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(POPOVER_HORIZ_MARGIN, footerYOffset, POPOVER_WIDTH, footerHeight)];
        [footer setImage:[UIImage imageNamed:@"editFooter"]];
        [self addSubview:footer];
        
        // add the close button to the footer
        int closeButtonWidth = 100;
        int closeButtonHeight = 40;
        int closeButtonXOffset = (POPOVER_HORIZ_MARGIN+POPOVER_WIDTH) - (closeButtonWidth+20);
        int closeButtonYOffset = (POPOVER_HEIGHT+POPOVER_TOP_MARGIN) - (footerHeight/2 + closeButtonHeight/2);
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(closeButtonXOffset, closeButtonYOffset, closeButtonWidth, closeButtonHeight)];
        [closeButton setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [closeButton setTitle:@"Ferdig" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        // add the close button to the footer
        int deleteButtonWidth = 100;
        int deleteButtonHeight = 40;
        int deleteButtonXOffset = (POPOVER_WIDTH - 10);
        int deleteButtonYOffset = (POPOVER_TOP_MARGIN);
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(deleteButtonXOffset, deleteButtonYOffset, deleteButtonWidth, deleteButtonHeight)];
        [deleteButton setTitle:@"Endre" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(changeImageClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        
        int MARGIN = 25;
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(POPOVER_HORIZ_MARGIN+MARGIN, POPOVER_TOP_MARGIN+MARGIN, polaroid.frame.size.width - MARGIN*2, 375)];
        [photo setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:photo];
        
        int rightMargin = 100;
        UIImageView *comment = [[UIImageView alloc] initWithFrame:CGRectMake(footer.frame.origin.x+MARGIN, closeButtonYOffset, 29, 26)];
        comment.image = [UIImage imageNamed:@"MessageIcon"];
        [self addSubview:comment];
        textView = [[UITextView alloc] initWithFrame:CGRectMake(footer.frame.origin.x+MARGIN+50, footer.frame.origin.y+15, footer.frame.size.width-(rightMargin+MARGIN+100), footer.frame.size.height-(15*2))];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        textView.textColor = [UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1];
        textView.delegate = self;
        [self addSubview:textView];
        [textView setText:[LabelManager getTextForParent:@"chapter_three_photo_dialog" Key:@"text_1"]];
    }
    
    return self;
}

-(void) changeImageClicked
{
    NSString *cancel = [LabelManager getTextForParent:@"general" Key:@"cancel"];
    NSString *takePhoto = [LabelManager getTextForParent:@"general" Key:@"take_photo"];
    if ([takePhoto isEqualToString:@""]) {
        takePhoto = @"Take Photo";
    }
    NSString *chooseExisting = [LabelManager getTextForParent:@"general" Key:@"choose_existing"];
    if ([chooseExisting isEqualToString:@""]) {
        chooseExisting = @"Choose Existing";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:takePhoto, chooseExisting, nil];
    [actionSheet showFromRect:deleteButton.frame inView:self animated:YES];
}

-(UIImage*) getImage
{
    return photo.image;
}

-(void)showPopoverWithViewController:(UIViewController *)vc
{
    [textView setText:[LabelManager getTextForParent:@"chapter_three_photo_dialog" Key:@"text_1"]];
    //[textView selectAll:self];
    parentViewController = vc;
    [photo setImage:nil];
}

-(void)showActionSheet
{
    NSString *cancel = [LabelManager getTextForParent:@"general" Key:@"cancel"];
    NSString *takePhoto = [LabelManager getTextForParent:@"general" Key:@"take_photo"];
    if ([takePhoto isEqualToString:@""]) {
        takePhoto = @"Take Photo";
    }
    NSString *chooseExisting = [LabelManager getTextForParent:@"general" Key:@"choose_existing"];
    if ([chooseExisting isEqualToString:@""]) {
        chooseExisting = @"Choose Existing";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:takePhoto, chooseExisting, nil];
    UIView *v = userActionSheetFrame ? actionSheetFrame : cameraImageView;
    CGRect rect = [self convertRect:v.frame fromView:v.superview];
    [actionSheet showFromRect:rect inView:self animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self imgFromCameraClick];
    } else if (buttonIndex == 1) {
        [self imgFromLibraryClick];
    }
}

-(void)start
{
    userActionSheetFrame = false;
    [self doStart];
}

-(void)startWithActionSheetFrame:(UIView*)frame
{
    userActionSheetFrame = true;
    actionSheetFrame = frame;
    [self doStart];
}

-(void)doStart
{
    UIImage *img = [ImageUtils retrieveFullsizeImageFromFileForID:cameraImageView.photo.id];
    if (img == nil) {
        [self showActionSheet];
    } else {
        [photo setImage:img];
        [textView setText:cameraImageView.text];
        if (!textView.text || [textView.text isEqualToString:@""]) {
            textView.text = [LabelManager getTextForParent:@"chapter_three_photo_dialog" Key:@"text_1"];
        }
        [self setHidden:FALSE];
    }
}

-(void)setCameraImageView:(CameraImageView *)v
{
    cameraImageView = v;
}

- (void)exit
{
    [textView resignFirstResponder];
    
    [cameraImageView.questionView doExpand];
    cameraImageView.text = textView.text;
    [self setHidden:true];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textView resignFirstResponder];
    
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i<[touchesArray count]; i++)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        
        if (!CGRectContainsPoint(polaroid.frame, point)) {
            [self exit];
            return;
        }
    }
}

-(void)closeClicked
{
    [self exit];
}

- (void)imgFromLibraryClick
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [imagePickerPopover setDelegate:self];
    CGRect frame = photo.frame; frame.origin.y -= 160;
    [imagePickerPopover presentPopoverFromRect:frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imgFromCameraClick
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller presentViewController:imagePicker animated:YES completion:nil];
}

// gets round IOS7 status bar bug
// http://stackoverflow.com/questions/18880364/uiimagepickercontroller-breaks-status-bar-appearance
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showStatusBar:picker];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image) {
        NSLog(@"CameraOverlayView - No Image!!!");
    }
    [photo setImage:image];
    [cameraImageView setCameraImage:image];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self setHidden:FALSE];
    [self showStatusBar:picker];
}

- (void)showStatusBar:(UIImagePickerController *)picker;
{
    // IOS7 bug - status bar dissapears
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            CGRect frame = [[UIScreen mainScreen] bounds];
            frame.origin.y += 20;
            [UIApplication sharedApplication].keyWindow.frame = frame;
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)tV
{
    [ColorSchemeManager setOverlayBorderSelected:textView yes:YES];
    if (textView.text && [textView.text isEqualToString:[LabelManager getTextForParent:@"chapter_three_photo_dialog" Key:@"text_1"]]) {
        textView.text = @"";
        return;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [ColorSchemeManager setOverlayBorderSelected:textView yes:NO];
}

@end