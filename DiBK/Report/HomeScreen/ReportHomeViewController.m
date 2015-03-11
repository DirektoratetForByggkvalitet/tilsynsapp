//
//  DiBKNewRapportViewController.m
//  DiBK
//
//  Created by Grafiker2 on 01.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ReportHomeViewController.h"
#import "Chap1ViewController.h"
#import "Chap2ViewController.h"
#import "Chap3ViewController.h"
#import "Chap4ViewController.h"
#import "Chap5ViewController.h"
#import "AppData.h"
#import "LabelManager.h"

@implementation ReportHomeViewController
@synthesize makeNewRapportView = _makeNewRapportView;
@synthesize user = _user;
@synthesize rapportDelegate = _rapportDelegate;

- (id)init
{
    self = [super init];
    [[AppData getInstance] setReportHomeViewController:self];
    return self;
}

- (void)setUser:(UserInfo *)user
{
    if (user != nil) {
        _user = nil;
        _user = user;
    }
}

- (void)loadView
{
    _makeNewRapportView = [[ReportHomeView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_makeNewRapportView.backButton addTarget:self action:@selector(backButtonIsPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.view = _makeNewRapportView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterOneNavClicked) name:@"ChapterOne_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterTwoNavClicked) name:@"ChapterTwo_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterThreeNavClicked) name:@"ChapterThree_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterFourNavClicked) name:@"ChapterFour_RightNavClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushReport) name:@"NavigateToDashBoard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markAllChaptersInvisible) name:@"NavigateBackToFrontPage" object:nil];
}

- (void)chapterOneNavClicked
{
    if (viewIsSlidingIn) {
        return;
    }
    viewIsSlidingIn = YES;
    [self performSelector:@selector(viewFinishedSlidingIn) withObject:self afterDelay:1.5f];
    
    [_chap1 doSave];
    [self addChapterView:_chap2 withClass:[Chap2ViewController class]];
}

- (void)chapterTwoNavClicked
{
    if (viewIsSlidingIn) {
        return;
    }
    viewIsSlidingIn = YES;
    [self performSelector:@selector(viewFinishedSlidingIn) withObject:self afterDelay:1.5f];
    
    [self addChapterView:_chap3 withClass:[Chap3ViewController class]];
    [_chap2 doSave];
}

- (void)chapterThreeNavClicked
{
    if (viewIsSlidingIn) {
        return;
    }
    viewIsSlidingIn = YES;
    [self performSelector:@selector(viewFinishedSlidingIn) withObject:self afterDelay:1.5f];
    
    [self addChapterView:_chap4 withClass:[Chap4ViewController class]];
    [_chap3 doSave];
}

- (void)chapterFourNavClicked
{
    if (viewIsSlidingIn) {
        return;
    }
    viewIsSlidingIn = YES;
    [self performSelector:@selector(viewFinishedSlidingIn) withObject:self afterDelay:1.5f];
    
    [self addChapterView:_chap5 withClass:[Chap5ViewController class]];
    [_chap4 doSave];
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

- (UIViewController<ChapterViewControllerProtocal>*)addChapterView:(UIViewController<ChapterViewControllerProtocal>*)vc withClass:(Class)k
{
    //if (vc == nil) {
        vc = [k new];
        [self.view addSubview:vc.view];
        vc.view.center = CGPointMake(vc.view.center.x + self.view.frame.size.width, vc.view.center.y);
    //}
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    
    if (k == [Chap1ViewController class]) {
        _chap1 = vc;
    }
    if (k == [Chap2ViewController class]) {
        if (_chap2) {
            [_chap2 shutdown];
        }
        _chap2 = vc;
    }
    if (k == [Chap3ViewController class]) {
        if (_chap3) {
            [_chap3 shutdown];
        }
        _chap3 = vc;
    }
    if (k == [Chap4ViewController class]) {
        _chap4 = vc;
    }
    if (k == [Chap5ViewController class]) {
        _chap5 = vc;
    }
    
    // prevent multiple clicks
    viewIsSlidingIn = YES;
    [self performSelector:@selector(viewFinishedSlidingIn) withObject:self afterDelay:1];
    
    [vc slideIntoView];
    return vc;
}

-(void)viewFinishedSlidingIn
{
    viewIsSlidingIn = NO;
}

-(void)prepare
{
    NSString *titleStr = [[AppData getInstance] getTitle];
    if (titleStr.length <= 0) {
        titleStr = [LabelManager getTextForParent:@"report_home_screen" Key:@"text_1"];
    }
    _makeNewRapportView.makeNewRapportLabel.text = titleStr;
}

- (void)buttonPressed:(UIButton*)button
{
    UIView *selectedView = [[UIView alloc]initWithFrame:button.bounds];
    [selectedView setBackgroundColor:[UIColor blackColor]];
    [selectedView setAlpha:0.1f];
    [selectedView setTag:0];
    
    [button addSubview:selectedView];
}

#pragma mark - Button Action Methods

- (BOOL)chapterViewVisible
{
    if ([Chap1ViewController isVisible]) {
        return true;
    }
    if ([Chap2ViewController isVisible]) {
        return true;
    }
    if ([Chap3ViewController isVisible]) {
        return true;
    }
    if ([Chap4ViewController isVisible]) {
        return true;
    }
    if ([Chap5ViewController isVisible]) {
        return true;
    }
    
    return false;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL vis = [self chapterViewVisible];
    if (vis) {
        return;
    }
    if (viewIsSlidingIn) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    CGRect buttonOneFrame = [self.view convertRect:_makeNewRapportView.rapportPartOneButton.frame fromView:self.view];
    CGRect buttonTwoFrame = [self.view convertRect:_makeNewRapportView.rapportPartTwoButton.frame fromView:self.view];
    CGRect buttonThreeFrame = [self.view convertRect:_makeNewRapportView.rapportPartThreeButton.frame fromView:self.view];
    CGRect buttonFourFrame = [self.view convertRect:_makeNewRapportView.rapportPartFourButton.frame fromView:self.view];
    CGRect buttonFiveFrame = [self.view convertRect:_makeNewRapportView.rapportPartFiveButton.frame fromView:self.view];
    
    if (point.x >= buttonOneFrame.origin.x && point.y >= buttonOneFrame.origin.y && point.y <= (buttonOneFrame.origin.y + buttonOneFrame.size.height)) {
        
        [self buttonPressed:_makeNewRapportView.rapportPartOneButton];
        [self addChapterView:_chap1 withClass:[Chap1ViewController class]];
        
        [_chap1 setManagedObjectContext:_managedObjectContext];
        [_chap1 setUser:_user];
        [_chap1 setTitle:[NSString stringWithFormat:@"%@ %@" , _makeNewRapportView.rapportPartOneButton.numberLabel.text, _makeNewRapportView.rapportPartOneButton.headerLabel.text]];
        
    }else if(point.x >= buttonTwoFrame.origin.x && point.y >= buttonTwoFrame.origin.y && point.y <= (buttonTwoFrame.origin.y + buttonTwoFrame.size.height)){
        
        [self buttonPressed:_makeNewRapportView.rapportPartTwoButton];
        [self addChapterView:_chap2 withClass:[Chap2ViewController class]];
        
    }else if(point.x >= buttonThreeFrame.origin.x && point.y >= buttonThreeFrame.origin.y && point.y <= (buttonThreeFrame.origin.y + buttonThreeFrame.size.height)){
        
        [self buttonPressed:_makeNewRapportView.rapportPartThreeButton];
        [self addChapterView:_chap3 withClass:[Chap3ViewController class]];
        
    }else if(point.x >= buttonFourFrame.origin.x && point.y >= buttonFourFrame.origin.y && point.y <= (buttonFourFrame.origin.y + buttonFourFrame.size.height)){
        
        [self buttonPressed:_makeNewRapportView.rapportPartFourButton];
        [self addChapterView:_chap4 withClass:[Chap4ViewController class]];
        
    }else if(point.x >= buttonFiveFrame.origin.x && point.y >= buttonFiveFrame.origin.y && point.y <= (buttonFiveFrame.origin.y + buttonFiveFrame.size.height)){
        
        [self buttonPressed:_makeNewRapportView.rapportPartFiveButton];
        [self addChapterView:_chap5 withClass:[Chap5ViewController class]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    CGRect buttonOneFrame = [self.view convertRect:_makeNewRapportView.rapportPartOneButton.frame fromView:self.view];
    CGRect buttonTwoFrame = [self.view convertRect:_makeNewRapportView.rapportPartTwoButton.frame fromView:self.view];
    CGRect buttonThreeFrame = [self.view convertRect:_makeNewRapportView.rapportPartThreeButton.frame fromView:self.view];
    CGRect buttonFourFrame = [self.view convertRect:_makeNewRapportView.rapportPartFourButton.frame fromView:self.view];
    CGRect buttonFiveFrame = [self.view convertRect:_makeNewRapportView.rapportPartFiveButton.frame fromView:self.view];
    
    
    if (point.x >= buttonOneFrame.origin.x && point.y >= buttonOneFrame.origin.y && point.y <= (buttonOneFrame.origin.y + buttonOneFrame.size.height)) {
        
        for(UIView *v in _makeNewRapportView.rapportPartOneButton.subviews){
            
            if (v.alpha == 0.1f && v.tag == 0) {
                
                [v removeFromSuperview];
            }
        }
        
    }else if(point.x >= buttonTwoFrame.origin.x && point.y >= buttonTwoFrame.origin.y && point.y <= (buttonTwoFrame.origin.y + buttonTwoFrame.size.height)){
        
        for(UIView *v in _makeNewRapportView.rapportPartTwoButton.subviews){
            
            if (v.alpha == 0.1f && v.tag == 0) {
                
                [v removeFromSuperview];
            }
        }
        
    }else if(point.x >= buttonThreeFrame.origin.x && point.y >= buttonThreeFrame.origin.y && point.y <= (buttonThreeFrame.origin.y + buttonThreeFrame.size.height)){
        
        for(UIView *v in _makeNewRapportView.rapportPartThreeButton.subviews){
            
            if (v.alpha == 0.1f && v.tag == 0) {
                
                [v removeFromSuperview];
            }
        }
        
    }else if(point.x >= buttonFourFrame.origin.x && point.y >= buttonFourFrame.origin.y && point.y <= (buttonFourFrame.origin.y + buttonFourFrame.size.height)){
        
        for(UIView *v in _makeNewRapportView.rapportPartFourButton.subviews){
            
            if (v.alpha == 0.1f && v.tag == 0) {
                
                [v removeFromSuperview];
            }
        }
        
    }else if(point.x >= buttonFiveFrame.origin.x && point.y >= buttonFiveFrame.origin.y && point.y <= (buttonFiveFrame.origin.y + buttonFiveFrame.size.height)){
        
        for(UIView *v in _makeNewRapportView.rapportPartFiveButton.subviews){
            
            if (v.alpha == 0.1f && v.tag == 0) {
                
                [v removeFromSuperview];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for(UIView *v in _makeNewRapportView.rapportPartOneButton.subviews){
        
        if (v.alpha == 0.1f && v.tag == 0) {
            
            [v removeFromSuperview];
        }
    }
    
    for(UIView *v in _makeNewRapportView.rapportPartTwoButton.subviews){
        
        if (v.alpha == 0.1f && v.tag == 0) {
            
            [v removeFromSuperview];
        }
    }
    
    for(UIView *v in _makeNewRapportView.rapportPartThreeButton.subviews){
        
        if (v.alpha == 0.1f && v.tag == 0) {
            
            [v removeFromSuperview];
        }
    }
    
    for(UIView *v in _makeNewRapportView.rapportPartFourButton.subviews){
        
        if (v.alpha == 0.1f && v.tag == 0) {
            
            [v removeFromSuperview];
        }
    }
    
    for(UIView *v in _makeNewRapportView.rapportPartFiveButton.subviews){
        
        if (v.alpha == 0.1f && v.tag == 0) {
            
            [v removeFromSuperview];
        }
    }
}

- (void)markAllChaptersInvisible
{
    if (_chap1) {
        [_chap1 slideOutOfView];
        [_chap1 stopTimer];
    }
    if (_chap2) {
        [_chap2 slideOutOfView];
        [_chap2 stopTimer];
    }
    if (_chap3) {
        [_chap3 slideOutOfView];
        [_chap3 stopTimer];
    }
    if (_chap4) {
        [_chap4 slideOutOfView];
        [_chap4 stopTimer];
    }
    if (_chap5) {
        [_chap5 slideOutOfView];
    }
}

- (void)pushReport
{
    // reset all views to invisible so
    [self markAllChaptersInvisible];
    [_rapportDelegate animateNewRapportControllerBack];
}

- (void)backButtonIsPressed:(UIButton *)sender
{
    [_rapportDelegate animateNewRapportControllerBack];
}

@end
