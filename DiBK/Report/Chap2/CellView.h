//
//  CellView.h
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuditType;

@interface CellView : UITableViewCell
{
    BOOL bChecked;
    AuditType *myAuditType;
}

@property (weak, nonatomic) IBOutlet UITextView *tvAuditType;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;

- (void)setupCellViewWithAuditType:(AuditType*)auditType;
- (IBAction)btnCheckboxClicked:(id)sender;

@end
