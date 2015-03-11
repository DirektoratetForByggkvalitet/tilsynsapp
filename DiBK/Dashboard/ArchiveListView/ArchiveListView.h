//
//  ArchiveListView.h
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveListView : UIView
{
    UILabel *title, *subtitle;
}

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITableView *tableView;

@end
