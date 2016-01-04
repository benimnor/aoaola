//
//  UIImage+Additions.h
//  vvebo
//
//  Created by Johnil on 13-7-28.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)
- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColorTransBg:(UIColor *)tintColor;
- (UIImage *)vImageScaledImageWithSize:(CGSize)destSize;
- (UIImage *)cropToSize:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size;

@end
