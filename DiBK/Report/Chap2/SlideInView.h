//
//  SlideInView.h
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideInView : UIView
{
    UISwipeGestureRecognizer *swipeRight;
}

@property (nonatomic, strong) UITableView * tableView;
@property(nonatomic,strong)UILabel* title;

@end
