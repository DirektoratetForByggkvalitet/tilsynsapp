//
//  DiBKRapportPartButton.m
//  DiBK
//
//  Created by Grafiker2 on 04.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DiBKRapportPartButton.h"
#import "ColorSchemeManager.h"

@implementation DiBKRapportPartButton
@synthesize numberLabel = _numberLabel;
@synthesize headerLabel = _headerLabel;
@synthesize descriptionLabel = _descriptionLabel;

- (void)updateColorScheme
{
    BOOL isDark = [ColorSchemeManager getCurrentColorScheme] == kColorSchemeDark;
    UIColor *textColor =  isDark ? [UIColor whiteColor] : [ColorSchemeManager getDarkBlueColor];
    
    [_headerLabel setTextColor:textColor];
    [_descriptionLabel setTextColor:textColor];
    
    [_backgroundImageView setImage:[UIImage imageNamed:isDark?@"rapportPartButton":@"rapportPartButtonWhite"]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_backgroundImageView setImage:[UIImage imageNamed:@"rapportPartButton"]];
        [_backgroundImageView setUserInteractionEnabled:YES];
        
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x + 15.0f, self.bounds.origin.y + 32.0f, 44.0f, 44.0f)];
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0f]];
        
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(_numberLabel.frame.origin.x + _numberLabel.frame.size.width + 15.0f, self.bounds.origin.y + 10.0f, self.bounds.size.width - (_numberLabel.frame.origin.x + _numberLabel.frame.size.width) - 10.0f, 44.0f)];
        [_headerLabel setBackgroundColor:[UIColor clearColor]];
        [_headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
        [_headerLabel setTextColor:[UIColor whiteColor]];
        
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerLabel.frame.origin.x, _headerLabel.frame.origin.y + _headerLabel.frame.size.height - 10.0f, _headerLabel.frame.size.width - 20.0f, 50.0f)];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        [_descriptionLabel setTextColor:[UIColor whiteColor]];
        [_descriptionLabel setNumberOfLines:0];
        
        [self addSubview:_backgroundImageView];
        [self addSubview:_numberLabel];
        [self addSubview:_headerLabel];
        [self addSubview:_descriptionLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateColorScheme) name:@"SwitchColorScheme" object:nil];
        [self updateColorScheme];
    }
    return self;
}

@end
