//
//  SearchInfoViewCell.h
//  Aoaola
//
//  Created by Peter on 16/1/1.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellCompareDelegate

@optional

/*
 *  添加对比按钮回调
 */
- (void)compareBtnClicked:(UIButton*) sender;

@end


@interface SearchInfoViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *functionLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;

//@property (strong, nonatomic) NSString *imageUrl;
//@property (strong, nonatomic) NSString *titleStr;
//@property (strong, nonatomic) NSString *functionStr;
//@property (strong, nonatomic) NSString *levelStr;

@property (strong, nonatomic) NSString *productID;

@property (strong, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UIButton *compareBtn;
@end
