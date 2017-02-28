//
//  FagomraderDetailsViewController.h
//  DiBK

#import <UIKit/UIKit.h>

@class SlideInViewController, FooterViewController;

@interface FagomraderDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray *templateList;
    SlideInViewController *slideInViewController;
    BOOL slideInViewShowing;
    FooterViewController *footerViewController;
    __weak IBOutlet UITableView *mainTableView;
    __weak IBOutlet UIImageView *ivMenuIcon;
    __weak IBOutlet UILabel *text_2;
    __weak IBOutlet UILabel *text_3;
    __weak IBOutlet UILabel *text_5;
}

- (void)doSave;
- (void)slideOutOfView;
- (void)shutdown;

@end
