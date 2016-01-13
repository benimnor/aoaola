//
//  ProductAboutCell.m
//  Aoaola
//
//  Created by Peter on 16/1/5.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductAboutCell.h"

@implementation ProductAboutCell

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.titleLabel.text = data[@"name"];
    self.nicknameLabel.text = data[@"enname"];
    self.casLabel.text = [NSString stringWithFormat:@"CAS：%@", [data[@"cas"] length]<=0?@"未知":data[@"cas"]];
    BOOL huoxing = data[@"huoxing"];
    BOOL zhidou = data[@"zhidou"];
    NSString *otherName = data[@"othername"];
    NSString *desc = data[@"description"];
    NSInteger safeLevel = [data[@"safeLevel"] integerValue];
    NSString *str = data[@"str"];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: UIColorFromHex(0xABABAB)}];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:@(safeLevel).stringValue]];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:@"活性成分"]];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:otherName]];
    _contentLabel.attributedText = attri;
}

@end
