//
//  Chap2FilterViewController.h
//  DiBK
//
//  Created by david stummer on 14/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chap2View.h"
#import "ReportHomeViewController.h"

@class FagomraderDetailsViewController;

@interface Chap2ViewController : UIViewController <ChapterViewControllerProtocal>
{
    FagomraderDetailsViewController *fagvc;
}

@property(strong, nonatomic)Chap2View* chap2FilterView;
@property(strong, nonatomic)NSTimer *timer;

- (void)slideIntoView;
- (void)doSave;
- (void)shutdown;
- (void) stopTimer;

@end
