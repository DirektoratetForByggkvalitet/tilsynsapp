//
//  DiBKRapportsView.h
//  DiBK
//
//  Created by Magnus Hasfjord on 22.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiBKRapportsView : UIView
{
    UILabel *_descriptionLabel;
    UISwipeGestureRecognizer *swipeRight;
}

@property(strong, nonatomic)UIScrollView *rapportListView;
@property(strong, nonatomic)UITableView *rapportTableView;
@property(strong, nonatomic)UIButton *infoButton;

@end
