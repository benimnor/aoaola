//
//  ProductDiscoverViewController.h
//  Aoaola
//
//  Created by Johnil on 16/1/13.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDiscoverViewController : UITableViewController

@property (nonatomic, weak) id cateDelegate;

@end


@protocol ProductDiscoverDelegate <NSObject>

- (void)didChoiceCate:(NSInteger)index;

@end