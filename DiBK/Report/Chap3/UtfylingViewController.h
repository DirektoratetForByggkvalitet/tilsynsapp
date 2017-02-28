//
//  UtfylingViewController.h
//  DiBK


#import <UIKit/UIKit.h>

@class AuditType;

@interface UtfylingViewController : UIViewController
{
    AuditType *auditType;
    NSInteger nQuestions;
    NSMutableArray *questionViews;
}

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithAuditType:(AuditType*)auditType;
- (void)shutdown;

@end
