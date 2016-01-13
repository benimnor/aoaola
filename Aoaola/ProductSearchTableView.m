//
//  ProductSearchTableView.m
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductSearchTableView.h"
#import "SearchInfoViewCell.h"
#import "ProductDetailViewController.h"

static NSString *cellIdentifier = @"SearchInfoViewCell";

@interface ProductSearchTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProductSearchTableView {
    NSMutableArray *productDatas;
    UIImageView *endLogo;
    UIView *footerView;
    UIActivityIndicatorView *footerActivityView;
    NSString *currentKey;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        currentKey = @"";
        _cateType = 9;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = UIColorFromHex(0xF7F7F7);
        productDatas = [[NSMutableArray alloc] init];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 40)];
        footerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        footerActivityView.frame = footerView.bounds;
        [footerActivityView startAnimating];
        footerActivityView.hidesWhenStopped = YES;
        [footerView addSubview:footerActivityView];
        self.tableFooterView = footerView;
        
        [self registerClass:[SearchInfoViewCell class] forCellReuseIdentifier:cellIdentifier];

    }
    return self;
}

- (void)setCateType:(NSInteger)cateType{
    _cateType = cateType;
}

- (void)search:(NSString *)key{
    if (key.length<=0&&productDatas.count<=0) {
        [self loadData];
        return;
    }
    if ([currentKey isEqualToString:key]) {
        return;
    }
    currentKey = key;
    [self loadData];
}

- (void)loadData{
    [ALRequest requestPOSTAPI:@"search/productNew"
                     postData:@{@"searchKey": currentKey,
                                @"offsetIndex": @(0),
                                @"pageSize": @(PAGESIZE),
                                @"cateType": @(_cateType)}
                      success:^(id result) {
                          [productDatas removeAllObjects];
                          NSArray *temp = result[@"pager"][@"content"];
                          [productDatas addObjectsFromArray:temp];
                          [self reloadData];
                          if (footerActivityView) {
                              footerActivityView.hidden = YES;
                              [footerActivityView stopAnimating];
                          }
                      }
                       failed:^(id result, NSError *error) {
                       }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"SearchInfoViewCell%ld%ld", [indexPath section], [indexPath row]];
    SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SearchInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.data = productDatas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailViewController *detail  = [[ProductDetailViewController alloc] initWithData:productDatas[indexPath.row]];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.height) {
        if (footerActivityView.hidden&&!endLogo) {
            [footerActivityView startAnimating];
            footerActivityView.hidden = NO;
            [ALRequest requestPOSTAPI:@"search/productNew"
                             postData:@{@"offsetIndex": @(productDatas.count),
                                        @"pageSize": @(PAGESIZE),
                                        @"cateType": @(_cateType)}
                              success:^(id result) {
                [footerActivityView stopAnimating];
                footerActivityView.hidden = YES;
                NSArray *temp = result[@"pager"][@"content"];
                if (temp&&temp.count>0) {
                    [productDatas addObjectsFromArray:temp];
                    CGPoint offsetPoint = self.contentOffset;
                    [self reloadData];
                    [self setContentOffset:offsetPoint];
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
