//
//  UIColor+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIColor+Additions.h"
typedef enum { R, G, B, A } UIColorComponentIndices;

@implementation UIColor (Additions)

+ (UIColor *)colorWithFullRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

-(CGFloat)red
{ return CGColorGetComponents(self.CGColor)[R]; }

-(CGFloat)green
{ return CGColorGetComponents(self.CGColor)[G]; }

-(CGFloat)blue
{ return CGColorGetComponents(self.CGColor)[B]; }

-(CGFloat)alpha
{ return CGColorGetComponents(self.CGColor)[A]; }

@end
