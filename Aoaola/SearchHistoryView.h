//
//  SearchHistoryView.h
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryView : UITableView

@property (nonatomic) NSInteger type;
@property (nonatomic, weak) id historyDelegate;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (void)addHistory:(NSString *)history;

@end

@protocol SearchHistoryDelegate <NSObject>

- (void)didChoiceHistory:(NSString *)word;

@end