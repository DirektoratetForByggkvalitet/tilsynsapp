//
//  PDFUtils.h
//  DiBK
//
//  Created by david stummer on 20/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rapport;

@interface PDFUtils : NSObject

+ (void)stretchDownPage:(UIView*)page;
+ (void)refitLabelAndShiftOtherViewsDown:(UILabel*)label inPage:(UIView*)page;
+ (void)hideViewAndShiftOthersUp:(UIView*)view inPage:(UIView*)page;
+ (void)renderElementsInView:(UIView*)view forPage:(UIView*)page;
+ (void)makeAllDescendantsTopLevel:(UIView*)view forPage:(UIView*)page;
+ (void)adjustY:(int)yOffset forView:(UIView*)page;
+ (void)setX:(int)x forView:(UIView*)page;
+ (void)setHeight:(int)height forView:(UIView*)page;
+ (void)shiftOtherViewsFromPoint:(int)yPoint downBy:(int)yAmount inPage:(UIView*)page;

@end
