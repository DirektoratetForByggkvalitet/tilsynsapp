//
//  DiBKRapportsViewController.h
//  DiBK
//
//  Created by Magnus Hasfjord on 22.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiBKRapportsView.h"
#import "UserInfo.h"

@protocol DiBKRapportsDelegateProtocol <NSObject>

- (void)animateControllerBack;
- (void)existingReportSelectedInTable:(Rapport*)report;

@end

@interface DiBKRapportsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *reports;
}

@property(strong, nonatomic)DiBKRapportsView *rapportsView;
@property(weak, nonatomic)id<DiBKRapportsDelegateProtocol>rapportDelegate;
@property(strong, nonatomic)UserInfo *user;

@end
