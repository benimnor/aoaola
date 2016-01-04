//
//  NSObject+Additions.m
//  vvebo
//
//  Created by Johnil on 13-12-19.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "NSObject+Additions.h"
#import <objc/runtime.h>

@implementation NSObject (Additions)

- (void)setTempObj:(id)tempObj{
    objc_setAssociatedObject(self, @"tempObj", tempObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)tempObj{
    return objc_getAssociatedObject(self, @"tempObj");
}

- (void)setEnded:(BOOL)ended{
    objc_setAssociatedObject(self, @"ended", @(ended), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ended{
    return [objc_getAssociatedObject(self, @"ended") boolValue];
}

@end
