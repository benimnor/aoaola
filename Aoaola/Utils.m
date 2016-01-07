//
//  Utils.m
//  Aoaola
//
//  Created by Peter on 15/12/30.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "Utils.h"
#import "AdditionsMacro.h"


@implementation Utils

+ (UIView *)addLine:(CGRect)rect superView:(UIView *)view withColor:(UIColor *)color{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [view addSubview:line];
    line.backgroundColor = color;
    
    return line;
}

@end
