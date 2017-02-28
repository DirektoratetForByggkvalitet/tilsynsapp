//
//  FormScrollView.m
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FormScrollView.h"
#import "Chap3View.h"
#import "UtfylingViewController.h"

@implementation FormScrollView

@synthesize chap3View = _chap3View;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentSize:CGSizeMake(self.frame.size.width * 1, self.frame.size.height)];
        
        // Initialization code
        [self setPagingEnabled:YES];
        
        // disable vertical scrolling
        // http://stackoverflow.com/questions/5095713/disabling-vertical-scrolling-in-uiscrollview
        self.contentSize = CGSizeMake(self.contentSize.width,self.frame.size.height);
        
        // hide scrollbars
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelegate:self];
    }
    return self;
}

- (UIColor*)randColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)addPage:(UIView*)view
{
    int pageWidth = self.frame.size.width;
    int pageHeight = self.frame.size.height;
    int pageCount = (int)[self.subviews count];
    int pageOffset = pageCount * pageWidth;
    
    view.frame = CGRectMake(pageOffset, 0, pageWidth, pageHeight);
    [self addSubview:view];
    
    [self setContentSize:CGSizeMake(self.frame.size.width * [self.subviews count], self.frame.size.height)];

    
    [self performSelector:@selector(afterInit) withObject:nil afterDelay:0.1];
}

- (void)afterInit
{
    [_chap3View pageChanged:1 withTotal:[self.subviews count]];
}

-(void)scrollRight
{
    CGPoint offset = self.contentOffset;
    offset.x += 768;
    if (offset.x >= (self.subviews.count*768)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChapterThree_RightNavClicked" object:nil];
        return;
    }
    offset.x = MIN((self.subviews.count-1)*768, offset.x);
    [self setContentOffset:offset animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        float fTotal = scrollView.contentSize.width / pageWidth;
        NSInteger iTotal = lround(fTotal);
        [_chap3View pageChanged:page+1 withTotal:iTotal];
        previousPage = page;
    }
}

@end
