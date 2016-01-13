//
//  ElementsTableViewCell.m
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ElementsTableViewCell.h"

@implementation ElementsTableViewCell {
    UILabel *name;
    UILabel *weixian;
    UIImageView *huoxing;
    UILabel *zhidou;
    UILabel *mudi;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float height = 60;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34, 0, .5, height)];
        float gap = SCREEN_WIDTH*.46/3;
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, .5, height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, .5, height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(SCREEN_WIDTH*.34+gap*3, 0, .5, height)];
        [self.contentView addLine:UIColorFromHex(0xF7F7F7) frame:CGRectMake(0, height-.5, SCREEN_WIDTH, .5)];

        name = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH*.34-10, height)];
        name.textAlignment = NSTextAlignmentCenter;
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]
//                                            initWithString:@"水" attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: APP_COLOR}];
//        name.attributedText = attri;
        name.font = [UIFont systemFontOfSize:12];
        name.numberOfLines = 3;
        name.lineBreakMode = NSLineBreakByWordWrapping;
        name.adjustsFontSizeToFitWidth = YES;
        name.minimumScaleFactor = .2;
        [self.contentView addSubview:name];
        UIView *weixianView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34, 0, gap, height)];
        weixian = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        weixian.layer.cornerRadius = weixian.width/2;
        weixian.text = @"3";
        weixian.backgroundColor = UIColorFromHex(0xFFA845);
        weixian.textAlignment = NSTextAlignmentCenter;
        weixian.textColor = [UIColor whiteColor];
        weixian.clipsToBounds = YES;
        weixian.font = [UIFont systemFontOfSize:9];
        weixian.center = CGPointMake(weixianView.width/2, weixianView.height/2);
        weixian.layer.shouldRasterize = YES;
        weixian.layer.rasterizationScale = [UIScreen scale];
        [weixianView addSubview:weixian];
        [self.contentView addSubview:weixianView];
        
        UIView *huoxingView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, gap, height)];
        huoxing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huoxing"]];
        huoxing.bounds = CGRectMake(0, 0, 10, 10);
        huoxing.contentMode = UIViewContentModeScaleAspectFit;
        [huoxingView addSubview:huoxing];
        huoxing.center = CGPointMake(huoxingView.width/2, huoxingView.height/2);
        [self.contentView addSubview:huoxingView];

        UIView *zhidouView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, gap, height)];
        zhidou = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        zhidou.text = @"!";
        zhidou.textAlignment = NSTextAlignmentCenter;
        zhidou.textColor = [UIColor whiteColor];
        zhidou.layer.cornerRadius = zhidou.width/2;
        zhidou.backgroundColor = UIColorFromHex(0xFF4545);
        zhidou.clipsToBounds = YES;
        zhidou.layer.shouldRasterize = YES;
        zhidou.layer.rasterizationScale = [UIScreen scale];
        zhidou.font = [UIFont systemFontOfSize:9];
        zhidou.center = CGPointMake(zhidouView.width/2, zhidouView.height/2);
        [zhidouView addSubview:zhidou];
        [self.contentView addSubview:zhidouView];
        
        mudi = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*3+5, 0, SCREEN_WIDTH*.2-10, height)];
        mudi.textAlignment = NSTextAlignmentCenter;
        mudi.text = @"去角质";
        mudi.numberOfLines = 4;
        mudi.textColor = UIColorFromHex(0x8F8F8F);
        mudi.font = [UIFont systemFontOfSize:10];
        mudi.adjustsFontSizeToFitWidth = YES;
        mudi.minimumScaleFactor = .5;
        [self.contentView addSubview:mudi];

    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    NSLog(@"%@", data);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]
                                        initWithString:data[@"name"] attributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: [UIColor blackColor]}];
    name.attributedText = attri;
    NSInteger safe = [data[@"safeLevel"] integerValue];
    if (safe<3) {
        weixian.textColor = APP_COLOR;
        weixian.backgroundColor = [UIColor whiteColor];
    } else if (safe<5) {
        weixian.textColor = [UIColor whiteColor];
        weixian.backgroundColor = UIColorFromHex(0xFFA845);
    } else {
        weixian.textColor = [UIColor whiteColor];
        weixian.backgroundColor = UIColorFromHex(0xFF4545);
    }
    weixian.text = @(safe).stringValue;
    huoxing.hidden = ![data[@"huoxing"] boolValue];
    zhidou.hidden = ![data[@"zhidou"] boolValue];
    mudi.text = [data[@"purpose"] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

@end
