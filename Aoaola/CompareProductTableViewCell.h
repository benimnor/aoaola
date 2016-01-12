//
//  CompareProductTableViewCell.h
//  Aoaola
//
//  Created by Johnil on 16/1/12.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareProductTableViewCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic) NSInteger type;
@property (nonatomic) BOOL configed;

@end
