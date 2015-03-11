//
//  Rapport.m
//  DiBK
//
//  Created by Magnus Hasfjord on 6/2/13.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "Rapport.h"
#import "UserInfo.h"
#import "Template.h"

@implementation Rapport

@dynamic dateCreated;
@dynamic dateLastEdited;
@dynamic isComplete;
@dynamic rapportName;
@dynamic rapportNumber;
@dynamic user;
@dynamic chapter1Info;
@dynamic templates, conclusion, dateCompletedStr;
@synthesize pdfFilePath;

@end
