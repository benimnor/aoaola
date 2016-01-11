//
//  SearchHistoryView.m
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "SearchHistoryView.h"

static NSString *cellIdentifier = @"cell";

@interface SearchHistoryView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchHistoryView {
    NSMutableArray *historyDatas;
    NSMutableArray *hotSearchDatas;
    NSString *localKey;
}

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        if (type==0) {
            localKey = @"searchHistory";
        } else {
            localKey = @"elementsHistory";
        }
        self.delegate = self;
        self.dataSource = self;
        historyDatas = [[NSMutableArray alloc] init];
        NSArray *temp = [[NSUserDefaults standardUserDefaults] arrayForKey:localKey];
        [historyDatas addObjectsFromArray:temp];
        hotSearchDatas = [[NSMutableArray alloc] init];
        [hotSearchDatas addObject:@"2"];
        [hotSearchDatas addObject:@"2"];
        [hotSearchDatas addObject:@"2"];
        [hotSearchDatas addObject:@"2"];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setType:(NSInteger)type{
    _type = type;
    if (type==0) {
        localKey = @"searchHistory";
    } else {
        localKey = @"elementsHistory";
    }
    [historyDatas removeAllObjects];
    NSArray *temp = [[NSUserDefaults standardUserDefaults] arrayForKey:localKey];
    [historyDatas addObjectsFromArray:temp];
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addHistory:(NSString *)history{
    if ([historyDatas indexOfObject:history]!=NSNotFound) {
        return;
    }
    [historyDatas insertObject:history atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:historyDatas forKey:localKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return MIN(hotSearchDatas.count, 3);
    }
    return MIN(historyDatas.count, 3);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [historyDatas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[NSUserDefaults standardUserDefaults] setObject:historyDatas forKey:localKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:COLOR_APP_GRAY];
    [footer.textLabel setFont:[UIFont systemFontOfSize:13]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.textLabel.text = historyDatas[indexPath.row];
    } else {
        cell.textLabel.text = hotSearchDatas[indexPath.row];
    }
    cell.textLabel.textColor = APP_COLOR;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"小伙伴们正在搜";
    }
    return @"历史搜索";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *word = @"";
    if (indexPath.section==0) {
        word = historyDatas[indexPath.row];
    } else {
        word = hotSearchDatas[indexPath.row];
    }
    if (_historyDelegate) {
        [_historyDelegate didChoiceHistory:word];
    }
}

@end
