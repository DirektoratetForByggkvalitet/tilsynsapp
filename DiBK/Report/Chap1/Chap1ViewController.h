//
//  DiBKRapportPartViewController.h
//  DiBK
//
//  Created by Grafiker2 on 05.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chap1View.h"
#import "UserInfo.h"
#import "ReportHomeViewController.h"

@class DetailPageViewController, InfoPageViewController;

@interface Chap1ViewController : UIViewController<UITextFieldDelegate, ChapterViewControllerProtocal>
{
    BOOL expectedIsChosen;
    UIPopoverController *popController;
}

@property(strong, nonatomic)Chap1View *rapportPartView;
@property(strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic)UserInfo *user;
@property(strong, nonatomic)DetailPageViewController *detailPageViewController;
@property(strong, nonatomic)InfoPageViewController *infoPageViewController;
@property(strong, nonatomic)NSTimer *timer;

- (void)backButtonTapped:(UIButton *)sender;
- (void)slideIntoView;
- (void)doSave;
+ (Chap1ViewController*)currentViewController;
- (void) stopTimer;

@end
