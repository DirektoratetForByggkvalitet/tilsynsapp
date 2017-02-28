//
//  CellView.m
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "CellView.h"
#import "AuditType.h"

@implementation CellView

@synthesize btnCheckbox, tvAuditType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCellViewWithAuditType:(AuditType *)auditType
{
    bChecked = auditType.isChecked;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    myAuditType = auditType;
    
    tvAuditType.text = auditType.auditTypeName;
    
    if(!bChecked){
        [btnCheckbox setImage:[UIImage imageNamed:@"cbunchecked"] forState:normal];
    }
    else{
        [btnCheckbox setImage:[UIImage imageNamed:@"cbchecked"] forState:normal];
    }
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
    [self addSubview:line2];
    
    // solves layout issues on IOS7
    [self performSelector:@selector(doDisplay) withObject:self afterDelay:0];
}

-(void)doDisplay
{
    int numLines = tvAuditType.contentSize.height / tvAuditType.font.lineHeight;
    //NSLog(@"LINES: %d", numLines);
    int y = numLines <= 1 ? 8 : -2;
    CGRect f = tvAuditType.frame;
    f.origin.y = y;
    tvAuditType.frame = f;
    [self setNeedsDisplay];
}

- (IBAction)btnCheckboxClicked:(id)sender
{
    if(bChecked){
        [btnCheckbox setImage:[UIImage imageNamed:@"cbunchecked"] forState:normal];
        bChecked = FALSE;
        myAuditType.isChecked = false;
    }
    else{
        [btnCheckbox setImage:[UIImage imageNamed:@"cbchecked"] forState:normal];
        bChecked = TRUE;
        myAuditType.isChecked = true;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellViewUpdated" object:myAuditType];
}

@end
