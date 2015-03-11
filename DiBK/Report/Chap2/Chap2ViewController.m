//
//  Chap2FilterViewController.m
//  DiBK
//
//  Created by david stummer on 14/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap2ViewController.h"
#import "AppData.h"
#import "ReportHomeViewController.h"
#import "FagomraderDetailsViewController.h"
#import "DetailPageViewController.h"

@implementation Chap2ViewController
@synthesize chap2FilterView = _chap2view;

static BOOL isVisible = false;

+ (void)setVisibility:(BOOL)visibility
{
    isVisible = visibility;
}

+ (BOOL)isVisible
{
    return isVisible;
}

-(void)shutdown
{
    if (fagvc) {
        [fagvc shutdown];
    }
}

-(void)loadView
{
    _chap2view = [[Chap2View alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = _chap2view;
    
    [_chap2view.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    FagomraderDetailsViewController *jobvc = [[FagomraderDetailsViewController alloc]initWithNibName:@"FagomraderDetailsViewController" bundle:nil];
    fagvc = jobvc;
    [self addChildViewController:jobvc];
    [jobvc didMoveToParentViewController:self];
    [self.view addSubview:jobvc.view];
    CGRect frame = jobvc.view.frame;
    frame.origin.y += 103;
    frame.size.height = 1024 - (103+20);
    jobvc.view.frame = frame;
    
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"ChapterTwo_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"SaveTimerTriggerChap2" object:nil];
}

- (void) startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                              target: self
                                            selector:@selector(doSave)
                                            userInfo: nil repeats:YES];
}

- (void) stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)slideIntoView
{
    _chap2view.munLabel.text = [[AppData getInstance] getTitle];
    
   [UIView animateWithDuration:0.5f animations:^{
       
        self.view.center = CGPointMake((self.view.center.x - [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
    
   }completion:^(BOOL finished) {
       isVisible = true;
    }];
}

- (void)slideOutOfView
{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.center = CGPointMake((self.view.center.x + [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
        
    }completion:^(BOOL finished) {
        isVisible = false;
        [fagvc doSave];
        [fagvc slideOutOfView];
    }];
}


-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self slideOutOfView];
}

- (void)doSave
{
    [fagvc doSave];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [self slideOutOfView];
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveTimerTriggerChap1" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
