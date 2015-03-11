//
//  FooterViewController.m
//  DiBK
//
//  Created by david stummer on 25/07/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "FooterViewController.h"
#import "FooterView.h"
#import "Template.h"
#import "Checklist.h"
#import "AuditType.h"
#import "ColorSchemeManager.h"

@implementation FooterViewController
@synthesize footerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)loadView
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    footerView = [[FooterView alloc] initWithFrame:screenSize];
    footerTableView = footerView.tableView;
    footerTableView.delegate = self;
    footerTableView.dataSource = self;
    footerTableView.rowHeight = 25;
    self.view = footerView;
    
    [footerView.rightNav addTarget:self action:@selector(rightNavClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rightNavClicked
{
    NSLog(@"chapter 2 nav clicked");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChapterTwo_RightNavClicked" object:nil];
}

- (void)updateTemplateList:(NSArray *)templates
{
    templateList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [templates count]; i++) {
        Template *template = [templates objectAtIndex:i];
        NSArray *checklists = [template.checklists allObjects];
        for (int j = 0; j < [checklists count]; j++) {
            Checklist *checklist = [checklists objectAtIndex:j];
            NSArray *auditTypes = [checklist.audiTypes allObjects];
            for (int k = 0; k < [auditTypes count]; k++) {
                AuditType *auditType = [auditTypes objectAtIndex:k];
                if (auditType.isChecked) {
                    //NSLog(@"%@, %@, %@, %@", template.templateName, template.templateId, checklist.checklistName, auditType.auditTypeName);
                    NSArray *labelArr = [[NSArray alloc] initWithObjects:template.templateName, checklist.checklistName, auditType.auditTypeName, nil];
                    [templateList addObject:labelArr];
                }
            }
        }
    }
    
    [footerTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [templateList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
    
    NSArray *labelArr = [templateList objectAtIndex:indexPath.row];
    NSString *label = [NSString stringWithFormat:@"%@, %@, %@", labelArr[0], labelArr[1], labelArr[2]];
    
	cell.textLabel.text = label;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica " size:30];
    cell.textLabel.textColor = [ColorSchemeManager getCurrentColorScheme] == kColorSchemeDark ? [UIColor colorWithRed:83.0f/255.0f green:172.0f/255.0f blue:184.0f/255.0f alpha:1.0f] : [ColorSchemeManager getTextColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
