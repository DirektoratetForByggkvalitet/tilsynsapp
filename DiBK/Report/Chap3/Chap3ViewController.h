//
//  Chap3QuestionsViewController.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chap3View.h"
#import "ReportHomeViewController.h"

@class FormScrollView;

@interface Chap3ViewController : UIViewController <ChapterViewControllerProtocal>
{
    NSArray *templates;
    NSMutableArray *pageVCs;
}

@property(strong,nonatomic)FormScrollView *formScrollView;
@property(strong, nonatomic)Chap3View* chap3View;
@property(strong, nonatomic) NSTimer *timer;

- (void)slideIntoView;
- (void)doSave;
- (void)shutdown;
- (void) stopTimer;

@end
