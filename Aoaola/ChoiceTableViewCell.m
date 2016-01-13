//
//  ChoiceTableViewCell.m
//  aoaola
//
//  Created by Johnil on 15/5/20.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import "ChoiceTableViewCell.h"
#warning need choicetableviewcontrller
//#import "ChoiceTableViewController.h"

@implementation ChoiceTableViewCell {
    MBProgressHUD *progress;
    UIImageView *imageView;
    UILabel *timeLabel;
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIImageView *likeIcon;
    UILabel *likeLabel;
    UIImageView *commentIcon;
    UILabel *commentLabel;
    UIView *overlayView;
    UIImageView *timeBG;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], CELL_HEIGHT)];
        imageView.contentMode= UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = GRAY_COLOR;
        [self.contentView addSubview:imageView];
        
        timeBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_time"]];
        timeBG.x = [UIScreen screenWidth]-timeBG.width-10;
        timeBG.y = imageView.height-timeBG.height-10;
        [imageView addSubview:timeBG];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, timeBG.width-20, timeBG.height)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [timeBG addSubview:timeLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.height, [UIScreen screenWidth]-20, 25)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.y+titleLabel.height, 100, 12)];
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textColor = [UIColor colorWithFullRed:156 green:156 blue:156 alpha:1];
        [self.contentView addSubview:dateLabel];
        
        likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_like"]];
        likeIcon.bounds = CGRectMake(0, 0, 12, 10.5);
        likeIcon.y = dateLabel.y+1;
        [self.contentView addSubview:likeIcon];
        likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabel.y, 0, 12)];
        likeLabel.textColor = [UIColor colorWithFullRed:156 green:156 blue:156 alpha:1];
        likeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:likeLabel];
        
        commentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_comment"]];
        commentIcon.bounds = CGRectMake(0, 0, 12, 12);
        commentIcon.y = dateLabel.y;
        [self.contentView addSubview:commentIcon];
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabel.y, 0, 12)];
        commentLabel.textColor = [UIColor colorWithFullRed:156 green:156 blue:156 alpha:1];
        commentLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:commentLabel];
        
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeButton.frame = CGRectMake(-5, 10, 80, 25);
        _typeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
        _typeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _typeButton.clipsToBounds = YES;
        _typeButton.layer.cornerRadius = 3;
        [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_typeButton];
        [_typeButton addTarget:self action:@selector(showCate) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = GRAY_BG_COLOR;
        UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.height, [UIScreen screenWidth], 43)];
        white.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:white atIndex:0];
        [white addLine:GRAY_COLOR frame:CGRectMake(0, white.height-.5, white.width, .5)];
        [self.contentView addLine:GRAY_COLOR frame:CGRectMake(0, 0, [UIScreen screenWidth], .5)];
    }
    return self;
}

- (void)showCate{
//    ChoiceTableViewController *choice = [[ChoiceTableViewController alloc] initWithStyle:UITableViewStylePlain cateId:_data[@"categoryId"] cateTitle:_data[@"categoryTitle"]];
//    [[UIApplication visibleViewController].navigationController pushViewController:choice animated:YES];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    imageView.image = nil;
    [imageView sd_setImageWithURL:[NSURL URLWithString:data[@"coverPicUrl"]] placeholderImage:nil options:SDWebImageRetryFailed];
    timeBG.hidden = YES;
    if (!_typeButton.hidden) {
        [_typeButton setTitle:data[@"typeTitle"] forState:UIControlStateNormal];
    }
    titleLabel.text = data[@"title"];
    if ([data valueForKey:@"duration"]&&[[data valueForKey:@"duration"] floatValue]>0) {
        timeBG.hidden = NO;
        float duration = [[data valueForKey:@"duration"] floatValue];
        timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)(duration/60), (NSInteger)((NSInteger)duration%60)];
    }
    //        timeLabel.text = @"02:30";
    dateLabel.text = [data[@"createTime"] substringToIndex:11];//data[@"date"];
    NSString *comment = [data[@"replyCount"] stringValue];
    commentLabel.text = comment;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, commentLabel.height)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:commentLabel.font}
                                                   context:nil].size;
        dispatch_async(dispatch_get_main_queue(), ^{
            commentLabel.width = commentSize.width;
            commentLabel.x = [UIScreen screenWidth]-10-commentLabel.width;
            commentIcon.x = commentLabel.x-commentIcon.width-2;
        });
    });
    
    NSString *like = [data[@"hotCount"] stringValue];
    likeLabel.text = like;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGSize likeSize = [like boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, likeLabel.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:likeLabel.font}
                                             context:nil].size;
        dispatch_async(dispatch_get_main_queue(), ^{
            likeLabel.width = likeSize.width;
            likeLabel.x = commentIcon.x-20-likeLabel.width;
            likeIcon.x = likeLabel.x-likeIcon.width-2;
        });
    });
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
        overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], (CELL_HEIGHT+58)-15)];
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
