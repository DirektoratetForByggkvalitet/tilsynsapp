//
//  TopView.h
//  DiBK
//
//  Created by david stummer on 16/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailPageViewController;

@interface TopView : UIView

@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UITextField *txt3;
@property (strong,nonatomic) DetailPageViewController *viewController;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (IBAction)removeBtnClicked:(id)sender;

@end
