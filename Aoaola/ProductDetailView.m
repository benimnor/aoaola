//
//  ProductDetailView.m
//  Aoaola
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductDetailView.h"
#import "AdditionsMacro.h"

@implementation ProductDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)compareAction:(UIButton *)sender {
    NSInteger count = LOAD_INTEGER(@"compareCount");
    if (sender.isSelected) {
        [sender setSelected:NO];
        count--;
    }else{
        [sender setSelected:YES];
        count++;
    }
    SAVE_INTEGER(@"compareCount", count);
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefrushCompareNum object:nil];
}
@end
