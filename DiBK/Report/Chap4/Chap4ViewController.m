//
//  Chap4ViewController.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap4ViewController.h"
#import "AppData.h"
#import "KonklusjonViewController.h"

@implementation Chap4ViewController
@synthesize chap4View = _chap4View;

static BOOL isVisible = false;

+ (void)setVisibility:(BOOL)visibility
{
    isVisible = visibility;
}

+ (BOOL)isVisible
{
    return isVisible;
}

-(void)loadView
{
    _chap4View = [[Chap4View alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = _chap4View;
    
    [_chap4View.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    jobvc = [[KonklusjonViewController alloc]initWithNibName:@"KonklusjonViewController" bundle:nil];
    [self addChildViewController:jobvc];
    [jobvc didMoveToParentViewController:self];
    jobvc.view.frame = CGRectMake(0, 103, 768, 901);
    [self.view addSubview:jobvc.view];
    
    
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"ChapterFour_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"SaveTimerTriggerChap4" object:nil];
    
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
    [self startTimer];
    _chap4View.munLabel.text = [[AppData getInstance] getTitle];
    
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
        [jobvc slideOutOfView];
    }];
}

- (void)doSave
{
    NSLog(@"--Save data Chap 4 is being called---");
    
    AppData *appData = [AppData getInstance];
    [appData save];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [jobvc resignAllResponders];
    [self slideOutOfView];
    [self stopTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveTimerTriggerChap3" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
