//
//  UIDevice+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIDevice+Additions.h"


static CGFloat const SCR_HEIGHT_3_5INCH = 480.0;
static CGFloat const SCR_HEIGHT_4INCH   = 568.0;
static CGFloat const SCR_HEIGHT_4_7INCH = 667.0;
static CGFloat const SCR_HEIGHT_5_5INCH = 736.0;

@implementation UIDevice (Additions)

+ (BOOL)isNewiPad{
    return ([self isiPad] && [UIScreen scale]==2);
}

+ (BOOL)isiPhone4{
    return [UIScreen mainScreen].bounds.size.height==SCR_HEIGHT_3_5INCH;
}

+ (BOOL)isiPhone5{
    return [UIScreen mainScreen].bounds.size.height==SCR_HEIGHT_4INCH;
}

+ (BOOL)isiPhone6{
    return [UIScreen mainScreen].bounds.size.height==SCR_HEIGHT_4_7INCH;
}

+ (BOOL)isiPhone6Plus{
    return [UIScreen mainScreen].bounds.size.height==SCR_HEIGHT_5_5INCH;
}

+ (BOOL)trebleResource{
    return [UIScreen mainScreen].bounds.size.height>=SCR_HEIGHT_4_7INCH;
}

+ (BOOL)isiPad{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
