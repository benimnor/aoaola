//
//  ProductAboutCell.h
//  Aoaola
//
//  Created by Peter on 16/1/5.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAboutCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *casLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentLabel;

@end
