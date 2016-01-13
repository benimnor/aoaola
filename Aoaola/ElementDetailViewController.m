//
//  ElementDetailViewController.h
//  Aoaola
//
//  Created by Peter on 16/1/5.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ElementDetailViewController.h"
#import "AdditionsMacro.h"
#import "SearchInfoViewCell.h"
#import "ProductDetailViewController.h"
#import "CompareProductViewController.h"

@interface ElementDetailViewController ()

@end

@implementation ElementDetailViewController{
    UIView *compareNumView;
    UILabel *comparNumLabel;
    NSDictionary *elementInfo;
    NSMutableArray *datas;
    UIImageView *endLogo;
    UIView *footerView;
    UIActivityIndicatorView *footerActivityView;
}

- (instancetype)initWithData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        elementInfo = [data copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datas = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"产品相关";
    self.view.backgroundColor = GRAY_BG_COLOR;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrushCompareNum) name:kRefrushCompareNum object:nil];
    
    float height = 0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 30)];
    titleLabel.textColor = APP_COLOR;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = .2;
    titleLabel.font = [UIFont systemFontOfSize:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = elementInfo[@"name"];
    [headerView addSubview:titleLabel];
    height = CGRectGetMaxY(titleLabel.frame);
    NSString *enName = elementInfo[@"enName"];
    if (enName.length>0&&![enName isEqualToString:titleLabel.text]) {
        UILabel *ennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height+5, self.view.width, 21)];
        ennameLabel.textColor = APP_COLOR;
        ennameLabel.font = [UIFont systemFontOfSize:17];
        ennameLabel.textAlignment = NSTextAlignmentCenter;
        ennameLabel.text = enName;
        [headerView addSubview:ennameLabel];
        height = CGRectGetMaxY(ennameLabel.frame);
    }
    NSString *cas = elementInfo[@"cas"];
    if (cas.length>0) {
        UILabel *casLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height+5, self.view.width, 17)];
        casLabel.textColor = UIColorFromHex(0xABABAB);
        casLabel.font = [UIFont systemFontOfSize:14];
        casLabel.textAlignment = NSTextAlignmentCenter;
        casLabel.text = [NSString stringWithFormat:@"cas: %@",cas];
        [headerView addSubview:casLabel];
        height = CGRectGetMaxY(casLabel.frame);
    }
    BOOL huoxing = elementInfo[@"huoxing"];
    BOOL zhidou = elementInfo[@"zhidou"];
    NSString *otherName = elementInfo[@"othername"];
    NSString *desc = elementInfo[@"description"];
    NSInteger safeLevel = [elementInfo[@"safeLevel"] integerValue];
    NSString *str = [NSString stringWithFormat:@"危险指数：%ld。%@%@%@\n%@", safeLevel, huoxing?@"该成分为活性成分。":@"", zhidou?@"\n包含该成分的化妆品可能致逗噢。":@"", otherName.length>0?[NSString stringWithFormat:@"\n还有人称它为 %@。", otherName]:@"", desc];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: UIColorFromHex(0xABABAB)}];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:@(safeLevel).stringValue]];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:@"活性成分"]];
    [attri addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:[str rangeOfString:otherName]];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height+10, self.view.width-30, 17)];
    descLabel.textColor = UIColorFromHex(0xABABAB);
    descLabel.numberOfLines = NSUIntegerMax;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.attributedText = attri;
    [headerView addSubview:descLabel];
    descLabel.height = [descLabel sizeThatFits:CGSizeMake(descLabel.width, CGFLOAT_MAX)].height;
    height = CGRectGetMaxY(descLabel.frame)+20;
    headerView.height = height+15;
    [headerView addLine:GRAY_BG_COLOR frame:CGRectMake(0, headerView.height-15, headerView.width, 15)];
    self.tableView.tableHeaderView = headerView;
    
    compareNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, self.navigationController.navigationBar.height)];
    
    UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    compareBtn.frame = CGRectMake(8, 8, 50, compareNumView.height-16);
    [compareBtn setTitle:@"对比" forState:UIControlStateNormal];
    compareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [compareBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    [compareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [compareBtn addTarget:self action:@selector(showCompareView) forControlEvents:UIControlEventTouchUpInside];
    [compareNumView addSubview:compareBtn];
    
    comparNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(3+compareBtn.width-10, 5, 15, 15)];
    comparNumLabel.backgroundColor = UIColorFromHex(0xFF4545);
    comparNumLabel.layer.cornerRadius = comparNumLabel.width/2;
    comparNumLabel.clipsToBounds = YES;
    comparNumLabel.textAlignment = NSTextAlignmentCenter;
    comparNumLabel.font = [UIFont systemFontOfSize:11];
    comparNumLabel.text = @"1";
    comparNumLabel.textColor = [UIColor whiteColor];
    [compareNumView addSubview:comparNumLabel];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SearchInfoViewCell class] forCellReuseIdentifier:@"SearchInfoViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:compareNumView];
    
    [self refrushCompareNum];
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

- (void)refresh:(UIRefreshControl *)refreshControl{
    [ALRequest requestPOSTAPI:@"productElement/loadDetail" postData:@{@"id": elementInfo[@"id"],
                                                                      @"offsetIndex": @(0),
                                                                      @"pageSize": @(10)} success:^(id result) {
        NSArray *temp = result[@"obj"][@"products"];
        [datas removeAllObjects];
        [datas addObjectsFromArray:temp];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
        footerActivityView.hidden = YES;
        [footerActivityView stopAnimating];
    } failed:^(id result, NSError *error) {
        footerActivityView.hidden = YES;
        [footerActivityView stopAnimating];
        [refreshControl endRefreshing];
    }];
}

- (void)refrushCompareNum{
    if ([UIApplication appDelegate].compareDatas.count<=0) {
        compareNumView.hidden = YES;
    } else {
        compareNumView.hidden = NO;
        comparNumLabel.text = @([UIApplication appDelegate].compareDatas.count).stringValue;
    }
}

- (void)showCompareView{
    CompareProductViewController *compare = [[CompareProductViewController alloc] initWithNibName:@"CompareProductViewController" bundle:nil];
    [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:compare animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId2 = @"SearchInfoViewCell";
    SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
    cell.data = datas[indexPath.row];
    cell.tag = indexPath.row;
    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=0) {
        ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithData:datas[indexPath.row]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.height) {
        if (footerActivityView.hidden&&!endLogo) {
            [footerActivityView startAnimating];
            footerActivityView.hidden = NO;
            [ALRequest requestPOSTAPI:@"productElement/loadDetail" postData:@{@"id": elementInfo[@"id"],
                                                                              @"offsetIndex": @(datas.count),
                                                                              @"pageSize": @(10)} success:^(id result) {
                [footerActivityView stopAnimating];
                footerActivityView.hidden = YES;
                NSArray *temp = result[@"obj"][@"products"];
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
