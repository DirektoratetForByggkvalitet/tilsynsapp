//
//  SlideInViewController.m
//  DiBK
//
//  Created by david stummer on 20/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "SlideInViewController.h"
#import "SlideInView.h"
#import "Template.h"
#import "Checklist.h"
#import "CellView.h"
#import "AuditType.h"

@interface SectionHeaderView : UIView
@property (nonatomic, strong) UILabel *label;
@property BOOL selected;
@end

@implementation SectionHeaderView : UIView
@synthesize label, selected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(23.0f, 0.0f, 467.0f, 55.0f)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:23.0f]];
        [label setTextColor:[UIColor colorWithRed:16.0f/255.0f green:44.0f/255.0f blue:60.0f/255.0f alpha:255.0f/255.0f]];
        [self addSubview:label];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, 467, 1)];
        [line setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:215.0f/255.0f blue:225.0f/255.0f alpha:255.0f/255.0f]];
        [self addSubview:line];
    }
    return self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeaderClicked" object:self];
}
@end

@implementation SlideInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    slideInView = [[SlideInView alloc] initWithFrame:screenSize];
    slideInView.tableView.delegate = self;
    slideInView.tableView.dataSource = self;
    slideInView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    slideInTableView = slideInView.tableView;
    slideInTableView.rowHeight = 55;
    slideInTableView.sectionHeaderHeight = 55;
    
    self.view = slideInView;
    
    UINib *nib = [UINib nibWithNibName:@"CellView" bundle:nil];
    [slideInTableView registerNib:nib forCellReuseIdentifier:@"CellView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerViewClicked:) name:@"HeaderClicked" object:nil];
}

- (void)updateView:(Template*)template
{
    cellArray = nil;
    cellCount = nil;
    
    cellArray=[[NSMutableArray alloc]init];
    cellCount=[[NSMutableArray alloc]init];
    allAuditTypes=[[NSMutableArray alloc]init];
    
    allChecklists = [template.checklists allObjects];
    allChecklists = [allChecklists sortedArrayUsingComparator:^(Checklist *obj1, Checklist *obj2) {
        return [obj1.checklistId compare:obj2.checklistId];
    }];
    
    //for (Checklist *cl in allChecklists) {
    //    NSLog(@"CHECKLIST: (%@) %@", cl.checklistId, cl.checklistName);
    //}
    
    for (int i = 0; i < [allChecklists count]; i++) {
        Checklist *checklist = [allChecklists objectAtIndex:i];
        NSArray *arr = [checklist.audiTypes allObjects];
        arr = [arr sortedArrayUsingComparator: ^(id obj1, id obj2) {
            AuditType *a = (AuditType*)obj1;
            AuditType *b = (AuditType*)obj2;
            return [a.auditTypeId compare:b.auditTypeId];
        }];
        
        [allAuditTypes addObjectsFromArray:arr];
        [cellArray addObject:arr];
        [cellCount addObject:[NSNumber numberWithInt:0]];
    }
    
    slideInView.title.text = template.templateName;
    
    [slideInTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[cellCount objectAtIndex:section] intValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allChecklists count];
}

- (UIView*)getCellView
{
    CellView *cv = [[CellView alloc] init];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:cv options:nil];
    
    CellView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[CellView class]])
            blah = (CellView *)object;
    }
    assert(blah != nil && "blah can't be nil");
    return blah;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CellView *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"CellView";
	cell = [slideInTableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];

    AuditType *auditType = [allAuditTypes objectAtIndex:indexPath.row];
    AuditType *auditType2 =[[cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setupCellViewWithAuditType:auditType2];
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Checklist *checklist = [allChecklists objectAtIndex:section];
    
    SectionHeaderView *headerView = [[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, 323, 84)];
    headerView.label.text = checklist.checklistName;
    headerView.selected = ([[cellCount objectAtIndex:section] intValue] == 0);
    headerView.tag = section + 1;
    
    return  headerView;
}

- (void)headerViewClicked:(NSNotification*)note
{
    SectionHeaderView *sectionHeaderView = (SectionHeaderView*)note.object;
    
    NSInteger index = sectionHeaderView.tag - 1;
    
    if(!sectionHeaderView.selected)
        [cellCount replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
    else
        [cellCount replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:[[cellArray objectAtIndex:index]count]]];
    
    [slideInTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
