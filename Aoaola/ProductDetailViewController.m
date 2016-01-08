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
#import "BBBadgeBarButtonItem.h"

#define kCompositionHeight 60
#define kCompositionValueHeight 44

@interface ProductDetailViewController ()

@property (strong, nonatomic) BBBadgeBarButtonItem *compareBtn;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"产品详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrushCompareNum) name:kRefrushCompareNum object:nil];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(15, -2, 44, 20);
    [customButton addTarget:self action:@selector(showCompareView) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTitle:@"对比" forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [customButton setTitleColor:COLOR_APP_GREEN forState:UIControlStateNormal];
    
    _compareBtn = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    _compareBtn.badgeOriginX = 30;
    _compareBtn.badgeOriginY = -5;
    if (LOAD_INTEGER(@"compareCount")!=0) {
        self.navigationItem.rightBarButtonItem = _compareBtn;
        _compareBtn.badgeValue = [NSString stringWithFormat:@"%ld",LOAD_INTEGER(@"compareCount")];
    }
    
    [self refrushCompareNum];
}

- (void)refrushCompareNum{
    //    NSDictionary *dict = LOAD_VALUE(@"compareDict");
    NSInteger count = LOAD_INTEGER(@"compareCount");
    if (count<=0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = _compareBtn;
        _compareBtn.badgeValue = [NSString stringWithFormat:@"%ld",count];
    }
}

- (void)showCompareView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 切换成分按钮视图
- (UIView *)addCompositionView:(CGFloat)posY{
    UIView *selectCompositionView = [[UIView alloc] initWithFrame:CGRectMake(0, posY, SCREEN_WIDTH, kCompositionHeight)];
    selectCompositionView.backgroundColor = [UIColor whiteColor];

    for (NSInteger i=0; i<7; i++) {
        NSInteger tempnum = arc4random()%10+1;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((SCREEN_WIDTH/7)*i, 3, SCREEN_WIDTH/7, kCompositionHeight-3);
        [button setTitle:@"全部\n成分\n\n" forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 4;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.tag = i;
        [button addTarget:self action:@selector(selectComposition:) forControlEvents:UIControlEventTouchUpInside];
        [selectCompositionView addSubview:button];
        
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/7, 20)];
        value.center = CGPointMake(button.center.x, button.center.y+13);
        value.text = [NSString stringWithFormat:@"%ld",tempnum];
        value.textAlignment = NSTextAlignmentCenter;
        value.font = [UIFont systemFontOfSize:11];
        value.backgroundColor = [UIColor clearColor];
        [selectCompositionView addSubview:value];
        
        if (tempnum>5) {
            [button setTitleColor:COLOR_APP_GRAY forState:UIControlStateNormal];
            value.textColor = COLOR_APP_GRAY;
        }else{
            [button setTitleColor:COLOR_APP_LIGHTGRAY forState:UIControlStateNormal];
            value.textColor = COLOR_APP_LIGHTGRAY;
        }
        
        if (i<6) {
            [Utils addLine:CGRectMake(button.x+button.width, 0, 0.5, kCompositionHeight) superView:selectCompositionView withColor:COLOR_APP_WHITE];
        }
    }
    
    _moveLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/7-5, 2)];
    [selectCompositionView addSubview:_moveLine];
    _moveLine.backgroundColor = COLOR_APP_GREEN;
    _moveLine.center = CGPointMake(SCREEN_WIDTH/14, kCompositionHeight-2);
    
    return selectCompositionView;
}

- (void)selectComposition:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    
    [UIView animateWithDuration:0.3 animations:^{
        _moveLine.center = CGPointMake(sender.center.x, 58);
    }];
}

#pragma mark - 显示成分列表抬头
- (UIView *)addCompositionView:(CGFloat)posY withType:(NSInteger)type indexPath:(NSIndexPath *)indexPath{
    //type 1:标题  2:值
    UIView *compositionTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, posY, SCREEN_WIDTH, 47)];
    
    UIColor *lineColor = [UIColor whiteColor];
    if (indexPath.row!=0) {
        lineColor = COLOR_APP_WHITE;
    }
    //添加竖线
    UIView *line1 = [Utils addLine:CGRectMake(SCREEN_WIDTH/3, 0, 0.5, kCompositionValueHeight) superView:compositionTitleView withColor:lineColor];
    UIView *line2 = [Utils addLine:CGRectMake(line1.x+SCREEN_WIDTH*2/13, 0, 0.5, kCompositionValueHeight) superView:compositionTitleView withColor:lineColor];
    UIView *line3 = [Utils addLine:CGRectMake(line2.x+SCREEN_WIDTH*2/13, 0, 0.5, kCompositionValueHeight) superView:compositionTitleView withColor:lineColor];
    UIView *line4 = [Utils addLine:CGRectMake(line3.x+SCREEN_WIDTH*2/13, 0, 0.5, kCompositionValueHeight) superView:compositionTitleView withColor:lineColor];
    //添加横线
    [Utils addLine:CGRectMake(0, kCompositionValueHeight-0.5, SCREEN_WIDTH, 0.5) superView:compositionTitleView withColor:COLOR_APP_WHITE];
    
    UIButton *chanpinming = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *weixian = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, kCompositionValueHeight)];
    UILabel *zhidou = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, kCompositionValueHeight)];
    UILabel *mudi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/6, kCompositionValueHeight/2)];
    
    if (type==1) {
        compositionTitleView.backgroundColor = COLOR_APP_WHITE;
        
        [chanpinming setTitle:@"名称" forState:UIControlStateNormal];
        chanpinming.titleLabel.font = [UIFont systemFontOfSize:12];
        [chanpinming setTitleColor:COLOR_APP_GRAY forState:UIControlStateNormal];
        
        weixian.text = @"危险指数";
        weixian.textColor = COLOR_APP_GRAY;
        weixian.font = [UIFont systemFontOfSize:12.];
        
        UILabel *huoxing = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, kCompositionValueHeight)];
        huoxing.center = CGPointMake(line2.x + (line3.x-line2.x)/2, kCompositionValueHeight/2);
        huoxing.numberOfLines = 2;
        huoxing.text = @"活性成分";
        huoxing.textColor = COLOR_APP_GRAY;
        huoxing.font = [UIFont systemFontOfSize:12.];
        huoxing.textAlignment = NSTextAlignmentCenter;
        [compositionTitleView addSubview:huoxing];
        
        zhidou.text = @"致逗风险";
        zhidou.textColor = COLOR_APP_GRAY;
        zhidou.font = [UIFont systemFontOfSize:12.];
        
        mudi.text = @"使用目的";
        
    }else{
        compositionTitleView.backgroundColor = [UIColor whiteColor];
        
        [chanpinming setTitle:@"水" forState:UIControlStateNormal];
        chanpinming.titleLabel.font = [UIFont systemFontOfSize:20];
        chanpinming.tag = indexPath.row;
        [chanpinming addTarget:self action:@selector(showProductAbout:) forControlEvents:UIControlEventTouchUpInside];
        [chanpinming setTitleColor:COLOR_APP_GREEN forState:UIControlStateNormal];
        
        weixian.frame = CGRectMake(0, 0, 13, 13);
        weixian.text = @"0";
        weixian.textColor = COLOR_APP_GREEN;
        weixian.font = [UIFont systemFontOfSize:12.];
        
        UIImageView *huoxingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape Copy"]];
        huoxingImage.frame = CGRectMake(0, 0, 8, 12);
        huoxingImage.center = CGPointMake(line2.x + (line3.x-line2.x)/2, kCompositionValueHeight/2);
        [compositionTitleView addSubview:huoxingImage];
        
        zhidou.frame = CGRectMake(0, 0, 14, 14);
        zhidou.text = @"1";
        zhidou.textColor = [UIColor whiteColor];
        zhidou.backgroundColor = COLOR_APP_RED;
        zhidou.layer.masksToBounds = YES;
        zhidou.layer.cornerRadius = 7;
        zhidou.font = [UIFont systemFontOfSize:10.];
        
        mudi.text = @"去角质";
    }
    
    chanpinming.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, kCompositionValueHeight);
    [compositionTitleView addSubview:chanpinming];
    
    weixian.center = CGPointMake(line1.x + (line2.x-line1.x)/2, kCompositionValueHeight/2);
    weixian.numberOfLines = 2;
    weixian.textAlignment = NSTextAlignmentCenter;
    [compositionTitleView addSubview:weixian];
    
    zhidou.center = CGPointMake(line3.x + (line4.x-line3.x)/2, kCompositionValueHeight/2);
    zhidou.numberOfLines = 2;
    zhidou.textAlignment = NSTextAlignmentCenter;
    [compositionTitleView addSubview:zhidou];
    
    mudi.center = CGPointMake(line4.x + (SCREEN_WIDTH-line4.x)/2, kCompositionValueHeight/2);
    mudi.textAlignment = NSTextAlignmentCenter;
    mudi.textColor = COLOR_APP_GRAY;
    mudi.font = [UIFont systemFontOfSize:12.];
    [compositionTitleView addSubview:mudi];
    
    return compositionTitleView;
}

- (void)showProductAbout:(UIButton *)sender{
    ProductAboutViewController *about = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:about animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 410;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCompositionValueHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductDetailView" owner:self options:nil];
    UIView *productView = [nib objectAtIndex:0];
    [productView addSubview:[self addCompositionView:410-107]];
    [productView addSubview:[self addCompositionView:410-47 withType:1 indexPath:0]];
    return productView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"valueCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"valueCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self addCompositionView:0 withType:2 indexPath:0]];
    }
    return cell;
}


@end
