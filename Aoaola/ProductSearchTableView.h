//
//  ProductSearchTableView.h
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSearchTableView : UITableView

@property (nonatomic) NSInteger cateType;
- (void)search:(NSString *)key;

@end
