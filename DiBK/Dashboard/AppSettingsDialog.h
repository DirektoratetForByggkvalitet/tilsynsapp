//
//  Popover.h
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppSettingsDialog : UIView
{
    UIImageView *background;
    UILabel *title;
    UIButton *b2, *b3, *b4;
}

- (void)doShow;

@end
