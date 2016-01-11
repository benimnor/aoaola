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
        _cateType = 9;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = UIColorFromHex(0xF7F7F7);
        productDatas = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<10; i++) {
            [productDatas addObject:@"1"];
        }
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 40)];
        footerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        footerActivityView.frame = footerView.bounds;
        footerActivityView.hidden = YES;
        [footerView addSubview:footerActivityView];
        self.tableFooterView = footerView;
        
        UINib *nib=[UINib nibWithNibName:@"SearchInfoViewCell" bundle:nil ];
        [self registerNib:nib forCellReuseIdentifier:cellIdentifier];

    }
    return self;
}

- (void)setCateType:(NSInteger)cateType{
    _cateType = cateType;
}

- (void)search:(NSString *)key{
    if ([currentKey isEqualToString:key]) {
        return;
    }
    currentKey = key;
    NSLog(@"搜索分类%ld的产品%@", _cateType, currentKey);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
//    cell.delegate = self;
    cell.titleLabel.text = @"珂润润浸保湿滋养乳霜珂润润浸保湿滋养乳霜";
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.functionLabel.text = @"保湿  抗氧化";
    cell.levelLabel.text = @"国产备案";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailViewController *detail  = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==productDatas.count-1) {
        if (footerActivityView.hidden&&!endLogo) {
            [footerActivityView startAnimating];
            footerActivityView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [footerActivityView removeFromSuperview];
                endLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
                if (endLogo.height>20) {
                    endLogo.bounds = CGRectMake(0, 0, 20, 20);
                }
                endLogo.center = CGPointMake(footerView.width/2, footerView.height/2);
                [footerView addSubview:endLogo];
            });
        }
    }
}

@end
