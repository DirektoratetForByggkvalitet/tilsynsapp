//
//  FagomraderDetailsViewController.m
//  DiBK
//
//  Created by Niranjan Limbachiya on 6/17/13.
//
//

#import "FagomraderDetailsViewController.h"
#import "AppData.h"
#import "Template.h"
#import "SlideInViewController.h"
#import "FooterViewController.h"
#import "FagomraderViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Rapport.h"
#import "FooterView.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation FagomraderDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [mainTableView setBackgroundColor:[UIColor clearColor]];
        [mainTableView setScrollEnabled:NO];
        [mainTableView setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:mainTableView];
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        
        [self loadFooter];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeRight:) name:@"SwipeRightOutOfScreen" object:nil];

        // http://stackoverflow.com/questions/5222998/uigesturerecognizer-blocks-subview-for-handling-touch-events
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        singleTap.delegate = self;
        [self.view addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadStyle];
}

- (void)loadStyle
{
    [ColorSchemeManager updateView:self.view];
    self.view.backgroundColor = [ColorSchemeManager getBgColor];
    ivMenuIcon.image = [UIImage imageNamed:[ColorSchemeManager getCurrentColorScheme] == kColorSchemeDark ? @"MenuIcon" : @"MenuIconWhite"];
    
    text_2.text = [LabelManager getTextForParent:@"chapter_two_screen" Key:@"text_2"];
    text_3.text = [LabelManager getTextForParent:@"chapter_two_screen" Key:@"text_3"];
    text_5.text = [LabelManager getTextForParent:@"chapter_two_screen" Key:@"text_5"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    templateList = [[AppData getInstance] fetchTemplates];
}

- (void)cellViewUpdated:(NSNotification *)note {
    [footerViewController updateTemplateList:templateList];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [templateList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FagomraderViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"FagomraderViewCell";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[FagomraderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
    cell.rapportLabel.text = [(Template*)[templateList objectAtIndex:indexPath.row] templateName];
    return cell;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // here we are trying to receive the touch event everywhere on screen, apart from the table,
    // the slide-in view and the nav button at the bottom
    
    CGPoint inTable = [touch locationInView:self.view];
    if ([mainTableView pointInside:[self.view convertPoint:inTable toView:mainTableView] withEvent:nil]) {
        return NO;
    }
    if ([slideInViewController.view pointInside:[self.view convertPoint:inTable toView:slideInViewController.view] withEvent:nil]) {
        return NO;
    }
    UIView *v = footerViewController.footerView.rightNav;
    if ([v pointInside:[self.view convertPoint:inTable toView:v] withEvent:nil]) {
        return NO;
    }
    return YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)touch
{    
    slideInViewShowing = false;
    
    UIView *slideInView = slideInViewController.view;
    
    [UIView animateWithDuration:0.75f animations:^{
        
        slideInView.center = CGPointMake(self.view.center.x + self.view.frame.size.width, slideInView.center.y);
        
    } completion:^(BOOL finished){}];
}

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    slideInViewShowing = false;
    
    UIView *slideInView = slideInViewController.view;
    
    [UIView animateWithDuration:0.75f animations:^{
        
        slideInView.center = CGPointMake(self.view.center.x + self.view.frame.size.width, slideInView.center.y);
        
    } completion:^(BOOL finished){}];
}

- (void)loadFooter
{
    footerViewController = [[FooterViewController alloc] init];
    [self addChildViewController:footerViewController];
    [footerViewController didMoveToParentViewController:self];
    [self.view addSubview:footerViewController.view];
    
    CGRect rect = CGRectMake(0, 701, self.view.frame.size.width, 300);
    footerViewController.view.frame = rect;
    
    [footerViewController updateTemplateList:templateList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellViewUpdated:) name:@"CellViewUpdated" object:nil];
}

-(void)shutdown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)slideOutOfView
{
    if (slideInViewController != nil) {
        [slideInViewController removeFromParentViewController];
        [slideInViewController.view removeFromSuperview];
        slideInViewController = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (slideInViewController == nil) {
        slideInViewController = [[SlideInViewController alloc] init];
        [self.parentViewController addChildViewController:slideInViewController];
        [slideInViewController didMoveToParentViewController:self.parentViewController];
        [self.view.superview addSubview:slideInViewController.view];
    }
    
    UIView *slideInView = slideInViewController.view;
    
    Template *template = [templateList objectAtIndex:indexPath.row];
    [slideInViewController updateView: template];
    
    if (slideInViewShowing) {
        return;
    }
    
    // reset the center of it's view firstly
    [slideInView setCenter:CGPointMake(slideInView.center.x + self.view.frame.size.width, slideInView.center.y)];
    
    [UIView animateWithDuration:0.75f animations:^{
        CGRect frame = slideInView.frame;
        frame.origin.x = 301;
        slideInView.frame = frame;
    } completion:^(BOOL finished) {
        slideInViewShowing = true;
    }];
}

- (void)doSave
{
    NSLog(@"--Save data Chap 2 is being called---");
    
    AppData *appData = [AppData getInstance];
    Rapport *report = appData.currentReport;
    NSDate* date = [NSDate date];
    if (report.dateCreated == nil) {
        report.dateCreated = date;
    }
    report.dateLastEdited = date;
    [appData save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    mainTableView = nil;
    ivMenuIcon = nil;
    text_2 = nil;
    text_3 = nil;
    text_5 = nil;
    [super viewDidUnload];
}
@end
