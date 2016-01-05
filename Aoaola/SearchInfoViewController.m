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

#define T_WIDTH1 160
#define T_WIDTH2 220

@interface SearchInfoViewController ()
{
    NSInteger curSelectType;
    NSString *curSearchStr;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *searchListTable;
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
    
    curSelectType = 0;
}

- (void)showCompareView{
    ProductAboutViewController *about = [[ProductAboutViewController alloc] initWithNibName:@"ProductAboutViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:about animated:YES];
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
