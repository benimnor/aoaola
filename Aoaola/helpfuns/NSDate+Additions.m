//
//  NSDate+Additions.m
//  lottery
//
//  Created by Johnil on 15/4/29.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import "NSDate+Additions.h"

static NSDateFormatter *sdf;

@implementation NSDate (Additions)

- (NSDateFormatter *)sdf{
    if (sdf==nil) {
        sdf = [[NSDateFormatter alloc] init];
    }
    return sdf;
}

- (NSInteger)getHour{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"HH"];
    NSString *time = [sdf stringFromDate:self];
    return time.integerValue;
}

- (NSInteger)getMinute{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"mm"];
    NSString *time = [sdf stringFromDate:self];
    return time.integerValue;
}

- (NSInteger)getDay{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"dd"];
    NSString *time = [sdf stringFromDate:self];
    return time.integerValue;
}

- (NSInteger)getMonth{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"MM"];
    NSString *time = [sdf stringFromDate:self];
    return time.integerValue;
}

- (NSInteger)getYear{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"yyyy"];
    NSString *time = [sdf stringFromDate:self];
    return time.integerValue;
}

- (NSString *)normalDate{
    NSDateFormatter *sdf = [self sdf];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [sdf stringFromDate:self];
    return time;
}

@end
