//
//  FormScrollView.h
//  DiBK
//
//  Created by david stummer on 15/06/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chap3View;

@interface FormScrollView : UIScrollView <UIScrollViewDelegate>

@property(strong, nonatomic)Chap3View *chap3View;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)addPage:(UIView*)view;
- (void)scrollRight;

@end
