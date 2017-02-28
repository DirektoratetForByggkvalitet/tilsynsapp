//
//  Info.h
//  DiBK
//
//  Created by david stummer on 28/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@interface Info : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSMutableArray* paragraphs;
@property (nonatomic, strong) NSString* hjemmelTitle;
@property (nonatomic, strong) NSMutableArray* hjemmelParagraphs;
@property (nonatomic) BOOL hjemmelExists;

+ (Info*)getInfoObjectForkey:(NSString *)key;
+ (void)showInfoScreenForkey:(NSString *)key;
+ (void)showInfoScreenForQuestion:(Question*)question;

@end

/*
 ALL KEYS:
 
 DASHBOARD
 incompleteReports, archive
 
 CHAPTER ONE PAGE ONE
 chapter1_page1_info1, chapter1_page1_info2, chapter1_page1_info3, chapter1_page1_info4, chapter1_page1_info5
 
 CHAPTER ONE PAGE TWO
 chapter1_page2_info1, chapter1_page2_info2, chapter1_page2_info3
 
 CHAPTER THREE
 
 CHAPTER FOUR
 chapter4_info1, chapter4_info2
  
*/