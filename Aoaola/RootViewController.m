//
//  RootViewController.m
//  Aoaola
//
//  Created by Peter on 15/12/21.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "RootViewController.h"
#import "Utils.h"
#import "MainViewController.h"
#import "DefaultSearchViewController.h"
#import "SearchInfoViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    
    MainViewController *mainView = [[MainViewController alloc] init];
    mainView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addChildViewController:mainView];
    [self.view addSubview:mainView.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate代理实现
#pragma mark -
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchInfoViewController *defaultSearch = [[SearchInfoViewController alloc] init];
    [self.navigationController pushViewController:defaultSearch animated:YES];

    
    return NO;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@".....");
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
