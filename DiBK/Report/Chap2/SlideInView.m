//
//  SlideInView.m
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "SlideInView.h"
#import "LabelManager.h"

@implementation SlideInView
@synthesize tableView, title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(23, 36, 437, 60)];
        [title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:34]];
        [title setTextColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1]];
        [title setText:@"Universell Untforming"];
        title.minimumFontSize = 10;
        title.adjustsFontSizeToFitWidth = YES;
        [self addSubview:title];
        
        UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(23, 85, 467, 50)];
        [subtitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
        [subtitle setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1]];
        subtitle.text = [LabelManager getTextForParent:@"chapter_two_screen" Key:@"text_4"];
        [self addSubview:subtitle];
        
        // grey bar above table view
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 199, 467, 1)];
        [line2 setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
        [self addSubview:line2];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 476, 800) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:tableView];
        
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1024)];
        leftBorder.backgroundColor = [UIColor blackColor];
        [self addSubview:leftBorder];
        
        swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

-(void) swipeRight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwipeRightOutOfScreen" object:self userInfo:nil];
}

@end
