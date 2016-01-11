//
//  MainViewController.h
//  Aoaola
//
//  Created by Peter on 15/12/21.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id delegate;

@end


@protocol MainViewDelegate <NSObject>

- (void)didChoiceCate:(NSInteger)index;

@end