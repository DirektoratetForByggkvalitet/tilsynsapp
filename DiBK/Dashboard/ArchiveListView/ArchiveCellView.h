//
//  CellView.h
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArchiveFileInfo;

@interface ArchiveCellView : UITableViewCell
{
    ArchiveFileInfo *fileInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *lblFilename;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *lblFailed;

- (void)setupCellViewWithFile:(ArchiveFileInfo*)fileInfo;

@end
