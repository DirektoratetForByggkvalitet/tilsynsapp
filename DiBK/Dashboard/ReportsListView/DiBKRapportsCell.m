//
//  DiBKRapportsCell.m
//  DiBK
//
//  Created by Grafiker2 on 27.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DiBKRapportsCell.h"

@implementation DiBKRapportsCell

@synthesize rapportLabel = _rapportLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _rapportLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 0.0f, 400.0f, 44.0f)];
        [_rapportLabel setBackgroundColor:[UIColor clearColor]];
        [_rapportLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0f]];
        [_rapportLabel setTextColor:[UIColor colorWithRed:17.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_rapportLabel.frame.origin.x + _rapportLabel.frame.size.width + 10.0f, _rapportLabel.frame.origin.y, 105.0f, _rapportLabel.frame.size.height)];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        [_dateLabel setTextColor:[UIColor colorWithRed:150.0f/255.0f green:173.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
        
        _selectedBgView = [[UIView alloc]initWithFrame:self.frame];
        [_selectedBgView setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:1.0f]];
        
        self.selectedBackgroundView = _selectedBgView;
        
        [self.contentView addSubview:_rapportLabel];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
