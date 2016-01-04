//
//  UIView+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-7.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation UIView (Additions)

- (void)setLineColor:(UIColor *)lineColor{
    objc_setAssociatedObject(self, @"lineColor", lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lineColor{
    return objc_getAssociatedObject(self, @"lineColor");
}

- (void)setTouchBeganBlock:(touchBlock)touchBeganBlock{
    objc_setAssociatedObject(self, @"touchBeganBlock", touchBeganBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (touchBlock)touchBeganBlock{
    return objc_getAssociatedObject(self, @"touchBeganBlock");
}

- (void)setTouchEndBlock:(touchBlock)touchBeganBlock{
    objc_setAssociatedObject(self, @"touchEndBlock", touchBeganBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (touchBlock)touchEndBlock{
    return objc_getAssociatedObject(self, @"touchEndBlock");
}

- (void)setTouchMoveBlock:(touchBlock)touchMoveBlock{
    objc_setAssociatedObject(self, @"touchMoveBlock", touchMoveBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (touchBlock)touchMoveBlock{
    return objc_getAssociatedObject(self, @"touchMoveBlock");
}

- (void)setShadowView:(UIImageView *)temp{
    objc_setAssociatedObject(self, @"shadowView", temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)shadowView{
    return objc_getAssociatedObject(self, @"shadowView");
}

- (UIImage *)toImage{
    NSInteger scale = ([UIDevice isiPhone4]||[UIDevice isiPad])?5:2.5;
    CGSize size = CGSizeMake((NSInteger)(self.width/scale), (NSInteger)self.height/scale);
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height)
               afterScreenUpdates:NO];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [screenShotimage normalize];
}

- (float)boundsWidth{
    return self.bounds.size.width;
}

- (float)boundsHeight{
    return self.bounds.size.width;
}

- (void)setBoundsWidth:(float)w{
    CGRect frame = self.bounds;
    frame.size.width = w;
    self.bounds = frame;
}

- (UIImage *)toRetinaImage{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    UIImage *screenShotimage;
    [self drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height)
                   afterScreenUpdates:NO];
    screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotimage;
}

- (void)setBoundsHeight:(float)h{
    CGRect frame = self.bounds;
    frame.size.height = h;
    self.bounds = frame;
}

- (float)x{
    return self.frame.origin.x;
}

- (float)y{
    return self.frame.origin.y;
}

- (float)width{
    return self.frame.size.width;
}

- (float)height{
    return self.frame.size.height;
}

- (void)setX:(float)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(float)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(float)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setHeight:(float)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)removeAllSubviews{
    for (UIView *temp in self.subviews) {
        [temp removeFromSuperview];
    }
}

- (void)shakeX:(float)range{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-range), @(range), @(-range/2), @(range/2), @(-range/5), @(range/5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void)removeSubviewWithTag:(NSInteger)tag{
    for (UIView *temp in self.subviews) {
        if (temp.tag==tag) {
            [temp removeFromSuperview];
        }
    }
}

- (void)removeSubviewExceptTag:(NSInteger)tag{
    for (UIView *temp in self.subviews) {
        if (temp.tag!=tag) {
			if ([temp isKindOfClass:[UIImageView class]]) {
				[(UIImageView *)temp setImage:nil];
			}
            [temp removeFromSuperview];
        }
    }
}

- (void)removeSubviewExceptClass:(Class)class{
    for (UIView *temp in self.subviews) {
        if (![temp isKindOfClass:class]) {
            [temp removeFromSuperview];
        }
    }
}

- (UIView *)subviewWithTag:(NSInteger)tag{
    for (UIView *temp in self.subviews) {
        if (temp.tag==tag) {
            return temp;
        }
    }
    return nil;
}

- (UIView *)addLine:(UIColor *)color frame:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [self addSubview:line];
    return line;
}

- (UIImage *)imageWithPoints:(NSArray *)pointsArr color:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [color set];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIView *)findFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *temp = [subView findFirstResponder];
        if (temp!=nil) {
            return temp;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchBeganBlock) {
        self.touchBeganBlock([touches anyObject], self);
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchEndBlock) {
        self.touchEndBlock([touches anyObject], self);
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchMoveBlock) {
        self.touchMoveBlock([touches anyObject], self);
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchEndBlock) {
        self.touchEndBlock([touches anyObject], self);
    }
    [super touchesCancelled:touches withEvent:event];
}

@end
