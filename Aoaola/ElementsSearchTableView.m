//
//  ElementsSearchTableView.m
//  Aoaola
//
//  Created by Johnil on 16/1/11.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ElementsSearchTableView.h"
#import "ElementsTableViewCell.h"
#import "ProductAboutViewController.h"

static NSString *cellIdentifier = @"ElementsCell";

@interface ElementsSearchTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ElementsSearchTableView {
    NSMutableArray *elementDatas;
    UIImageView *endLogo;
    UIView *footerView;
    UIActivityIndicatorView *footerActivityView;
    NSString *currentKey;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        elementDatas = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<10; i++) {
            [elementDatas addObject:@"1"];
        }
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 40)];
        footerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        footerActivityView.frame = footerView.bounds;
        footerActivityView.hidden = YES;
        [footerView addSubview:footerActivityView];
        self.tableFooterView = footerView;

        [self registerClass:[ElementsTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (void)search:(NSString *)key{
    if ([currentKey isEqualToString:key]) {
        return;
    }
    currentKey = key;
    NSLog(@"搜索成分 %@", currentKey);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return elementDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ElementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    //    cell.delegate = self;
//    cell.titleLabel.text = @"珂润润浸保湿滋养乳霜珂润润浸保湿滋养乳霜";
//    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
//    cell.functionLabel.text = @"保湿  抗氧化";
//    cell.levelLabel.text = @"国产备案";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    header.backgroundColor = UIColorFromHex(0xF7F7F7);
    [header addLine:[UIColor whiteColor] frame:CGRectMake(SCREEN_WIDTH*.34, 0, .5, 44)];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*.34, 44)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = @"名称";
    name.textColor = UIColorFromHex(0x8F8F8F);
    name.font = [UIFont systemFontOfSize:12];
    [header addSubview:name];
    float gap = SCREEN_WIDTH*.46/3;
    [header addLine:[UIColor whiteColor] frame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, .5, 44)];
    UILabel *weixian = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34, 0, gap, 44)];
    weixian.text = @"危险\n指数";
    weixian.textAlignment = NSTextAlignmentCenter;
    weixian.numberOfLines = 2;
    weixian.textColor = UIColorFromHex(0x8F8F8F);
    weixian.font = [UIFont systemFontOfSize:12];
    [header addSubview:weixian];
    [header addLine:[UIColor whiteColor] frame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, .5, 44)];
    UILabel *huoxing = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap, 0, gap, 44)];
    huoxing.text = @"活性\n成分";
    huoxing.textAlignment = NSTextAlignmentCenter;
    huoxing.numberOfLines = 2;
    huoxing.textColor = UIColorFromHex(0x8F8F8F);
    huoxing.font = [UIFont systemFontOfSize:12];
    [header addSubview:huoxing];
    [header addLine:[UIColor whiteColor] frame:CGRectMake(SCREEN_WIDTH*.34+gap*3, 0, .5, 44)];
    UILabel *zhidou = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*2, 0, gap, 44)];
    zhidou.text = @"致逗\n风险";
    zhidou.textAlignment = NSTextAlignmentCenter;
    zhidou.numberOfLines = 2;
    zhidou.textColor = UIColorFromHex(0x8F8F8F);
    zhidou.font = [UIFont systemFontOfSize:12];
    [header addSubview:zhidou];
    
    UILabel *mudi = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*.34+gap*3, 0, SCREEN_WIDTH*.2, 44)];
    mudi.textAlignment = NSTextAlignmentCenter;
    mudi.text = @"使用目的";
    mudi.numberOfLines = 2;
    mudi.textColor = UIColorFromHex(0x8F8F8F);
    mudi.font = [UIFont systemFontOfSize:12];
    [header addSubview:mudi];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductAboutViewController *detail  = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==elementDatas.count-1) {
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
