//
//  SearchInfoViewCell.m
//  Aoaola
//
//  Created by Peter on 16/1/1.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "SearchInfoViewCell.h"
#import "AdditionsMacro.h"

@implementation SearchInfoViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
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
