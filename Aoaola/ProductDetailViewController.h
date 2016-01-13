//
//  ProductDetailViewController.h
//  Aoaola
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductDetailViewController : UITableViewController

- (instancetype)initWithData:(NSDictionary *)data;
@property (strong, nonatomic) UIView *moveLine;
@end
