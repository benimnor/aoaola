//
//  NSDate+Additions.h
//  lottery
//
//  Created by Johnil on 15/4/29.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSInteger)getHour;
- (NSInteger)getMinute;
- (NSInteger)getDay;
- (NSInteger)getMonth;
- (NSInteger)getYear;
- (NSString *)normalDate;

@end
