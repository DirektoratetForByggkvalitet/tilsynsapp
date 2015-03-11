//
//  DiBKRapportsView.m
//  DiBK
//
//  Created by Magnus Hasfjord on 22.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DiBKRapportsView.h"
#import "LabelManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation DiBKRapportsView

@synthesize rapportListView = _rapportListView;
@synthesize rapportTableView = _rapportTableView;
@synthesize infoButton = _infoButton;

-(void)updateLabels
{
    _descriptionLabel.text = [LabelManager getTextForParent:@"dashboard_screen" Key:@"text_4"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _rapportListView = [[UIScrollView alloc]initWithFrame:CGRectMake(round(frame.size.width / 2) - 150.0f, 0.0f, round(frame.size.width / 2) + 150.0f, frame.size.height)];
        [_rapportListView setBackgroundColor:[UIColor whiteColor]];
        [_rapportListView setContentSize:CGSizeMake(_rapportListView.frame.size.width, frame.size.height * 2)];
        
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 20.0f, _rapportListView.frame.size.width - 100.0f, 100.0f)];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0f]];
        [_descriptionLabel setTextColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1.0f]];
        [_descriptionLabel setText:@"Pågående tilsyn"];
        
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setFrame:CGRectMake(_descriptionLabel.frame.origin.x + _descriptionLabel.frame.size.width + 10.0f, _descriptionLabel.frame.origin.y + 35.0f, 29.0f, 29.0f)];
        [_infoButton setImage:[UIImage imageNamed:@"infoButtonColor"] forState:UIControlStateNormal];
        
        _rapportTableView = [[UITableView alloc]initWithFrame:CGRectMake(_rapportListView.bounds.origin.x, _rapportListView.bounds.origin.y + 200.0f, _rapportListView.bounds.size.width, _rapportListView.bounds.size.height) style:UITableViewStylePlain];
        [_rapportTableView setBackgroundColor:[UIColor clearColor]];
        [_rapportTableView setScrollEnabled:NO];
        [_rapportTableView setSeparatorColor:[UIColor colorWithRed:188.0f/255.0f green:188.0f/255.0f blue:188.0f/255.0f alpha:1.0f]];

        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rapportListView];
        [_rapportListView addSubview:_rapportTableView];
        [_rapportListView addSubview:_descriptionLabel];
        
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1024)];
        leftBorder.backgroundColor = [UIColor blackColor];
        [_rapportListView addSubview:leftBorder];
        
        swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [_rapportListView addGestureRecognizer:swipeRight];
        
        [self updateLabels];
    }
    return self;
}

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwipeRight" object:nil];
}

@end
