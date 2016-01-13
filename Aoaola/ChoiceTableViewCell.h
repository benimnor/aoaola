//
//  ChoiceTableViewCell.h
//  aoaola
//
//  Created by Johnil on 15/5/20.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceTableViewCell : UITableViewCell

@property (nonatomic, weak) NSDictionary *data;
@property (nonatomic, strong) UIButton *typeButton;

@end
