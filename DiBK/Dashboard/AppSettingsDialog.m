//
//  Popover.m
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "AppSettingsDialog.h"
#import "FileSystemUtils.h"
#import "ColorSchemeManager.h"
#import "LabelManager.h"

@implementation AppSettingsDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        background = [[UIImageView alloc] initWithFrame:CGRectMake(70, 760, 307, 224)];
        background.image = [UIImage imageNamed:@"popoverBg"];
        [self addSubview:background];
        
        CGRect frame = CGRectMake(28, 10, 225, 40);
        title = [[UILabel alloc] initWithFrame:frame];
        title.text = @"Innstillinger";
        title.textColor = [UIColor blackColor];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f];
        title.minimumFontSize = 10;
        title.adjustsFontSizeToFitWidth = YES;
        [background addSubview:title];
        
        CGRect frameB1 = frame;
        frameB1.origin.y += 48;
        frameB1 = [self convertRect:frameB1 fromView:background];

        b2 = [[UIButton alloc] initWithFrame:frameB1];
        b2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [b2 addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
        [b2 setTitle:@"Clear Cache" forState:UIControlStateNormal];
        [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b2.titleLabel.minimumFontSize = 10;
        b2.titleLabel.adjustsFontSizeToFitWidth = YES;

        b3 = [[UIButton alloc] initWithFrame:frameB1];
        b3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [b3 addTarget:self action:@selector(switchScheme) forControlEvents:UIControlEventTouchUpInside];
        [b3 setTitle:@"Switch Color Scheme" forState:UIControlStateNormal];
        [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b3.titleLabel.minimumFontSize = 10;
        b3.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:b3];
        
        frameB1.origin.y += frameB1.size.height;
        b4 = [[UIButton alloc] initWithFrame:frameB1];
        b4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [b4 addTarget:self action:@selector(switchLanguage) forControlEvents:UIControlEventTouchUpInside];
        [b4 setTitle:@"dave" forState:UIControlStateNormal];
        [b4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        b4.titleLabel.minimumFontSize = 10;
        b4.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:b4];
        
        self.hidden = YES;
        
        [self updateLabels];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"SwitchColorScheme" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:@"SwitchLanguage" object:nil];
    }
    return self;
}

- (void)updateLabels
{
    background.image = [UIImage imageNamed:@"popoverBgWhite"];
    
    title.text = [LabelManager getTextForParent:@"settings_dialog" Key:@"text_1"];
    [b2 setTitle:[LabelManager getTextForParent:@"settings_dialog" Key:@"text_3"] forState:UIControlStateNormal];
    [b3 setTitle:[LabelManager getTextForParent:@"settings_dialog" Key:@"text_4"] forState:UIControlStateNormal];

    NSString *switchToStr = [LabelManager getTextForParent:@"settings_dialog" Key:@"switch_to"];
    NSString *langStr = [LabelManager getTextForParent:@"settings_dialog" Key:[LabelManager getCurrentLanguage]==kLanguageBokmal?@"locale_nn":@"locale_nb"];
    NSString *str = [NSString stringWithFormat:@"%@ %@", switchToStr, langStr];
    [b4 setTitle:str forState:UIControlStateNormal];
}

- (void)switchLanguage
{
    [LabelManager switchLanguage];
}

- (void)switchScheme
{
    [ColorSchemeManager switchColorScheme];
}

- (void)doShow
{
    self.hidden = NO;
}

- (void)doHide
{
    self.hidden = YES;
}

-(void)clearCache
{
    [FileSystemUtils clearDownloadCache];
    [self doHide];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i<[touchesArray count]; i++)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        
        if (!CGRectContainsPoint(background.frame, point)) {
            [self doHide];
            return;
        }
    }
}

@end