//
//  ProductDetailView.h
//  Aoaola
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *product_img;
@property (strong, nonatomic) IBOutlet UILabel *product_title;
@property (strong, nonatomic) IBOutlet UILabel *product_fun;
@property (strong, nonatomic) IBOutlet UILabel *product_level;
@property (strong, nonatomic) IBOutlet UILabel *product_com_value;
@property (strong, nonatomic) IBOutlet UILabel *product_desc;
@end
