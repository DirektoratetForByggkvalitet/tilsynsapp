//
//  PDFPageSplitter.m
//  DiBK
//
//  Created by david stummer on 07/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFPageSplitter.h"
#import "PDFUtils.h"

@implementation PDFPageSplitter

+ (UIView*)findClosestSplitPointInPage:(UIView*)page
{
    int PAGE_HEIGHT = 902;
    int SPLIT_TAG = 99;
    UIView *splitPoint = nil;
    for (UIView *v in page.subviews) {
        if (v.tag == SPLIT_TAG && v.frame.origin.y <= PAGE_HEIGHT) {
            if (splitPoint == nil) {
                splitPoint = v;
            }
            if (v.frame.origin.y > splitPoint.frame.origin.y) {
                splitPoint = v;
            }
        }
    }
    return splitPoint;
}

+ (BOOL)splitPoint:(UIView*)splitPoint isFirstElementInPage:(UIView*)page
{
    if (page.subviews.count <= 0) {
        return NO;
    }
    return page.subviews[0] == splitPoint;
}

+ (NSMutableArray*)getContentBelowSplitPoint:(UIView*)splitPoint inPage:(UIView*)page
{
    NSMutableArray *subViews = [NSMutableArray new];
    for (UIView *v in page.subviews) {
        if (v.frame.origin.y >= splitPoint.frame.origin.y) {
            [v removeFromSuperview];
            [subViews addObject:v];
        }
    }
    return subViews;
}

+ (UIView*)genNewPageWithRippedcontent:(NSMutableArray*)subViews
{
    int PAGE_HEIGHT = 902, TOP_PADDING = 20;
    int pageTop = PAGE_HEIGHT, pageBottom = 0;
    for (UIView *v in subViews) {
        int bottom = v.frame.origin.y+v.frame.size.height;
        if (bottom > pageBottom) {
            pageBottom = bottom;
        }
        int top = v.frame.origin.y;
        if (top < pageTop) {
            pageTop = top;
        }
    }
    pageBottom += TOP_PADDING;
    int pageHeight = pageBottom - pageTop;
    UIView *page = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 612, pageHeight)];
    for (UIView *v in subViews) {
        [PDFUtils adjustY:-pageTop forView:v];
        [PDFUtils adjustY:TOP_PADDING forView:v];
        [page addSubview:v];
    }
    return page;
}

+ (void)processPage:(UIView*)page pages:(NSMutableArray**)validPages
{
    int PAGE_HEIGHT = 902; // A4 page height in pixels (minus the 30 pixel-high footer)
    
    CGRect pageFrame = page.frame;
    if (pageFrame.size.height <= PAGE_HEIGHT) {
        [PDFUtils setHeight:PAGE_HEIGHT forView:page];
        [*validPages addObject:page];
    } else {
        UIView *splitPoint = [self findClosestSplitPointInPage:page];
        if (!splitPoint || [self splitPoint:splitPoint isFirstElementInPage:page]) {
            // we cannot split any further, so just add this elongated page
            [*validPages addObject:page];
        } else {
            NSMutableArray *subViews = [self getContentBelowSplitPoint:splitPoint inPage:page];
            [PDFUtils setHeight:PAGE_HEIGHT forView:page];
            [*validPages addObject:page];
            
            UIView *newPage = [self genNewPageWithRippedcontent:subViews];
            [self processPage:newPage pages:validPages];
        }
    }
}

+ (NSMutableArray*)extractPagesInPage:(UIView*)page
{
    NSMutableArray *validPages = [NSMutableArray new];
    [PDFUtils makeAllDescendantsTopLevel:page forPage:page];
    [self processPage:page pages:&validPages];
    return validPages;
}

@end
