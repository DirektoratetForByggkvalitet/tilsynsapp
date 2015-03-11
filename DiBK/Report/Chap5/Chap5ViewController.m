//
//  Chap5ViewController.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap5ViewController.h"
#import "ReportHomeViewController.h"
#import "AppData.h"
#import "FerdigViewController.h"

@implementation Chap5ViewController
@synthesize chap5View = _chap5View;
@synthesize ferdigViewController;

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
    _chap5View = [[Chap5View alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = _chap5View;
    ferdigViewController = [[FerdigViewController alloc] initWithNibName:@"FerdigViewController" bundle:nil];
    CGRect frame = ferdigViewController.view.frame;
    frame.origin.y += 103;
    ferdigViewController.view.frame = frame;
    [self.view addSubview:ferdigViewController.view];
    [self addChildViewController:ferdigViewController];
    [ferdigViewController didMoveToParentViewController:self];
    
    [_chap5View.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)slideIntoView
{
    [ferdigViewController slideIntoView];
    
    _chap5View.munLabel.text = [[AppData getInstance] getTitle];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.center = CGPointMake((self.view.center.x - [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
        
    }completion:^(BOOL finished) {
        isVisible = true;
    }];
}

- (void)slideOutOfView
{
    [ferdigViewController slideOutOfView];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.center = CGPointMake((self.view.center.x + [[AppData getInstance] reportHomeViewController].view.frame.size.width), self.view.center.y);
        
    }completion:^(BOOL finished) {
        isVisible = false;
    }];
}

- (void)backButtonTapped:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveTimerTriggerChap4" object:nil];
    [ferdigViewController resignAllRepsonders];
    [self slideOutOfView];
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
