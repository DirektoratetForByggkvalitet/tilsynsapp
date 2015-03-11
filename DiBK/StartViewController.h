//
//  DiBKStartViewController.h
//  DiBK
//
//  Created by Magnus Hasfjord on 19.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartView.h"

@interface StartViewController : UIViewController<UITextFieldDelegate>
{
    BOOL _bokmalIsChosen;
    BOOL _termsIsAccepted;
}

@property(strong, nonatomic)StartView *startView;
@property(strong, nonatomic)NSManagedObjectContext *managedObjectContext;

- (void)animateStartingView;
- (void)bokmalButtonsPressed:(UIButton *)sender;
- (void)nynorskButtonsPressed:(UIButton *)sender;
- (void)continueButtonPressed:(UIButton *)sender;


@end
