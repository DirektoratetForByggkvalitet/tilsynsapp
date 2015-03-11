//
//  DiBKNewRapportViewController.h
//  DiBK
//
//  Created by Grafiker2 on 01.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportHomeView.h"
#import "UserInfo.h"

@class Chap1ViewController,
        Chap2ViewController,
        Chap3ViewController,
        Chap4ViewController,
        Chap5ViewController;

@protocol NewRapportControllerDelegateProtocol <NSObject>

- (void)animateNewRapportControllerBack;

@end

@protocol ChapterViewControllerProtocal <NSObject>

- (void)slideIntoView;
- (void)slideOutOfView;
+ (BOOL)isVisible;
+ (void)setVisibility:(BOOL)visibility;

@end

@interface ReportHomeViewController : UIViewController
{
    Chap1ViewController *_chap1;
    Chap2ViewController* _chap2;
    Chap3ViewController* _chap3;
    Chap4ViewController* _chap4;
    Chap5ViewController* _chap5;
    BOOL viewIsSlidingIn;
}

@property(strong, nonatomic)ReportHomeView *makeNewRapportView;
@property(strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic)UserInfo *user;
@property(weak, nonatomic)id<NewRapportControllerDelegateProtocol>rapportDelegate;

- (void)backButtonIsPressed:(UIButton *)sender;
-(void)prepare;

@end
