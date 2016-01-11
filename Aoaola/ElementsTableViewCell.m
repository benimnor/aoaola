//
//  ElementsTableViewCell.m
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ElementsTableViewCell.h"

@implementation ElementsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34, 0, .5, self.contentView.height)];
        float gap = SCREEN_WIDTH*.46/3;
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, .5, self.contentView.height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, .5, self.contentView.height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap*3, 0, .5, self.contentView.height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(0, self.contentView.height-.5, SCREEN_WIDTH, .5)];

        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*.34, 44)];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = UIColorFromHex(0x8F8F8F);
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]
                                            initWithString:@"水" attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: APP_COLOR}];
        name.attributedText = attri;
        name.font = [UIFont systemFontOfSize:14];
        name.adjustsFontSizeToFitWidth = YES;
        name.minimumScaleFactor = .5;
        [self.contentView addSubview:name];
        UIView *weixianView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34, 0, gap, 44)];
        UILabel *weixian = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        weixian.layer.cornerRadius = weixian.width/2;
        weixian.text = @"3";
        weixian.backgroundColor = UIColorFromHex(0xFFA845);
        weixian.textAlignment = NSTextAlignmentCenter;
        weixian.textColor = [UIColor whiteColor];
        weixian.clipsToBounds = YES;
        weixian.font = [UIFont systemFontOfSize:9];
        weixian.center = CGPointMake(weixianView.width/2, weixianView.height/2);
        [weixianView addSubview:weixian];
        [self.contentView addSubview:weixianView];
        
        UIView *huoxingView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, gap, 44)];
        UIImageView *huoxing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huoxing"]];
        huoxing.bounds = CGRectMake(0, 0, 10, 10);
        huoxing.contentMode = UIViewContentModeScaleAspectFit;
        [huoxingView addSubview:huoxing];
        huoxing.center = CGPointMake(huoxingView.width/2, huoxingView.height/2);
        [self.contentView addSubview:huoxingView];

        UIView *zhidouView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, gap, 44)];
        UILabel *zhidou = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        zhidou.text = @"!";
        zhidou.textAlignment = NSTextAlignmentCenter;
        zhidou.textColor = [UIColor whiteColor];
        zhidou.layer.cornerRadius = zhidou.width/2;
        zhidou.backgroundColor = UIColorFromHex(0xFF4545);
        zhidou.clipsToBounds = YES;
        zhidou.font = [UIFont systemFontOfSize:9];
        zhidou.center = CGPointMake(zhidouView.width/2, zhidouView.height/2);
        [zhidouView addSubview:zhidou];
        [self.contentView addSubview:zhidouView];
        
        UILabel *mudi = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*3, 0, SCREEN_WIDTH*.2, 44)];
        mudi.textAlignment = NSTextAlignmentCenter;
        mudi.text = @"去角质";
        mudi.numberOfLines = 2;
        mudi.textColor = UIColorFromHex(0x8F8F8F);
        mudi.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:mudi];

    }
    return self;
}

@end
