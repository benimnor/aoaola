//
//  CompareProductTableViewCell.m
//  Aoaola
//
//  Created by Johnil on 16/1/12.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "CompareProductTableViewCell.h"

@implementation CompareProductTableViewCell {
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _type = -1;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.contentView addSubview:_label];
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.contentView addSubview:_icon];
        
        _topLine = [self.contentView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(0, 0, self.width, .5)];
        _bottomLine = [self.contentView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(0, self.height-.5, self.width, .5)];
        _bottomLine.hidden = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _topLine.width = self.width;
    _bottomLine.width = self.width;
    _bottomLine.y = self.height-.5;
}

@end
