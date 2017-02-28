//
//  ArchiveListView.m
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ArchiveListView.h"
#import "LabelManager.h"

@implementation ArchiveListView
@synthesize mainView, tableView;

- (void)updateLabels
{
    title.text = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_5"];
    subtitle.text = [LabelManager getTextForParent:@"archive_screen" Key:@"text_1"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"SwitchLanguage" object:nil];
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(265, 0, 503, 1024)];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        
        UIImageView *doc = [[UIImageView alloc] initWithFrame:CGRectMake(28, 29, 52, 56)];
        doc.image = [UIImage imageNamed:@"docArchive"];
        [mainView addSubview:doc];
        
        CGRect frame = doc.frame;
        frame.origin.x += frame.size.width + 20;
        frame.size.width = 320;
        title = [[UILabel alloc]initWithFrame:frame];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0f]];
        [title setTextColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1.0f]];
        [title setText:@"Dokumentarkiv"];
        [mainView addSubview:title];
        
        CGRect frame2 = frame;
        frame2.origin.x += frame2.size.width + 5;
        frame2.origin.y += 15;
        frame2.size.width = 29;
        frame2.size.height = 29;
        UIButton *info = [UIButton buttonWithType:UIButtonTypeCustom];
        info.frame = frame2;
        [info setImage:[UIImage imageNamed:@"infoButtonColor"] forState:UIControlStateNormal];
        
        frame = doc.frame;
        frame.origin.x += 5;
        frame.origin.y += 80;
        frame.size.width = 450;
        subtitle = [[UILabel alloc]initWithFrame:frame];
        [subtitle setBackgroundColor:[UIColor clearColor]];
        subtitle.numberOfLines = 0;
        subtitle.lineBreakMode = UILineBreakModeWordWrap;
        [subtitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f]];
        [subtitle setTextColor:[UIColor blackColor]];
        [subtitle setText:@"Her finner du dine siste dokumenter"];
        [mainView addSubview:subtitle];
        
        frame.origin.y += 88;
        frame.origin.x = 0;
        frame.size.width = 503;
        frame.size.height = 700;
        tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [mainView addSubview:tableView];
        
        UIView *l = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, 503, 1)];
        [l setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
        [mainView addSubview:l];
        
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(265, 0, 1, 1024)];
        leftBorder.backgroundColor = [UIColor blackColor];
        [self addSubview:leftBorder];
        
        [self updateLabels];
    }
    return self;
}

@end