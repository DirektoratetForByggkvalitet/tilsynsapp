//
//  PDFConclusionPage.h
//  DiBK
//
//  Created by david stummer on 04/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFConclusionPage : UIViewController
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblVurderingTitle;
    __weak IBOutlet UILabel *lblVerduringText;
    __weak IBOutlet UILabel *lblOppTitle;
    __weak IBOutlet UILabel *lblOppText;
    __weak IBOutlet UILabel *lblJaiNeiTitle;
    __weak IBOutlet UILabel *lblJaiNeiText;
}

+ (UIView*)getPage;

@end
