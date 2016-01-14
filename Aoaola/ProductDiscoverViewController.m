//
//  ProductDiscoverViewController.m
//  Aoaola
//
//  Created by Johnil on 16/1/13.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductDiscoverViewController.h"
#import "AAButton.h"
#import "ChoiceTableViewCell.h"

@interface ProductDiscoverViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProductDiscoverViewController {
    NSMutableArray *datas;
    UIImageView *endLogo;
    UIView *footerView;
    UIActivityIndicatorView *footerActivityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datas = [[NSMutableArray alloc] init];

    NSArray *titleStrArr = @[@"洁面",@"乳液",@"面霜",@"精华",@"化妆水",@"面膜",@"防晒",@"卸妆",@"全部"];

    float size = ceil(SCREEN_WIDTH/3);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, size*3)];
    for (NSInteger i=0; i<9; i++) {
        AAButton *btn = [AAButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mainproduct_%ld",i+1]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:titleStrArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleEdgeInsets = UIEdgeInsetsMake(size*.8, -image.size.width, 10, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, (size-image.size.width)/2, 20, 0);
        btn.frame = CGRectMake(i%3*size, i/3*size, size, size);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(choiceCate:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(size, 0, .5, headerView.height)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(size*2, 0, .5, headerView.height)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, 0, headerView.width, .5)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size, headerView.width, .5)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size*2, headerView.width, .5)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.height += 15;
    [headerView addLine:GRAY_BG_COLOR frame:CGRectMake(0, headerView.height-15, headerView.width, 15)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size*3, headerView.width, .5)];
    self.tableView.tableHeaderView = headerView;

    [self.tableView registerClass:[ChoiceTableViewCell class] forCellReuseIdentifier:@"choiceCell"];
    
    self.tableView.backgroundColor = GRAY_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = APP_COLOR;
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 30)];
    footerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    footerActivityView.frame = footerView.bounds;
    footerActivityView.hidesWhenStopped = NO;
    [footerActivityView startAnimating];
    [footerView addSubview:footerActivityView];
    self.tableView.tableFooterView = footerView;
    
    [self refresh:nil];
}

- (void)choiceCate:(UIButton *)btn{
    if (_cateDelegate) {
        [_cateDelegate didChoiceCate:btn.tag];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl{
    [ALRequest requestPOSTAPI:@"news/getByCategory"
                     postData:@{@"offsetIndex": @(0),
                                @"pageSize": @(PAGESIZE)}
                      success:^(id result) {
                          if (refreshControl) {
                              [refreshControl endRefreshing];
                          }
                          [datas removeAllObjects];
                          NSArray *temp = result[@"pager"][@"content"];
                          [datas addObjectsFromArray:temp];
                          [self.tableView reloadData];
                          if (footerActivityView) {
                              footerActivityView.hidden = YES;
                              [footerActivityView stopAnimating];
                          }
                      }
                       failed:^(id result, NSError *error) {
                           if (refreshControl) {
                               [refreshControl endRefreshing];
                           }
                       }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choiceCell" forIndexPath:indexPath];
    if (!cell.typeButton.hidden) {
        cell.typeButton.hidden = YES;
    }
    [cell setData:datas[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (CELL_HEIGHT+58);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#warning need open detail
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.height) {
        if (footerActivityView.hidden&&!endLogo) {
            [footerActivityView startAnimating];
            footerActivityView.hidden = NO;
            [ALRequest requestPOSTAPI:@"news/getByCategory" postData:@{@"offsetIndex": @(datas.count), @"pageSize": @(PAGESIZE)} success:^(id result) {
                [footerActivityView stopAnimating];
                footerActivityView.hidden = YES;
                NSArray *temp = result[@"pager"][@"content"];
                if (temp&&temp.count>0) {
                    [datas addObjectsFromArray:temp];
                    CGPoint offsetPoint = self.tableView.contentOffset;
                    [self.tableView reloadData];
                    [self.tableView setContentOffset:offsetPoint];
                } else {
                    endLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
                    if (endLogo.height>20) {
                        endLogo.bounds = CGRectMake(0, 0, 20, 20);
                    }
                    endLogo.center = CGPointMake(footerView.width/2, footerView.height/2);
                    [footerView addSubview:endLogo];
                }
            } failed:^(id result, NSError *error) {
                [footerActivityView stopAnimating];
                footerActivityView.hidden = YES;
            }];
        }
    }
}

@end
