//
//  InfoView.m
//  DiBK
//
//  Created by david stummer on 28/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "InfoView.h"
#import "Info.h"

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mainView = [[UIView alloc] initWithFrame:CGRectMake(265, 0, 503, 1024)];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(265, 0, 1, 1024)];
        leftBorder.backgroundColor = [UIColor blackColor];
        [self addSubview:leftBorder];
        
        CGRect frame2 = CGRectMake(50, 50, 400, 50);
        title = [[UILabel alloc]initWithFrame:frame2];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
        [title setTextColor:[UIColor blackColor]];
        title.minimumFontSize = 20;
        title.adjustsFontSizeToFitWidth = YES;
        [mainView addSubview:title];
        
        CGRect frame4 = frame2;
        frame4.origin.y = 830;
        title2 = [[UILabel alloc]initWithFrame:frame4];
        [title2 setBackgroundColor:[UIColor clearColor]];
        [title2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
        [title2 setTextColor:[UIColor blackColor]];
        title2.minimumFontSize = 20;
        title2.adjustsFontSizeToFitWidth = YES;
        [mainView addSubview:title2];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        
        CGRect frame3 = CGRectMake(50, 150, 400, 650);
        p1 = [[UITextView alloc] initWithFrame:frame3];
        p1.font = font;
        p1.editable = NO;
        [mainView addSubview:p1];
        
        CGRect frame5 = frame4;
        frame5.origin.y += 50;
        frame5.size.height = 100;
        p2 = [[UITextView alloc] initWithFrame:frame5];
        p2.font = font;
        p2.editable = NO;
        [mainView addSubview:p2];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [mainView addGestureRecognizer:swipeRight];
        
        self.hidden = YES;
    }
    return self;
}


- (void)doShowWithInfo:(Info*)i
{
    info = i;
    title.text = info.title;
    if (info.hjemmelExists) {
        title2.text = info.hjemmelTitle;
        NSMutableString *allHjemmelText = [NSMutableString new];
        [allHjemmelText appendString:info.hjemmelParagraphs[0]];
        for (int i = 1; i < info.hjemmelParagraphs.count; i++) {
            [allHjemmelText appendString:@", "];
            [allHjemmelText appendString:info.hjemmelParagraphs[i]];
        }
        p2.text = allHjemmelText;
    }
    
    NSMutableString *allText = [NSMutableString new];
    [allText appendString:info.paragraphs[0]];
    for (int i = 1; i < info.paragraphs.count; i++) {
        [allText appendString:@"\n\n"];
        [allText appendString:info.paragraphs[i]];
    }
    p1.text = allText;
    
    if (!self.hidden) {
        return;
    }
    
    self.hidden = NO;
    self.center = CGPointMake((self.superview.frame.size.width*1.5f), self.center.y);
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5f animations:^{
        self.center = CGPointMake((self.superview.frame.size.width*0.5f), self.center.y);
    } completion:^(BOOL finished) {
    }];
}

- (void)doHide
{
    [UIView animateWithDuration:0.5f animations:^{
        self.center = CGPointMake((self.superview.frame.size.width*1.5f), self.center.y);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self doHide];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i<[touchesArray count]; i++)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        
        if (!CGRectContainsPoint(mainView.frame, point)) {
            [self doHide];
            return;
        }
    }
}

@end
