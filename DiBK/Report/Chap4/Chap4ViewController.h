//
//  Chap4ViewController.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportHomeViewController.h"
#import "Chap4View.h"

@class KonklusjonViewController;

@interface Chap4ViewController : UIViewController <ChapterViewControllerProtocal>
{
    KonklusjonViewController *jobvc;
}

@property(strong, nonatomic)Chap4View* chap4View;
@property(strong, nonatomic)NSTimer* timer;

- (void)slideIntoView;
- (void)doSave;
- (void) stopTimer;

@end
