//
//  PDFPage1.h
//  DiBK
//
//  Created by david stummer on 02/10/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFPage1VC : UIViewController
{
    UIImage *_emblem;
    
    __weak IBOutlet UIImageView *emblemView;
    __weak IBOutlet UILabel *lblKommune;
    __weak IBOutlet UILabel *lblEtter;
    __weak IBOutlet UILabel *lblSaksnmr;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblReportDate;
    __weak IBOutlet UILabel *lblTilsynetGjelder;
    __weak IBOutlet UILabel *lblTitleBackgrunn;
    __weak IBOutlet UILabel *lblFortatt;
    __weak IBOutlet UILabel *lblTilsyn;
    __weak IBOutlet UILabel *lblFortattTitle;
    __weak IBOutlet UILabel *lblTilsynTitle;
    __weak IBOutlet UILabel *lblGnrEtc;
    __weak IBOutlet UILabel *lblKommentar;
    
    __weak IBOutlet UILabel *text_14;
    __weak IBOutlet UILabel *text_15;
    __weak IBOutlet UILabel *text_16;
    __weak IBOutlet UILabel *text_17;
    __weak IBOutlet UILabel *text_18;
    __weak IBOutlet UILabel *text_19;
    __weak IBOutlet UILabel *text_20;
    __weak IBOutlet UIImageView *cb_14;
    __weak IBOutlet UIImageView *cb_15;
    __weak IBOutlet UIImageView *cb_16;
    __weak IBOutlet UIImageView *cb_17;
    __weak IBOutlet UIImageView *cb_18;
    __weak IBOutlet UIImageView *cb_19;
    __weak IBOutlet UIImageView *cb_20;
    
    __weak IBOutlet UILabel *lblAnnet;
    __weak IBOutlet UILabel *lblTitleDeltakere;
    __weak IBOutlet UILabel *lblDeltakere;
    
    __weak IBOutlet UILabel *lblAdresse;
    
    __weak IBOutlet UILabel *lblTitleStatus;
    __weak IBOutlet UILabel *text_25;
    __weak IBOutlet UILabel *text_26;
    __weak IBOutlet UILabel *text_27;
    __weak IBOutlet UILabel *text_28;
    __weak IBOutlet UILabel *text_29;
    __weak IBOutlet UILabel *text_30;
    __weak IBOutlet UILabel *text_31;
    __weak IBOutlet UILabel *text_32;
    __weak IBOutlet UILabel *text_33;
    __weak IBOutlet UILabel *text_34;
    __weak IBOutlet UILabel *text_35;
    __weak IBOutlet UIImageView *cb_25;
    __weak IBOutlet UIImageView *cb_26;
    __weak IBOutlet UIImageView *cb_27;
    __weak IBOutlet UIImageView *cb_28;
    __weak IBOutlet UIImageView *cb_29;
    __weak IBOutlet UIImageView *cb_30;
    __weak IBOutlet UIImageView *cb_31;
    __weak IBOutlet UIImageView *cb_32;
    __weak IBOutlet UIImageView *cb_33;
    __weak IBOutlet UIImageView *cb_34;
    __weak IBOutlet UIImageView *cb_35;
    
    __weak IBOutlet UILabel *lblTitaket;
    __weak IBOutlet UILabel *lblAndreKommentarer;
}

+ (UIView*)getPageWithEmblem:(UIImage*)emblem;

@end
