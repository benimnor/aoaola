//
//  SearchInfoViewController.m
//  Aoaola
//
//  Created by Peter on 15/12/30.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "SearchInfoViewController.h"
#import "AdditionsMacro.h"
#import "SearchInfoViewCell.h"
#import "BBBadgeBarButtonItem.h"
#import "ProductAboutViewController.h"
#import "Utils.h"

#define T_WIDTH1 160
#define T_WIDTH2 220
#define COM_CELL_HEIGHT 44

@interface SearchInfoViewController ()
{
    NSInteger curSelectType;
    NSString *curSearchStr;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *searchListTable;
@property (strong, nonatomic) UITableView *compositionTable;
@property (strong, nonatomic) BBBadgeBarButtonItem *compareBtn;
@end

@implementation SearchInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SAVE_INTEGER(@"compareCount", 0);
    curSelectType = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_APP_WHITE;
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrushCompareNum) name:kRefrushCompareNum object:nil];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(15, -2, 44, 20);
    [customButton addTarget:self action:@selector(showCompareView) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTitle:@"对比" forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [customButton setTitleColor:COLOR_APP_GREEN forState:UIControlStateNormal];
    
    _compareBtn = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    _compareBtn.badgeValue = @"0";
    _compareBtn.badgeOriginX = 30;
    _compareBtn.badgeOriginY = -5;
//    self.navigationItem.rightBarButtonItem = _compareBtn;
    
    [self refrushCompareNum];
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = searchView;
    
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,searchView.width,44)];
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setPlaceholder:@"搜索"];
    
    [searchView addSubview:_searchBar];
    
    _compositionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 117, SCREEN_WIDTH, COM_CELL_HEIGHT*4) style:UITableViewStylePlain];
    _compositionTable.delegate = self;
    _compositionTable.dataSource = self;
    _compositionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _compositionTable.scrollEnabled = NO;
    [self.view addSubview:_compositionTable];
    _compositionTable.hidden = YES;
    
}

- (void)showCompareView{
   
}

- (void)refrushCompareNum{
//    NSDictionary *dict = LOAD_VALUE(@"compareDict");
    NSInteger count = LOAD_INTEGER(@"compareCount");
    if (count<=0) {
        self.navigationItem.rightBarButtonItem = nil;
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    }else{
        self.navigationItem.rightBarButtonItem = _compareBtn;
        if (_searchBar.showsCancelButton) {
            _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30-T_WIDTH1*kScaleSize, 44);
        }else{
            _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30-T_WIDTH2*kScaleSize, 44);
        }
        
        _compareBtn.badgeValue = [NSString stringWithFormat:@"%d",count];
    }
}

- (IBAction)segmengAction:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    curSelectType = index;
    [self getsearchList];
}

#pragma mark - 网络请求,获取搜索信息列表
#pragma mark -
- (void)getsearchList{
    if (curSelectType == 0) {//产品列表
        _searchListTable.hidden = NO;
        _compositionTable.hidden = YES;
        self.view.backgroundColor = COLOR_APP_WHITE;
    }else{//成分列表
        _searchListTable.hidden = YES;
        _compositionTable.hidden = NO;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self getSearchListInfoWithType:curSelectType andSearchStr:curSearchStr];
}

- (void)getSearchListInfoWithType:(NSInteger)type andSearchStr:(NSString *)searchStr{
    
}

#pragma mark - UITableView代理实现
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_compositionTable) {
        return 4;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_compositionTable) {
        return COM_CELL_HEIGHT;
    }
    return 164;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_compositionTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compositionCell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"compositionCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIColor *lineColor = [UIColor whiteColor];
        if (indexPath.row!=0) {
            lineColor = COLOR_APP_WHITE;
        }
        //添加竖线
        UIView *line1 = [Utils addLine:CGRectMake(SCREEN_WIDTH/3, 0, 0.5, COM_CELL_HEIGHT) superView:cell.contentView withColor:lineColor];
        UIView *line2 = [Utils addLine:CGRectMake(line1.x+SCREEN_WIDTH*2/13, 0, 0.5, COM_CELL_HEIGHT) superView:cell.contentView withColor:lineColor];
        UIView *line3 = [Utils addLine:CGRectMake(line2.x+SCREEN_WIDTH*2/13, 0, 0.5, COM_CELL_HEIGHT) superView:cell.contentView withColor:lineColor];
        UIView *line4 = [Utils addLine:CGRectMake(line3.x+SCREEN_WIDTH*2/13, 0, 0.5, COM_CELL_HEIGHT) superView:cell.contentView withColor:lineColor];
        //添加横线
        [Utils addLine:CGRectMake(0, COM_CELL_HEIGHT-0.5, SCREEN_WIDTH, 0.5) superView:cell.contentView withColor:COLOR_APP_WHITE];

        UIButton *chanpinming = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *weixian = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, COM_CELL_HEIGHT)];
        UILabel *zhidou = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, COM_CELL_HEIGHT)];
        UILabel *mudi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/6, COM_CELL_HEIGHT/2)];

        if (indexPath.row==0) {
            cell.contentView.backgroundColor = COLOR_APP_WHITE;
            
            [chanpinming setTitle:@"名称" forState:UIControlStateNormal];
            chanpinming.titleLabel.font = [UIFont systemFontOfSize:12];
            [chanpinming setTitleColor:COLOR_APP_GRAY forState:UIControlStateNormal];
            
            weixian.text = @"危险指数";
            weixian.textColor = COLOR_APP_GRAY;
            weixian.font = [UIFont systemFontOfSize:12.];
            
            UILabel *huoxing = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, COM_CELL_HEIGHT)];
            huoxing.center = CGPointMake(line2.x + (line3.x-line2.x)/2, COM_CELL_HEIGHT/2);
            huoxing.numberOfLines = 2;
            huoxing.text = @"活性成分";
            huoxing.textColor = COLOR_APP_GRAY;
            huoxing.font = [UIFont systemFontOfSize:12.];
            huoxing.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:huoxing];
            
            zhidou.text = @"致逗风险";
            zhidou.textColor = COLOR_APP_GRAY;
            zhidou.font = [UIFont systemFontOfSize:12.];
            
            mudi.text = @"使用目的";
            
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
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
            huoxingImage.center = CGPointMake(line2.x + (line3.x-line2.x)/2, COM_CELL_HEIGHT/2);
            [cell.contentView addSubview:huoxingImage];
            
            zhidou.frame = CGRectMake(0, 0, 14, 14);
            zhidou.text = @"1";
            zhidou.textColor = [UIColor whiteColor];
            zhidou.backgroundColor = COLOR_APP_RED;
            zhidou.layer.masksToBounds = YES;
            zhidou.layer.cornerRadius = 7;
            zhidou.font = [UIFont systemFontOfSize:10.];
            
            mudi.text = @"去角质";
        }
        
        chanpinming.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, COM_CELL_HEIGHT);
        [cell.contentView addSubview:chanpinming];
        
        weixian.center = CGPointMake(line1.x + (line2.x-line1.x)/2, COM_CELL_HEIGHT/2);
        weixian.numberOfLines = 2;
        weixian.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:weixian];
        
        zhidou.center = CGPointMake(line3.x + (line4.x-line3.x)/2, COM_CELL_HEIGHT/2);
        zhidou.numberOfLines = 2;
        zhidou.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:zhidou];
        
        mudi.center = CGPointMake(line4.x + (SCREEN_WIDTH-line4.x)/2, COM_CELL_HEIGHT/2);
        mudi.textAlignment = NSTextAlignmentCenter;
        mudi.textColor = COLOR_APP_GRAY;
        mudi.font = [UIFont systemFontOfSize:12.];
        [cell.contentView addSubview:mudi];
        
        return cell;
    }else{
        static NSString *cellId = @"SearchInfoViewCell";
        SearchInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            UINib *nib=[UINib nibWithNibName:cellId bundle:nil ];
            [tableView registerNib:nib forCellReuseIdentifier:cellId];
            cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        }
        cell.tag = indexPath.row;
        cell.titleLabel.text = @"珂润润浸保湿滋养乳霜珂润润浸保湿滋养乳霜";
        cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        cell.functionLabel.text = @"保湿  抗氧化";
        cell.levelLabel.text = @"国产备案";
        return cell;
    }
    return nil;
}

- (void)showProductAbout:(UIButton *)sender{
    ProductAboutViewController *about = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:about animated:YES];
}


#pragma mark - UISearchBarDelegate代理实现
#pragma mark -
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    if (LOAD_INTEGER(@"compareCount")!=0) {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30-T_WIDTH1*kScaleSize, 44);
    }
    
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelBtn setTintColor:COLOR_APP_GREEN];
        }
    }
    
    return YES;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (LOAD_INTEGER(@"compareCount")==0) {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    }else{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30-T_WIDTH2*kScaleSize, 44);
    }
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (LOAD_INTEGER(@"compareCount")==0) {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 44);
    }else{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-30-T_WIDTH2*kScaleSize, 44);
    }
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    curSearchStr = searchBar.text;
    [self getsearchList];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
