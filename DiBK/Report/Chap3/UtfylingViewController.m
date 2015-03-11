//
//  UtfylingViewController.m
//  DiBK

#import "UtfylingViewController.h"
#import "AuditType.h"
#import "Checklist.h"
#import "Template.h"
#import "Question.h"
#import "QuestionView.h"
#import "AppData.h"
#import "ColorSchemeManager.h"

@implementation UtfylingViewController

@synthesize labelSubtitle, labelTitle, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAuditType:(AuditType*)at
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        auditType = at;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(questionViewUpdated:) name:@"QuestionViewUpdated" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(questionViewNewQuestion:) name:@"QuestionView_AddQuestion" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(questionViewDeleteQuestion:) name:@"QuestionView_DeleteQuestion" object:nil];
    }
    return self;
}

-(void)shutdown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    labelSubtitle.text = [auditType.auditTypeName uppercaseString];
    Checklist *checklist = [[auditType.checklist allObjects] objectAtIndex:0];
    Template *template = [[checklist.template allObjects] objectAtIndex:0];
    labelTitle.text = [NSString stringWithFormat:@"%@: %@", template.templateName, checklist.checklistName];

    [self loadQuestions];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadStyles];
    self.view.backgroundColor = [ColorSchemeManager getBgColor];
}

-(void)loadStyles
{
    [ColorSchemeManager updateView:self.view];
}

-(void)questionViewDeleteQuestion:(NSNotification*)note
{
    QuestionView *questionView = (QuestionView*)note.object;
    Question *deleteQuestion = [questionView getQuestion];
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    for (QuestionView *qv in questionViews) {
        Question *q = [qv getQuestion];
        int index = (int)[q.questionIndex integerValue];
        if (index > [deleteQuestion.questionIndex integerValue]) {
            index--;
            q.questionIndex = q.questionId = [NSNumber numberWithInt:index];
        }
        if (q != deleteQuestion) {
            [questions addObject:q];
        }
    }
    NSMutableSet *set = [[NSMutableSet alloc] initWithArray:questions];
    [auditType setQuestions:set];
    [questionView removeFromSuperview];
    [questionViews removeObject:questionView];
    [self fitContents];
}

-(void)questionViewNewQuestion:(NSNotification*)note
{
    NSDictionary *dict = (NSDictionary*)note.userInfo;
    NSString *questionName = [dict objectForKey:@"questionName"];
    BOOL insertBefore = [[dict objectForKey:@"insertBefore"] boolValue];
    
    QuestionView *questionView = (QuestionView*)note.object;
    if (questionView.controller != self) {
        return;
    }
    Question *fromQuestion = [questionView getQuestion];
    Question *toQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:[AppData getInstance].managedObjectContext];
    toQuestion.questionName = questionName;
    toQuestion.questionId = toQuestion.questionIndex = fromQuestion.questionIndex;
    
    // if inserting after, add 1
    if (!insertBefore) {
        int index = (int)[toQuestion.questionIndex integerValue];
        index++;
        toQuestion.questionIndex = [NSNumber numberWithInt:index];
        toQuestion.questionId = toQuestion.questionIndex;
    }
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    [questions addObject:toQuestion];
    for (QuestionView *qv in questionViews) {
        Question *q = [qv getQuestion];
        if ([q.questionIndex integerValue] >= [toQuestion.questionIndex integerValue]) {
            int index = (int)[q.questionIndex integerValue]; index++;
            q.questionIndex = [NSNumber numberWithInt:index];
            q.questionId = q.questionIndex;
        }
        [questions addObject:q];
    }
    NSMutableSet *set = [[NSMutableSet alloc] initWithArray:questions];
    [auditType setQuestions:set];
    QuestionView *qv = [self addQuestion:toQuestion];
    [self fitContents];
}

- (void)questionViewUpdated:(NSNotification *)note
{
    [self fitContents];
}

- (void)loadQuestions
{
    nQuestions = 0;
    questionViews = [[NSMutableArray alloc] init];
    
    NSArray *array = [auditType.questions allObjects];
    NSArray *questions;
    questions = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(Question*)a questionIndex];
        NSNumber *second = [(Question*)b questionIndex];
        return [first compare:second];
    }];
    
    for (int i = 0; i < [questions count]; i++) {
        Question *question = [questions objectAtIndex:i];
        NSLog(@"QUESTION name:%@, index:%ld, id:%ld", question.questionName, (long)[question.questionIndex integerValue], (long)[question.questionId integerValue]);
        [self addQuestion:question];
    }
    
    [self fitContents];
}

- (void)fitContents
{
    // first re-organize question views so that they appear in the correct order according to the question index
    NSMutableArray *tmpQuestionViews;
    tmpQuestionViews = [questionViews sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        Question *first = [(QuestionView*)a getQuestion];
        Question *second = [(QuestionView*)b getQuestion];
        return [first.questionIndex compare:second.questionIndex];
    }];
    
    NSInteger height = 0;
    for (int i = 0; i < [tmpQuestionViews count]; i++) {
        QuestionView *qv = [tmpQuestionViews objectAtIndex:i];
        
        qv.divider.hidden = NO;
        if (i == 0) {
            qv.divider.hidden = YES;
        }

        //refresh numbers
        [qv.numberLabel setText:[NSString stringWithFormat:@"%d", i+1]];
        
        CGRect frame = qv.frame;
        frame.origin.y = height;
        frame.size.height = [qv getTheHeight];
        qv.frame = frame;
        
        height += [qv getTheHeight];
    }
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, height)];
}

- (QuestionView*)addQuestion:(Question*)question
{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:nil options:nil];
    
    QuestionView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[QuestionView class]])
            blah = (QuestionView *)object;
    }
    assert(blah != nil && "blah can't be nil");
    blah.controller = self;
    [blah setQuestion:question];
    [blah setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:blah];
    [questionViews addObject:blah];
    return blah;
}

-(IBAction)clickbtnback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelTitle:nil];
    [self setLabelSubtitle:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
