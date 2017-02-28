//
//  PDFUtils.m
//  DiBK
//
//  Created by david stummer on 20/08/2013.
//  Copyright (c) 2013 com.Byte.DiBK. All rights reserved.
//

#import "PDFUtils.h"
#import "Rapport.h"
#import "ArchiveListRetriever.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation PDFUtils

+ (void)setX:(int)x forView:(UIView*)page
{
    CGRect f = page.frame;
    f.origin.x  = x;
    page.frame = f;
}

+ (void)adjustY:(int)yOffset forView:(UIView*)page
{
    CGRect f = page.frame;
    f.origin.y += yOffset;
    page.frame = f;
}

+ (void)setHeight:(int)height forView:(UIView*)page
{
    CGRect f = page.frame;
    f.size.height = height;
    page.frame = f;
}

// calculate how much we need to scale down to fit inside a certain area
+ (CGFloat)getScaleFactorForImage:(UIImage*)image withContainer:(CGSize)size
{
    CGFloat w2 = image.size.width;
    CGFloat h2 = image.size.height;
    CGFloat sf1 = size.width/w2;
    CGFloat sf2 = size.height/h2;
    CGFloat sf = MIN(sf1,sf2);
    return sf;
}

+ (CGRect)getResizedImageFrameForImage:(UIImage*)image inView:(UIImageView*)imageView
{
    CGRect imageViewFrame = imageView.frame;
    CGFloat scaleFactor = [self getScaleFactorForImage:image withContainer:imageViewFrame.size];
    imageViewFrame.size.width = image.size.width*scaleFactor;
    imageViewFrame.size.height = image.size.height*scaleFactor;
    imageViewFrame.origin.x += (imageView.frame.size.width-imageViewFrame.size.width)/2.0;
    imageViewFrame.origin.y += (imageView.frame.size.height-imageViewFrame.size.height)/2.0;
    return imageViewFrame;
}

// we find all descendant views and add them to the page, so we only have
// direct children of the page, making the renderElementsInView easier to implement
+ (void)makeAllDescendantsTopLevel:(UIView*)view forPage:(UIView*)page
{
    // the qualifiers for adding a view to the page
    if (!view.hidden && view != page && view.superview != page && view.subviews.count <= 0) {
        CGRect f = view.frame;
        f = [view.superview convertRect:f toView:page];
        view.frame = f;
        [page addSubview:view];
    }
    
    for (UIView *v in view.subviews) {
        [self makeAllDescendantsTopLevel:v forPage:page];
    }
}

// replaces UI-elements with their direct drawing counterparts
+ (void)renderElementsInView:(UIView*)view forPage:(UIView*)page
{
    [self makeAllDescendantsTopLevel:view forPage:page];
    
    // all UILabels
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, page.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    for (UIView *subView in view.subviews) {
        if (subView.hidden) {
            continue;
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)subView;
            UIFont *labelFont = label.font;
            CGRect labelFrame = label.frame;
            labelFrame.origin.y = view.frame.size.height-(labelFrame.origin.y+labelFrame.size.height);
            
            // debugging - show red square where split points are (only on UILabels, not images at the moment)
            //if (subView.tag == 99) {
            //    [self drawRect:labelFrame];
            //}
            
            // create the attributed string
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:label.text];
            CTFontRef myCTFont = CTFontCreateWithName((CFStringRef)labelFont.fontName, labelFont.pointSize, NULL);
            NSDictionary *d = @{ (NSString*)kCTFontAttributeName: CFBridgingRelease(myCTFont) };
            [attStr addAttributes:d range:NSMakeRange(0, attStr.length)];
            // if the text is aligned right
            if (label.textAlignment == UITextAlignmentRight) {
                CTTextAlignment rightVal = kCTRightTextAlignment;
                CTParagraphStyleSetting right = {kCTParagraphStyleSpecifierAlignment, sizeof(rightVal), &rightVal};
                CTParagraphStyleSetting pss[1] = {right};
                CTParagraphStyleRef ps = CTParagraphStyleCreate(pss, 1);
                [attStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:CFBridgingRelease(ps) range:NSMakeRange(0, attStr.length)];
            }
            // render the text
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, labelFrame);
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attStr length]), path, NULL);
            CTFrameDraw(frame, UIGraphicsGetCurrentContext());
            // clean up
            CFRelease(frame);
            CFRelease(path);
            CFRelease(framesetter);
        }
    }
    CGContextRestoreGState(ctx);
    
    // all UIImageViews
    for (UIView *subView in view.subviews) {
        if (subView.hidden) {
            continue;
        }
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView*)subView;
            UIImage *image = imageView.image;
            CGRect imageFrame = [self getResizedImageFrameForImage:image inView:imageView];
            //[self drawRect:imageFrame];
            // push image up so it is flush with the text
            int heightDiff = imageFrame.origin.y - imageView.frame.origin.y;
            CGRect tmpImageFrame = imageFrame;
            tmpImageFrame.origin.y -= heightDiff;
            imageFrame = tmpImageFrame;
            [image drawInRect:imageFrame];
        }
    }
}

+ (void)stretchDownPage:(UIView*)page
{
    CGRect frame;
    for (UIView *subView in page.subviews) {
        if (subView.hidden) {
            continue;
        }
        if (CGRectIsEmpty(frame)) {
            frame = subView.frame;
            continue;
        }
        if (frame.origin.y+frame.size.height < subView.frame.origin.y+subView.frame.size.height) {
            frame = subView.frame;
        }
    }
    CGRect pageFrame = page.frame;
    pageFrame.size.height = frame.origin.y+frame.size.height;
    page.frame = pageFrame;
}

+ (NSString*)removeWhitespaceFromStart:(NSString*)str
{
    NSString* result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
}

+ (NSMutableArray*)calculateLinesWithMaxWidth:(int)maxWidth andFont:(UIFont*)font andText:(NSString*)text
{
    NSMutableString *str = [NSMutableString stringWithString:text];
    NSMutableArray *arrLines = [NSMutableArray new];
    for (int i = 1; i <= str.length; i++) {
        NSString *testStr = [str substringToIndex:i];
        int w = [testStr sizeWithFont:font].width;
        if (i == str.length) {
            testStr = [self removeWhitespaceFromStart:testStr];
            [arrLines addObject:testStr];
            break;
        }
        if (w > maxWidth) {
            NSString *testStr2 = [str substringToIndex:i];
            int startPos = i;
            // if a word has been spit between two lines
            if ([str characterAtIndex:i-1] != ' ' && [str characterAtIndex:i] != ' ') {
                // if the previous line contains a space
                int pos = [testStr2 rangeOfString:@" " options:NSBackwardsSearch].location;
                if (pos != NSNotFound) {
                    startPos = pos+1;
                    // add the shortened string (including space)
                    testStr2 = [str substringToIndex:startPos];
                }
            }
            testStr2 = [self removeWhitespaceFromStart:testStr2];
            [arrLines addObject:testStr2];
            str = [NSMutableString stringWithString:[str substringFromIndex:startPos]];
            i = 1;
        }
    }
    
    arrLines = [self extractNewlines:arrLines];
    return arrLines;
}

+ (NSMutableArray*)extractNewlines:(NSMutableArray*)lines
{
    NSMutableArray *all = [NSMutableArray new];
    for (NSString *line in lines) {
        NSMutableArray *data = [[line componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        [all addObjectsFromArray:data];
    }
    return all;
}

// this label is intended to be multiline, so we adjust the height
// to match how high the text is. Then we shift all the views below it down.
// http://stackoverflow.com/questions/446405/adjust-uilabel-height-depending-on-the-text
+ (void)refitLabelAndShiftOtherViewsDown:(UILabel*)label inPage:(UIView*)page
{
    label.hidden = YES;
    //[label removeFromSuperview];
    CGSize maxLabelSize = CGSizeMake(label.frame.size.width, 0); // set height as 0 so sizeWithFont returns line height
    float fontHeight = [label.text sizeWithFont:label.font constrainedToSize:maxLabelSize lineBreakMode:label.lineBreakMode].height;
    
    NSArray *paragraphs = [label.text componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSMutableArray *lines = [NSMutableArray new];
    
    for (NSString *p in paragraphs) {
        if (p == nil || p.length <= 0) {
            [lines addObject:@""]; // we add an empty line here to count as a new line
        }
        [lines addObjectsFromArray:[self calculateLinesWithMaxWidth:label.frame.size.width andFont:label.font andText:p]];
    }
    //;
    if (lines.count <= 0) {
        return;
    }
    
    CGRect frame = label.frame;
    frame.size.height = fontHeight;
    int height = 0;
    //int originY = label.frame.origin.y;
    NSMutableArray *labelArr = [NSMutableArray new];
    for (NSString *line in lines) {
        frame.origin.y = label.frame.origin.y + height;
        UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
        lbl.numberOfLines = 1;
        lbl.text = line;
        lbl.tag = 99;
        lbl.font = label.font;
        [page addSubview:lbl];
        [labelArr addObject:lbl];
        height += fontHeight;
    }
    
    //UIView *lastLabel = labelArr[labelArr.count-1];
    int heightDiff = height - label.frame.size.height;
    
    [self setHeight:height forView:label];
    
    // push down views below this one
    for (UIView *v in page.subviews) {
        if ([labelArr containsObject:v]) {
            continue;
        }
        if (v.frame.origin.y > label.frame.origin.y) {
            CGRect vFrame = v.frame;
            vFrame.origin.y += heightDiff;
            v.frame = vFrame;
        }
    }
}

+ (void)shiftOtherViewsFromPoint:(int)yPoint downBy:(int)yAmount inPage:(UIView*)page
{
    for (UIView *v in page.subviews) {
        if (v.frame.origin.y > yPoint) {
            CGRect vFrame = v.frame;
            vFrame.origin.y += yAmount;
            v.frame = vFrame;
        }
    }
}

// here we calculate the y amount to shift all the views by
// calculating the difference between the view to hide and the
// view immediately below. i.e. the view below will be shifted to the
// y position of the view to hide, and all other views will be shifted up as much
+ (void)hideViewAndShiftOthersUp:(UIView*)view inPage:(UIView*)page
{
    view.hidden = YES;
    
    // y is the difference in y values between our view to
    // hide, and the view immediately below it
    int y = 0;
    for (UIView *v in page.subviews) {
        if (v == view) {
            continue;
        }
        int diff = v.frame.origin.y - view.frame.origin.y;
        if (diff > 0 && (y <= 0 || diff < y)) {
            y = diff;
        }
    }
    
    // shift all below views by y amount
    for (UIView *v in page.subviews) {
        if (v == view) {
            continue;
        }
        int diff = v.frame.origin.y - view.frame.origin.y;
        // if view is below the view to hide
        if (diff > 0) {
            CGRect frame = v.frame;
            frame.origin.y -= y;
            v.frame = frame;
        }
    }
}

+ (void)drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGPathRef path = CGPathCreateWithRect(rect, NULL);
 [[UIColor redColor] setFill];
 [[UIColor greenColor] setStroke];
 CGContextAddPath(context, path);
 CGContextDrawPath(context, kCGPathFillStroke);
 CGPathRelease(path);
}

@end