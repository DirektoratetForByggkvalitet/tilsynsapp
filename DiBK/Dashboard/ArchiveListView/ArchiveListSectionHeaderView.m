//
//  ArchiveListSectionHeaderView.m
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ArchiveListSectionHeaderView.h"

@implementation ArchiveListSectionHeaderView
@synthesize label, selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *folderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(23, 7, 46, 41)];
        folderIcon.image = [UIImage imageNamed:@"folderIcon"];
        [self addSubview:folderIcon];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(83.0f, 0.0f, 503, 55.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:23.0f]];
        [label setTextColor:[UIColor colorWithRed:16.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:255.0f/255.0f]];
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, 503, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
        [self addSubview:line];
    }
    return self;
}

- (BOOL)selected
{
    return selected;
}

- (void)setSelected:(BOOL)s
{
    selected = s;
    
    if (!selected) {
        float c = 243.0f/255.0f;
        self.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArchiveTableViewHeaderClicked" object:self];
}

@end
