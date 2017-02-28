//
//  DiBKRapportsCell.h
//  DiBK
//
//  Created by Grafiker2 on 27.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiBKRapportsCell : UITableViewCell
{
    UIView *_selectedBgView;
}

@property(strong, nonatomic)UILabel *rapportLabel;
@property(strong, nonatomic)UILabel *dateLabel;

@end
