//
//  DefaultSearchViewController.m
//  Aoaola
//
//  Created by Peter on 15/12/30.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "DefaultSearchViewController.h"
#import "SearchInfoViewController.h"
#import "AdditionsMacro.h"


@interface DefaultSearchViewController ()
{
    NSInteger curSelectType;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *defaultSearchTable;
@end

@implementation DefaultSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curSelectType = 0;
    
    self.navigationItem.hidesBackButton = YES;
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = searchView;
    
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,searchView.width,44)];
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setPlaceholder:@"搜索"];
    [searchView addSubview:_searchBar];
    
}

- (IBAction)segmengAction:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    curSelectType = index;
    [self getDefaultInfo];
    [_defaultSearchTable reloadData];
}

#pragma mark - 网络请求,获取搜索信息列表
#pragma mark -
- (void)getDefaultInfo{
    
}

#pragma mark - UITableView代理实现
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 2;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:COLOR_APP_GRAY];
    [footer.textLabel setFont:[UIFont systemFontOfSize:13]];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"小伙伴们正在搜";
    }
    return @"历史搜索";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar endEditing:YES];
    [_searchBar setShowsCancelButton:NO animated:YES];
    SearchInfoViewController *search = [[SearchInfoViewController alloc] init];
    [search getSearchListInfoWithType:curSelectType andSearchStr:@""];
    [self.navigationController pushViewController:search animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultSeachCell"];
//    if (!cell) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultSeachCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, CELL_HEIGHT)];
        label.text = curSelectType==0?@"欧莱雅":@"水杨酸";
        label.textColor = COLOR_APP_GREEN;
        label.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:label];
//    }
    return cell;
}


#pragma mark - UISearchBarDelegate代理实现
#pragma mark -
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancelBtn setTintColor:COLOR_APP_GREEN];
        }
    }
    
    return YES;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length==0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入搜索条件!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar endEditing:YES];
    SearchInfoViewController *search = [[SearchInfoViewController alloc] init];
    [search getSearchListInfoWithType:curSelectType andSearchStr:searchBar.text];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar endEditing:YES];
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
