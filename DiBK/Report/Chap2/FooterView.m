//
//  FooterView.m
//  DiBK
//
//  Created by david stummer on 25/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FooterView.h"
#import "LabelManager.h"

@implementation FooterView

@synthesize tableView, rightNav;
@synthesize frontPageButton = _frontPageButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(110, 80, 600, 120) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setSeparatorColor:[UIColor clearColor]];
        [self addSubview:tableView];
        
        rightNav = [[UIButton alloc] initWithFrame:CGRectMake(710, 145, 46, 43)];
        [rightNav setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        [self addSubview:rightNav];
        
        _frontPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_frontPageButton setTitle:[LabelManager getTextForParent:@"general" Key:@"back_menu"] forState:UIControlStateNormal];
        [_frontPageButton setFrame:CGRectMake(10, 145, 150, 43)];
        [_frontPageButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f]];
        [_frontPageButton addTarget:self action:@selector(navigateToFrontPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:52.0f/255.0f green:79.0f/255.0f blue:87.0f/255.0f alpha:1]];
        [self addSubview:line];
        [self addSubview:_frontPageButton];
    }
    return self;
}

-(void) navigateToFrontPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateBackToFrontPage" object:nil];
    [self endEditing:YES];
}

@end
