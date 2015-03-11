//
//  FagomraderViewCell.m
//  DiBK
//
//  Created by david stummer on 26/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FagomraderViewCell.h"
#import "ColorSchemeManager.h"

@implementation FagomraderViewCell

@synthesize rapportLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        rapportLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 5.0f, 650.0f, 44.0f)];
        [rapportLabel setBackgroundColor:[UIColor clearColor]];
        [rapportLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:31.7f]];
        [rapportLabel setTextColor:[ColorSchemeManager getTextColor]];

        _selectedBgView = [[UIView alloc]initWithFrame:self.frame];
        [_selectedBgView setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1.0f]];
        
        self.selectedBackgroundView = _selectedBgView;
        
        [self.contentView addSubview:rapportLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [rapportLabel setTextColor:selected?[UIColor whiteColor]:[ColorSchemeManager getTextColor]];

    // Configure the view for the selected state
}

@end
