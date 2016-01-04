//
//  UIScreen+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIScreen+Additions.h"

@implementation UIScreen (Additions)

+ (float)screenWidth{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        return [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale;
    } else {
        return [UIScreen mainScreen].bounds.size.width;
    }
}

+ (float)screenHeight{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        if ([UIApplication sharedApplication].statusBarFrame.size.height>20) {
            return [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale-19;
        }
        return [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale+1;
    } else {
        if ([UIApplication sharedApplication].statusBarFrame.size.height>20) {
            return [UIScreen mainScreen].bounds.size.height-20;
        }
        return [UIScreen mainScreen].bounds.size.height;
    }
}

+ (BOOL)isRetina{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        return [UIScreen mainScreen].nativeScale>=2;
    } else {
        return [UIScreen mainScreen].scale>=2;
    }
}

+ (float)scale{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        return [UIScreen mainScreen].nativeScale;
    } else {
        return [UIScreen mainScreen].scale;
    }
}

@end
