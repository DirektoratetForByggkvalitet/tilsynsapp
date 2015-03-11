//
//  Chap1ScrollView.m
//  DiBK
//
//  Created by david stummer on 17/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Chap1ScrollView.h"
#import "Chap1View.h"
#import "DetailPageViewController.h"
#import "InfoPageViewController.h"

@implementation Chap1ScrollView
@synthesize chap1View = _chap1View;
@synthesize detailPageViewController, infoPageViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height)];
        [self setPagingEnabled:YES];
        
        // disable vertical scrolling
        // http://stackoverflow.com/questions/5095713/disabling-vertical-scrolling-in-uiscrollview
        self.contentSize = CGSizeMake(self.contentSize.width,self.frame.size.height);
        
        // hide scrollbars
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelegate:self];
        [self addPages];
        [self performSelector:@selector(afterInit) withObject:nil afterDelay:0.1];
    }
    return self;
}

- (void)addPages
{
    int pageWidth = self.frame.size.width;
    int pageHeight = self.frame.size.height;
    int pageCount = 0;
    int pageOffset = pageCount * pageWidth;
    
    infoPageViewController = [[InfoPageViewController alloc]initWithNibName:@"InfoPageViewController" bundle:nil];
    infoPageViewController.view.frame = CGRectMake(pageOffset, 0, pageWidth, pageHeight);
    
    [self addSubview:infoPageViewController.view];
    
    pageCount = 1;
    pageOffset = pageCount * pageWidth;    
    
    detailPageViewController = [[DetailPageViewController alloc]initWithNibName:@"DetailPageViewController" bundle:nil];
    detailPageViewController.view.frame = CGRectMake(0, 0, pageWidth, pageHeight);
    
    CGRect frame = CGRectMake(pageOffset, 0, pageWidth, pageHeight);
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:frame];
    detailPageScrollView = sv;
    [detailPageViewController setParentVerticalScrollView:self];

    [sv addSubview:detailPageViewController.view];
    [self addSubview:sv];
    [sv setContentSize:CGSizeMake(pageWidth, pageHeight)];
}

- (void)increaseHeightOfDetailPage:(int)n
{
    CGRect frame = detailPageViewController.view.frame;
    frame.size.height += 95;
    detailPageViewController.view.frame = frame;
    [detailPageScrollView setContentSize:CGSizeMake(self.frame.size.width, detailPageViewController.view.frame.size.height-150)];
}

- (void)decreaseHeightOfDetailPage:(int)n
{
    CGRect frame = detailPageViewController.view.frame;
    frame.size.height -= 50*n;
    detailPageViewController.view.frame = frame;
    [detailPageScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height+50*n)];
}

- (void) afterInit
{
    [_chap1View pageChanged:1 withTotal:2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static int previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    int page = (int)lround(fractionalPage);
    if (previousPage != page) {
        float fTotal = scrollView.contentSize.width / pageWidth;
        int iTotal = (int)lround(fTotal);
        [_chap1View pageChanged:page+1 withTotal:iTotal];
        previousPage = page;
    }
}

@end
