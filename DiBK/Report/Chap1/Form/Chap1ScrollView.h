//
//  Chap1ScrollView.h
//  DiBK
//
//  Created by david stummer on 17/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chap1View, DetailPageViewController, InfoPageViewController;

@interface Chap1ScrollView : UIScrollView
{
    UIScrollView *detailPageScrollView;
}

- (void)increaseHeightOfDetailPage:(int)n;
- (void)decreaseHeightOfDetailPage:(int)n;

@property(strong, nonatomic)Chap1View *chap1View;
@property(strong, nonatomic)DetailPageViewController *detailPageViewController;
@property(strong, nonatomic)InfoPageViewController *infoPageViewController;

@end
