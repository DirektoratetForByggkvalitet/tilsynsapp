//
//  FooterViewController.h
//  DiBK
//
//  Created by david stummer on 25/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FooterView;

@interface FooterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *footerTableView;
    NSMutableArray *templateList;
}

@property(nonatomic,strong)FooterView *footerView;
- (void)updateTemplateList:(NSArray*)templates;

@end
