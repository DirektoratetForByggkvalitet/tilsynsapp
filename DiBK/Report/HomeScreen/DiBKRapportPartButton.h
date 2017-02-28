//
//  DiBKRapportPartButton.h
//  DiBK
//
//  Created by Grafiker2 on 04.03.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiBKRapportPartButton : UIView
{
    UIImageView *_backgroundImageView;
}

@property(strong, nonatomic)UILabel *numberLabel;
@property(strong, nonatomic)UILabel *headerLabel;
@property(strong, nonatomic)UILabel *descriptionLabel;

@end
