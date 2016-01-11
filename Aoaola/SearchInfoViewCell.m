//
//  SearchInfoViewCell.m
//  Aoaola
//
//  Created by Peter on 16/1/1.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "SearchInfoViewCell.h"
#import "AdditionsMacro.h"
#import "ProductDetailViewController.h"

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
    if (sender.isSelected) {
        [sender setSelected:NO];
        [[UIApplication appDelegate].compareDatas removeLastObject];
    }else{
        [[UIApplication appDelegate].compareDatas addObject:@"1"];
        [sender setSelected:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefrushCompareNum object:nil];
}

- (IBAction)showCompositionView:(id)sender {
    ProductDetailViewController *detail  = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
}
@end
