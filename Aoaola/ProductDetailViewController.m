//
//  ProductDetailViewController.m
//  Aoaola
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "AdditionsMacro.h"
#import "Utils.h"
#import "ElementDetailViewController.h"
#import "ProductDetailView.h"
#import "CompareProductViewController.h"
#import "SearchInfoViewCell.h"
#import "ElementsTableViewCell.h"
#define kCompositionHeight 60
#define kCompositionValueHeight 44
static NSString *cellIdentifier = @"SearchInfoViewCell2";
static NSString *detailCellIdentifier = @"productDetailCell";
static NSString *elementCellIdentifier = @"elementCellIdentifier";

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController {
    UIView *compareNumView;
    UILabel *comparNumLabel;
    UIImageView *endLogo;
    UIView *footerView;
    NSMutableArray *datas;
    NSDictionary *productInfo;
    NSMutableArray *yunfuArr;
    NSMutableArray *meibaiArr;
    NSMutableArray *ganguangArr;
    NSMutableArray *kanglaoArr;
    NSMutableArray *gaoweiArr;
    NSMutableArray *baoshiArr;
    float realSafeLevel;
    NSString *descString;
    NSMutableArray *listDatas;
}

- (instancetype)initWithData:(NSDictionary *)data{
    self = [super initWithNibName:@"ProductDetailViewController" bundle:nil];
    if (self) {
        productInfo = [data copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"产品详情";
    
    self.tableView.backgroundColor = UIColorFromHex(0xF7F7F7);
    datas = [[NSMutableArray alloc] init];
    yunfuArr = [[NSMutableArray alloc] init];
    meibaiArr = [[NSMutableArray alloc] init];
    ganguangArr = [[NSMutableArray alloc] init];
    kanglaoArr = [[NSMutableArray alloc] init];
    gaoweiArr = [[NSMutableArray alloc] init];
    baoshiArr = [[NSMutableArray alloc] init];

    listDatas = [[NSMutableArray alloc] initWithObjects:datas, yunfuArr, meibaiArr, ganguangArr, kanglaoArr, gaoweiArr, baoshiArr, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrushCompareNum) name:kRefrushCompareNum object:nil];
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:compareNumView];
    
//    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[SearchInfoViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductDetailView" bundle:nil] forCellReuseIdentifier:detailCellIdentifier];
    [self.tableView registerClass:[ElementsTableViewCell class] forCellReuseIdentifier:elementCellIdentifier];

    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 40)];
    [footerView addLine:[UIColor whiteColor] frame:CGRectMake(0, 0, self.view.width, .5)];
    endLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
    if (endLogo.height>20) {
        endLogo.bounds = CGRectMake(0, 0, 20, 20);
    }
    endLogo.center = CGPointMake(footerView.width/2, footerView.height/2);
    [footerView addSubview:endLogo];

    self.tableView.tableFooterView = footerView;

    [self refrushCompareNum];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = APP_COLOR;
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self refresh:nil];
}

- (void)refresh:(UIRefreshControl *)refreshControl{
    [ALRequest requestPOSTAPI:@"productNew/getById" postData:@{@"id": productInfo[@"id"]} success:^(id result) {
        NSArray *temp = result[@"obj"][@"elements"];
        NSLog(@"%@", temp);
        if (temp&&temp.count>0) {
            NSInteger totalSafeLevel = 0;
            BOOL zhidou = NO;
            for (NSDictionary *dict in temp) {
                BOOL baoshi = [dict[@"baoshi"] boolValue];
                BOOL yunfu = [dict[@"yunfu"] boolValue];
                BOOL meibai = [dict[@"meibai"] boolValue];
                BOOL kanglao = [dict[@"kanglao"] boolValue];
                BOOL gaowei = [dict[@"gaowei"] boolValue];
                BOOL ganguang = [dict[@"baoshi"] boolValue];
                if ([dict[@"zhidou"] boolValue]) {
                    zhidou = YES;
                }
                NSInteger safeLevel = [dict[@"safeLevel"] integerValue];
                totalSafeLevel += safeLevel;
                if (baoshi) {
                    [baoshiArr addObject:dict];
                }
                if (yunfu) {
                    [yunfuArr addObject:dict];
                }
                if (meibai) {
                    [meibaiArr addObject:dict];
                }
                if (kanglao) {
                    [kanglaoArr addObject:dict];
                }
                if (gaowei) {
                    [gaoweiArr addObject:dict];
                }
                if (ganguang) {
                    [ganguangArr addObject:dict];
                }
                [datas addObject:dict];
            }
            realSafeLevel = totalSafeLevel/(float)temp.count;
            NSString *tempStr = [NSString stringWithFormat:@"%@%@",zhidou?@"有致逗风险。":@"",
                              yunfuArr.count>0?@"不建议孕妇使用该产品。":@""];
            if (tempStr.length<=0) {
                tempStr = @"👍";
            }
            descString = [NSString stringWithFormat:@"该产品共包含 %ld 种成分，危险指数平均值为 %.1f\n%@",
                          temp.count, realSafeLevel,tempStr];
            [self.tableView reloadData];
        }
        [refreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    } failed:^(id result, NSError *error) {
        [refreshControl endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
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

- (void)selectComposition:(UIButton *)btn{
    _moveLine.tag = btn.tag;
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _moveLine.center = CGPointMake(btn.center.x, _moveLine.center.y);
    } completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
        UIView *selectCompositionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCompositionHeight)];
        selectCompositionView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[@"全部成分", @"孕妇禁用", @"美白成分", @"感光成分", @"抗老成分", @"高危成分", @"保湿成分"];
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SCREEN_WIDTH/7)*i, 3, SCREEN_WIDTH/7, kCompositionHeight-3);
            NSString *title = titles[i];
            NSArray *tempArr = listDatas[i];
            NSString *str = [NSString stringWithFormat:@"%@\n%@\n\n%ld", [title substringWithRange:NSMakeRange(0, 2)], [title substringWithRange:NSMakeRange(2, 2)], tempArr.count];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: UIColorFromHex(0x8F8F8F)}];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:4] range:NSMakeRange(5, 2)];
            [button setAttributedTitle:attri forState:UIControlStateNormal];
            {
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: UIColorFromHex(0xC6C6C6)}];
                [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:4] range:NSMakeRange(5, 2)];
                [button setAttributedTitle:attri forState:UIControlStateDisabled];
            }
            button.titleLabel.numberOfLines = 4;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            button.tag = i;
            if (tempArr.count<=0) {
                button.enabled = NO;
            }
            [button addTarget:self action:@selector(selectComposition:) forControlEvents:UIControlEventTouchUpInside];
            [selectCompositionView addSubview:button];
            
            if (i<6) {
                [Utils addLine:CGRectMake(button.x+button.width, 0, 0.5, kCompositionHeight) superView:selectCompositionView withColor:COLOR_APP_WHITE];
            }
        }
        [headerView addSubview:selectCompositionView];
        
        _moveLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/7-5, 2)];
        [selectCompositionView addSubview:_moveLine];
        _moveLine.backgroundColor = COLOR_APP_GREEN;
        _moveLine.center = CGPointMake(SCREEN_WIDTH/14, kCompositionHeight-1);
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, kCompositionHeight, self.view.width, 44)];
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
        [headerView addSubview:header];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 104;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 160;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        NSArray *tempArr = listDatas[_moveLine.tag];
        ElementDetailViewController *detail  = [[ElementDetailViewController alloc] initWithData:tempArr[indexPath.row]];
        [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.data = productInfo;
            return cell;
        } else if (indexPath.row==1) {
            ProductDetailView *detail = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier forIndexPath:indexPath];
            if (realSafeLevel>=3) {
                detail.scoreLabel.textColor = UIColorFromHex(0xFFA845);
            } else if (realSafeLevel>=4) {
                detail.scoreLabel.textColor = UIColorFromHex(0xFF4545);
            } else {
                detail.scoreLabel.textColor = APP_COLOR;
            }
            detail.scoreLabel.text = [NSString stringWithFormat:@"%.1f", realSafeLevel];
            detail.descLabel.text = descString;
            return detail;
        }
    }
    NSArray *tempArr = listDatas[_moveLine.tag];
    ElementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:elementCellIdentifier forIndexPath:indexPath];
    cell.data = tempArr[indexPath.row];
    return cell;
}


@end
