//
//  SlideInViewController.h
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideInView, Template;

@interface SlideInViewController : UIViewController <UITableViewDelegate,
                                                     UITableViewDataSource>
{
    SlideInView *slideInView;
    UITableView *slideInTableView;
    NSArray *allChecklists;
    NSMutableArray *cellArray;
    NSMutableArray *cellCount;
    NSMutableArray *allAuditTypes;
}

- (void)updateView:(Template*)template;

@end
