//
//  ArchiveListViewController.h
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArchiveListView;

@interface ArchiveListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    ArchiveListView *archiveListView;
    UITableView *tableView;
    NSArray *foldersAndFiles;
    NSMutableArray *cellArray;
    NSMutableArray *cellCount;
    NSMutableArray *allFileInfos;
    UISwipeGestureRecognizer *swipeRight;
}

- (void)slideIn;

@end
