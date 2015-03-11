//
//  DiBKRapportsViewController.m
//  DiBK
//
//  Created by Magnus Hasfjord on 22.02.13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "DiBKRapportsViewController.h"
#import "DiBKRapportsCell.h"
#import "Rapport.h"
#import "AppData.h"
#import <QuartzCore/QuartzCore.h>
#import "AppUtils.h"
#import "AppData.h"

@implementation DiBKRapportsViewController
@synthesize rapportsView = _rapportsView;
@synthesize rapportDelegate = _rapportDelegate;
@synthesize user = _user;

- (void)loadView
{
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    _rapportsView = [[DiBKRapportsView alloc]initWithFrame:screenSize];
    
    [_rapportsView.rapportTableView setDelegate:self];
    [_rapportsView.rapportTableView setDataSource:self];
    
    self.view = _rapportsView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeRight) name:@"SwipeRight" object:nil];
}

-(void) swipeRight
{
   [_rapportDelegate animateControllerBack];
}

-(void)generateReportsArray
{
    assert(_user);
    NSMutableArray *arr = [[_user.rapports sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateLastEdited" ascending:NO]]] mutableCopy];
    reports = [[NSMutableArray alloc] init];
    for (Rapport *report in arr) {
        if (!report.isComplete) {
            [reports addObject:report];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Had to add this due to empty row reappearing after delete
    _rapportsView.rapportTableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self calculateTableViewHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(UserInfo *)user
{
    if (user != nil) {
        _user = nil;
        _user = user;
    }
    
    [self calculateTableViewHeight];
    [self generateReportsArray];
}

- (void)calculateTableViewHeight
{
    CGFloat height = [_user.rapports count] * 44.0f;
    
    CGRect rapportTableviewFrame = CGRectMake(_rapportsView.rapportTableView.frame.origin.x, _rapportsView.rapportTableView.frame.origin.y, _rapportsView.rapportTableView.frame.size.width, height);
    
    _rapportsView.rapportTableView.frame = rapportTableviewFrame;
    
    if ([_user.rapports count] <= 18) {
        
        _rapportsView.rapportListView.contentSize = CGSizeMake(_rapportsView.rapportListView.frame.size.width, _rapportsView.rapportListView.frame.size.height);
    }else{
        
        _rapportsView.rapportListView.contentSize = CGSizeMake(_rapportsView.rapportListView.frame.size.width, ((_rapportsView.rapportTableView.frame.origin.y + 20.0f)+ height));
    }
}

#pragma mark - UITableView Datasource and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count: %d", reports.count);
    return reports.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        Rapport *rapport = [self getReportAtIndexPath:indexPath];
        
        //Delete object from Core Data
        [[[AppData getInstance] managedObjectContext] deleteObject:rapport];
        NSError * error = nil;
        if (![[[AppData getInstance] managedObjectContext] save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        
        //remove object from array
        [reports removeObjectAtIndex:[indexPath row]];
        rapport = nil;
        
        //visibly delete row from tableview
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiBKRapportsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
    if (cell == nil) {
        
        cell = [[DiBKRapportsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    Rapport *rapport = [self getReportAtIndexPath:indexPath];
    
    cell.rapportLabel.text = [[AppData getInstance] getTitleForReport:rapport];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    int days = [AppUtils getDaysSinceDate:rapport.dateCreated];
    cell.dateLabel.text = [NSString stringWithFormat:@"%d d", days];
    return cell;
}

- (Rapport*)getReportAtIndexPath:(NSIndexPath*)indexPath
{
    Rapport *rapport = [reports objectAtIndex:indexPath.row];
    return rapport;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Rapport* report = [self getReportAtIndexPath:indexPath];
    
    for (Rapport *r in reports) {
        if (r == report) {
            
            NSString *name = report.rapportName;
            NSLog(@"report name: %@", name);
        }
    }
    
    [_rapportDelegate existingReportSelectedInTable:report];
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
        
    if (location.x <= 220) {
    
        [_rapportDelegate animateControllerBack];
        
    }
}

@end
