//
//  UIButton+Additions.h
//  Lottery
//
//  Created by Johnil on 14/11/12.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kUIButtonBlockTouchUpInside @"TouchInside"
@interface UIButton (Additions)

@property (nonatomic, strong) NSMutableDictionary *actions;

- (void) setAction:(NSString*)action withBlock:(void(^)())block;

@end
