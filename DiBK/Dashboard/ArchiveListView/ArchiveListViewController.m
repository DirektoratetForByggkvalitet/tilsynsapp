//
//  ArchiveListViewController.m
//  DiBK
//
//  Created by david stummer on 24/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "ArchiveListViewController.h"
#import "ArchiveListView.h"
#import "ArchiveListSectionHeaderView.h"
#import "ArchiveListRetriever.h"
#import "ArchiveCellView.h"

@implementation ArchiveListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view = archiveListView = [[ArchiveListView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        self.view.hidden = YES;
        tableView = archiveListView.tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 55;
        tableView.sectionHeaderHeight = 55;

        UINib *nib = [UINib nibWithNibName:@"ArchiveCellView" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"ArchiveCellView"];
        
        swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [archiveListView.mainView addGestureRecognizer:swipeRight];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerViewClicked:) name:@"ArchiveTableViewHeaderClicked" object:nil];
    }
    return self;
}

- (void)updateView
{
    foldersAndFiles = [ArchiveListRetriever getAll];
    cellArray = [NSMutableArray new];
    cellCount = [NSMutableArray new];
    allFileInfos = [NSMutableArray new];
    for (ArchiveFolderInfo *folderInfo in foldersAndFiles) {
        NSMutableArray *files = folderInfo.files;
        [allFileInfos addObjectsFromArray:files];
        [cellArray addObject:files];
        [cellCount addObject:[NSNumber numberWithInt:files.count]];
    }
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[cellCount objectAtIndex:section] intValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return foldersAndFiles.count;
}

- (ArchiveCellView*)getCellView
{
    ArchiveCellView *cv = [ArchiveCellView new];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArchiveCellView" owner:cv options:nil];
    
    ArchiveCellView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[ArchiveCellView class]])
            blah = (ArchiveCellView *)object;
    }
    assert(blah != nil && "blah can't be nil");
    return blah;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ArchiveCellView *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"ArchiveCellView";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    ArchiveFileInfo *fileInfo = [[cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setupCellViewWithFile:fileInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveFileInfo *fileInfo = [[cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (fileInfo.isCurrentlyDownloading) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPDF" object:fileInfo.path];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ArchiveFolderInfo *folder = [foldersAndFiles objectAtIndex:section];
    
    ArchiveListSectionHeaderView *headerView = [[ArchiveListSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 323, 84)];
    headerView.label.text = folder.name;
    headerView.selected = ([[cellCount objectAtIndex:section] intValue] == 0);
    headerView.tag = section + 1;
    
    return  headerView;
}

- (void)headerViewClicked:(NSNotification*)note
{
    ArchiveListSectionHeaderView *sectionHeaderView = (ArchiveListSectionHeaderView*)note.object;
    
    NSInteger index = sectionHeaderView.tag - 1;
    
    if(!sectionHeaderView.selected)
        [cellCount replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
    else
        [cellCount replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:[[cellArray objectAtIndex:index]count]]];
    
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ArchiveFileInfo *fileInfo = [[cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        fileInfo.path = [[ArchiveListRetriever getDefaultFolderPath] stringByAppendingPathComponent:fileInfo.name];
        
        NSError *error;
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:fileInfo.path]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fileInfo.path error:&error];
            if (success) {
                NSLog(@"File deleted. Path: %@", fileInfo.path);
            }else
            {
                NSLog(@"File not deleted ");
            }
        }
        [self updateView];
    } 
}

- (void)slideIn
{
    if (!self.view.hidden) {
        return;
    }
    
    [self updateView];
    
    self.view.hidden = NO;
    self.view.center = CGPointMake((self.view.superview.frame.size.width*1.5f), self.view.center.y);
    [self.view.superview bringSubviewToFront:self.view];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake((self.view.superview.frame.size.width*0.5f), self.view.center.y);
    } completion:^(BOOL finished) {
    }];
}

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self doHide];
}

- (void)doHide
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.center = CGPointMake((self.view.superview.frame.size.width*1.5f), self.view.center.y);
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i<[touchesArray count]; i++)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        
        if (!CGRectContainsPoint(archiveListView.mainView.frame, point)) {
            [self doHide];
            return;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
