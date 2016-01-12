//
//  CompareProductViewController.m
//  Aoaola
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "CompareProductViewController.h"
#import "AdditionsMacro.h"
#import "Utils.h"
#import "CompareProductTableViewCell.h"

#define kDefaultCellHeight 40
#define kTableWidth 40
#define kValueTableWidth 100
static NSString *cellIdentifier = @"cellIdentifier";

@interface CompareProductViewController () <UITableViewDelegate,
                                            UITableViewDataSource>

{
    NSArray *titleArr;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CompareProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    {//用于解决不同版本的iOS对ScrollView的contentInset支持不统一的问题
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    self.navigationItem.title = @"产品对比";
    
    titleArr = [[NSArray alloc] initWithObjects:@"图片",@"名字",@"功效",@"备案",@"危险",@"孕妇\n禁用",@"美白",@"抗老",@"成分", nil];
    
    float temp = kDefaultCellHeight*21;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kTableWidth, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH-kTableWidth, SCREEN_HEIGHT-(NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT))];
    _scrollView.contentSize = CGSizeMake(kValueTableWidth*5, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i=1; i<=5; i++) {
        UITableView *valueTableView = [[UITableView alloc] initWithFrame:CGRectMake(kValueTableWidth*(i-1), 0, kValueTableWidth, _scrollView.height) style:UITableViewStylePlain];
        valueTableView.delegate = self;
        valueTableView.dataSource = self;
        valueTableView.tag = i;
        valueTableView.showsVerticalScrollIndicator = NO;
        [valueTableView registerClass:[CompareProductTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        valueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:valueTableView];
        [valueTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(0, 0, .5, temp)];
        if (i==5) {
            [valueTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(kValueTableWidth-.5, 0, .5, temp)];
        }
    }
    
    UITableView *titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _scrollView.y , kTableWidth, _scrollView.height) style:UITableViewStylePlain];
    titleTableView.delegate = self;
    titleTableView.dataSource = self;
    titleTableView.tag = 100;
    titleTableView.showsVerticalScrollIndicator = NO;
    [titleTableView registerClass:[CompareProductTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:titleTableView];
    [titleTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(kTableWidth, 0, .5, temp)];
    titleTableView.clipsToBounds = NO;
}


#pragma mark - 
#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==100) {
        return 9;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) return 80;
    if (tableView.tag==100) {
        if (indexPath.row==8) {
            return kDefaultCellHeight*(20-8);
        }
    }
    return kDefaultCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompareProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    CGFloat height = kDefaultCellHeight;
    if (indexPath.row==0) {
        height = 80;
    }
    
    //标题列
    if (tableView.tag==100) {
        if (!cell.configed) {
            cell.contentView.backgroundColor = COLOR_APP_WHITE;
            cell.label.textColor = COLOR_APP_GRAY;
            cell.label.textAlignment = NSTextAlignmentCenter;
            cell.label.font = [UIFont systemFontOfSize:11];
            cell.label.numberOfLines = 2;
        }
        if (indexPath.row==8) {
            cell.label.height = 40;
        } else {
            cell.label.height = height;
        }
        cell.label.text = titleArr[indexPath.row];
        cell.bottomLine.hidden = indexPath.row!=8;
    }else{
        if (indexPath.row==1) {
            cell.contentView.backgroundColor = COLOR_APP_WHITE;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        cell.bottomLine.hidden = indexPath.row!=19;
        if (indexPath.row==0) {
            if (cell.icon.image==nil) {
                cell.icon.bounds = CGRectMake(0, 0, height, height);
                cell.icon.center = CGPointMake(kValueTableWidth/2, height/2);
                cell.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cell.deleteBtn.frame = CGRectMake(kValueTableWidth-15-8, 8, 15, 15);
                [cell.deleteBtn setImage:[UIImage imageNamed:@"compare_deleteBtn"] forState:UIControlStateNormal];
                [cell.deleteBtn addTarget:self action:@selector(deleteTable:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cell.deleteBtn];
            }
            cell.icon.image = [UIImage imageNamed:@"mainproduct_1"];
            cell.icon.hidden = NO;
            cell.deleteBtn.hidden = NO;
            cell.label.hidden = YES;
        } else {
            cell.label.hidden = NO;
            cell.icon.hidden = YES;
            cell.deleteBtn.hidden = YES;
            switch (indexPath.row) {
                case 0://图片
                {
                    break;
                }
                case 1://产品名称
                {
                    cell.label.frame = CGRectMake(10, 0, kValueTableWidth-20, height);
                    cell.label.text = @"珂润润浸保湿滋养乳霜";
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                    
                    break;
                }
                case 2://功效
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"保湿  抗氧化";
                    cell.label.textColor = COLOR_APP_GRAY;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 3://备案
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"国产备案";
                    cell.label.textColor = COLOR_APP_PINK;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 4://危险
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"4.9";
                    cell.label.textColor = COLOR_APP_RED;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                    [cell.contentView addSubview:cell.label];
                }
                    break;
                case 5://孕妇禁用
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"3";
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 6://美白
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"3";
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 7://抗老
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = @"3";
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                default:{
                    cell.label.frame = CGRectMake(10, 0, kValueTableWidth-20, kDefaultCellHeight);
                    cell.label.text = @"山梨坦倍半异硬脂酸酯";
                    cell.label.textColor = [UIColor blackColor];
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:10];
                    cell.label.adjustsFontSizeToFitWidth = YES;
                    cell.label.numberOfLines = 3;
                }
                    break;
            }
        }
    }
    
    
    
    
    return cell;
}

#pragma mark -
#pragma mark - 删除其中一个产品table回调处理
- (void)deleteTable:(UIButton *)sender{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"删除第%ld个table",sender.tag] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
}

#pragma mark -
#pragma mark - table 联动


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    for (NSInteger i = 1; i <= 5; i++) {
        if (i!=scrollView.tag) {
            UITableView *table = (UITableView*)[_scrollView viewWithTag:i];
            [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag!=100) {
        UITableView *table = (UITableView*)[self.view viewWithTag:100];
        [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    }
    for (NSInteger i = 1; i <= 5; i++) {
        if (i!=scrollView.tag) {
            UITableView *table = (UITableView*)[_scrollView viewWithTag:i];
            [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        }
    }
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
