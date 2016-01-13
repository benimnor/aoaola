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

@implementation SearchInfoViewCell {
    UIImageView *iconView;
    UILabel *titleLabel;
    UILabel *effectLabel;
    UILabel *functionLabel;
    UIButton *showDetailBtn;
    
    UIView *overlayView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        float gap = 15;
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, gap, 80, 80)];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:iconView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10, gap, SCREEN_WIDTH-CGRectGetMaxX(iconView.frame)-10-gap, 10)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:titleLabel];
        
        effectLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(iconView.frame)-16, titleLabel.width*.7, 16)];
        effectLabel.textColor = COLOR_APP_GRAY;
        effectLabel.font = [UIFont systemFontOfSize:15];
        effectLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:effectLabel];
        
        functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-titleLabel.width*.3-gap, effectLabel.y, titleLabel.width*.3, 16)];
        functionLabel.textColor = COLOR_APP_PINK;
        functionLabel.font = [UIFont systemFontOfSize:15];
        functionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        functionLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:functionLabel];
        
        [self.contentView addLine:COLOR_APP_WHITE frame:CGRectMake(0, CGRectGetMaxY(iconView.frame)+gap, SCREEN_WIDTH, .5)];
        _compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compareBtn setTitleColor:COLOR_APP_GRAY forState:UIControlStateNormal];
        [_compareBtn setTitleColor:APP_COLOR forState:UIControlStateSelected];
        _compareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_compareBtn setTitle:@"添加对比" forState:UIControlStateNormal];
        [_compareBtn setTitle:@"已添加" forState:UIControlStateSelected];
        [_compareBtn addTarget:self action:@selector(compareAction:) forControlEvents:UIControlEventTouchUpInside];
        _compareBtn.frame = CGRectMake(0, CGRectGetMaxY(iconView.frame)+gap, SCREEN_WIDTH, 35);
        [self.contentView addSubview:_compareBtn];
        if (![reuseIdentifier isEqualToString:@"SearchInfoViewCell2"]) {
            _compareBtn.frame = CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(iconView.frame)+gap, SCREEN_WIDTH/2, 35);
            [self.contentView addLine:COLOR_APP_WHITE frame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(iconView.frame)+gap, .5, _compareBtn.height)];
            showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [showDetailBtn setTitleColor:COLOR_APP_GRAY forState:UIControlStateNormal];
            showDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [showDetailBtn setTitleColor:APP_COLOR forState:UIControlStateHighlighted];
            [showDetailBtn setTitle:@"查看成分" forState:UIControlStateNormal];
            [showDetailBtn addTarget:self action:@selector(showCompositionView:) forControlEvents:UIControlEventTouchUpInside];
            showDetailBtn.frame = CGRectMake(0, CGRectGetMaxY(iconView.frame)+gap, SCREEN_WIDTH/2, _compareBtn.height);
            [self.contentView addSubview:showDetailBtn];
        }
        [self.contentView addLine:COLOR_APP_WHITE frame:CGRectMake(0, gap+iconView.height+gap+_compareBtn.height, SCREEN_WIDTH, 15)];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    titleLabel.text = data[@"name"];
    effectLabel.text = data[@"effect"];
    if (effectLabel.text.length<=0) {
        effectLabel.text = @"暂无";
    }
    functionLabel.text = data[@"src"];
    NSString *imgSrc = data[@"img"];
    if (imgSrc.length>0) {
        [iconView sd_setImageWithURL:[NSURL URLWithString:imgSrc]];
    } else {
        iconView.image = [UIImage imageNamed:@"unknow"];
    }
    titleLabel.height = [titleLabel sizeThatFits:CGSizeMake(titleLabel.width, CGFLOAT_MAX)].height;
}

- (IBAction)compareAction:(UIButton *)sender {
    NSLog(@"........%ld",sender.tag);
    if (sender.isSelected) {
        [sender setSelected:NO];
        [[UIApplication appDelegate].compareDatas removeLastObject];
    }else{
        [[UIApplication appDelegate].compareDatas addObject:_data];
        [sender setSelected:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefrushCompareNum object:nil];
}

- (IBAction)showCompositionView:(id)sender {
    ProductDetailViewController *detail  = [[ProductDetailViewController alloc] initWithData:_data];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    [self highlight:highlighted animated:animated];
}

- (void)highlight:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        if (overlayView) {
            [overlayView removeFromSuperview];
            overlayView = nil;
        }
        overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], self.height-15)];
        overlayView.backgroundColor = [APP_COLOR colorWithAlphaComponent:.2];
        [self.contentView addSubview:overlayView];
    } else {
        [self cancel];
    }
}


- (void)cancel{
    if (!overlayView) {
        overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], (CELL_HEIGHT+58)-15)];
        overlayView.backgroundColor = [APP_COLOR colorWithAlphaComponent:.2];
        [self.contentView addSubview:overlayView];
    }
    [UIView animateWithDuration:.2 animations:^{
        overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        overlayView = nil;
    }];
}
@end
