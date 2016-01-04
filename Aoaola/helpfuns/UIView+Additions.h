//
//  UIView+Additions.h
//  Additions
//
//  Created by Johnil on 13-6-7.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+Additions.h"
#import "UIImage+StackBlur.h"

typedef void(^touchBlock)(UITouch *t, UIView *target);

@interface UIView (Additions)

@property (nonatomic,copy) touchBlock touchBeganBlock;
@property (nonatomic,copy) touchBlock touchEndBlock;
@property (nonatomic,copy) touchBlock touchMoveBlock;
@property (nonatomic, strong) UIColor *lineColor;

- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (float)boundsWidth;
- (float)boundsHeight;
- (void)setBoundsWidth:(float)w;
- (void)setBoundsHeight:(float)h;
- (UIImage *)toRetinaImage;
- (void)removeAllSubviews;
- (void)removeSubviewWithTag:(NSInteger)tag;
- (void)removeSubviewExceptTag:(NSInteger)tag;
- (void)removeSubviewExceptClass:(Class)class1;
- (UIImage *)toImage;
- (void)shakeX:(float)range;

- (UIView *)addLine:(UIColor *)color frame:(CGRect)frame;

- (UIView *)subviewWithTag:(NSInteger)tag;

- (UIImage *)imageWithPoints:(NSArray *)pointsArr color:(UIColor *)color;
- (UIView *)findFirstResponder;
@end
