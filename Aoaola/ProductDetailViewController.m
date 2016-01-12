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
#import "ProductAboutViewController.h"
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"产品详情";
    
    self.tableView.backgroundColor = UIColorFromHex(0xF7F7F7);
    datas = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<20; i++) {
        [datas addObject:@""];
    }

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
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchInfoViewCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductDetailView" bundle:nil] forCellReuseIdentifier:detailCellIdentifier];
    [self.tableView registerClass:[ElementsTableViewCell class] forCellReuseIdentifier:elementCellIdentifier];

    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 40)];
    endLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
    if (endLogo.height>20) {
        endLogo.bounds = CGRectMake(0, 0, 20, 20);
    }
    endLogo.center = CGPointMake(footerView.width/2, footerView.height/2);
    [footerView addSubview:endLogo];

    self.tableView.tableFooterView = footerView;

    [self refrushCompareNum];
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

- (void)showProductAbout:(UIButton *)sender{
    ProductAboutViewController *about = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:about animated:YES];
}


#pragma mark - Table view data source

- (void)selectComposition:(UIButton *)btn{
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _moveLine.center = CGPointMake(btn.center.x, _moveLine.center.y);
    } completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
        UIView *selectCompositionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCompositionHeight)];
        selectCompositionView.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i=0; i<7; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SCREEN_WIDTH/7)*i, 3, SCREEN_WIDTH/7, kCompositionHeight-3);
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"全部\n成分\n\n15" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName: COLOR_APP_GRAY}];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:4] range:NSMakeRange(5, 2)];
            [button setAttributedTitle:attri forState:UIControlStateNormal];
            button.titleLabel.numberOfLines = 4;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            button.tag = i;
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
        return 164;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        ProductAboutViewController *detail  = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
        [(UINavigationController *)[UIApplication appDelegate].window.rootViewController pushViewController:detail animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"珂润润浸保湿滋养乳霜珂润润浸保湿滋养乳霜";
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
            cell.functionLabel.text = @"保湿  抗氧化";
            cell.levelLabel.text = @"国产备案";
            return cell;
        } else if (indexPath.row==1) {
            ProductDetailView *detail = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier forIndexPath:indexPath];
            return detail;
        }
    }
    ElementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:elementCellIdentifier forIndexPath:indexPath];
    return cell;
}


@end
