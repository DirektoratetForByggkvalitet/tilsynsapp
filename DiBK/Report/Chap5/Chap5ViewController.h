//
//  Chap5ViewController.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportHomeViewController.h"
#import "Chap5View.h"

@class FerdigViewController;

@interface Chap5ViewController : UIViewController <ChapterViewControllerProtocal>

@property(nonatomic,strong)FerdigViewController *ferdigViewController;
@property(strong, nonatomic)Chap5View* chap5View;

- (void)slideIntoView;

@end

