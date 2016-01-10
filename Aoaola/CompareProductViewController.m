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

#define kDefaultCellHeight 40
#define kTableWidth 40
#define kValueTableWidth 100

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"产品对比";
    
    titleArr = [[NSArray alloc] initWithObjects:@"图片",@"名字",@"功效",@"备案",@"危险",@"孕妇\n禁用",@"美白",@"抗老",@"成分", nil];
    
    UITableView *titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, kTableWidth, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT) style:UITableViewStylePlain];
    titleTableView.delegate = self;
    titleTableView.dataSource = self;
    titleTableView.tag = 100;
    titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:titleTableView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kTableWidth, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH-kTableWidth, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT)];
    _scrollView.contentSize = CGSizeMake(kValueTableWidth*5, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT);
    [self.view addSubview:_scrollView];
    
    for (NSInteger i=1; i<=5; i++) {
        UITableView *valueTableView = [[UITableView alloc] initWithFrame:CGRectMake(kValueTableWidth*(i-1), 0, kValueTableWidth, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT) style:UITableViewStylePlain];
        valueTableView.delegate = self;
        valueTableView.dataSource = self;
        valueTableView.tag = i;
        valueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:valueTableView];
    }
}



#pragma mark - 
#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) return 80;
    if (indexPath.row==8) return kDefaultCellHeight*3;
    return kDefaultCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CGFloat height = kDefaultCellHeight;
    if (indexPath.row==0) {
        height = 80;
    }
    if (indexPath.row==8) {//成分行,更具成分个数需要适应高度
        height = kDefaultCellHeight*3;
    }
    
    //标题列
    if (tableView.tag==100) {
        cell.contentView.backgroundColor = COLOR_APP_WHITE;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTableWidth, height)];
        title.text = titleArr[indexPath.row];
        title.textColor = COLOR_APP_GRAY;
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:11];
        title.numberOfLines = 2;
        [cell.contentView addSubview:title];
        
        [Utils addLine:CGRectMake(0, height-0.5, kTableWidth, 0.5) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
        [Utils addLine:CGRectMake(kTableWidth-0.5, 0, 0.5, height) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
    }else{
        if (indexPath.row==1) {
            cell.contentView.backgroundColor = COLOR_APP_WHITE;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        switch (indexPath.row) {
            case 0://图片
            {
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
                image.center = CGPointMake(kValueTableWidth/2, height/2);
                image.image = [UIImage imageNamed:@"mainproduct_1"];
                [cell.contentView addSubview:image];
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(kValueTableWidth-15-8, 8, 15, 15);
                [deleteBtn setImage:[UIImage imageNamed:@"compare_deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = tableView.tag;
                [deleteBtn addTarget:self action:@selector(deleteTable:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deleteBtn];
            }
                break;
            case 1://产品名称
            {
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kValueTableWidth-20, height)];
                title.text = @"珂润润浸保湿滋养乳霜";
                title.textAlignment = NSTextAlignmentCenter;
                title.font = [UIFont systemFontOfSize:11];
                title.numberOfLines = 2;
                [cell.contentView addSubview:title];
                
            }
                break;
            case 2://功效
            {
                UILabel *fun = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                fun.text = @"保湿  抗氧化";
                fun.textColor = COLOR_APP_GRAY;
                fun.textAlignment = NSTextAlignmentCenter;
                fun.font = [UIFont systemFontOfSize:11];
                fun.numberOfLines = 2;
                [cell.contentView addSubview:fun];
            }
                break;
            case 3://备案
            {
                UILabel *level = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                level.text = @"国产备案";
                level.textColor = COLOR_APP_PINK;
                level.textAlignment = NSTextAlignmentCenter;
                level.font = [UIFont systemFontOfSize:11];
                level.numberOfLines = 2;
                [cell.contentView addSubview:level];
            }
                break;
            case 4://危险
            {
                UILabel *warning = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                warning.text = @"4.9";
                warning.textColor = COLOR_APP_RED;
                warning.textAlignment = NSTextAlignmentCenter;
                warning.font = [UIFont systemFontOfSize:11];
                warning.numberOfLines = 2;
                [cell.contentView addSubview:warning];
            }
                break;
            case 5://孕妇禁用
            {
                UILabel *yunfu = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                yunfu.text = @"3";
                yunfu.textColor = COLOR_APP_GREEN;
                yunfu.textAlignment = NSTextAlignmentCenter;
                yunfu.font = [UIFont systemFontOfSize:11];
                yunfu.numberOfLines = 2;
                [cell.contentView addSubview:yunfu];
            }
                break;
            case 6://美白
            {
                UILabel *meibai = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                meibai.text = @"3";
                meibai.textColor = COLOR_APP_GREEN;
                meibai.textAlignment = NSTextAlignmentCenter;
                meibai.font = [UIFont systemFontOfSize:11];
                meibai.numberOfLines = 2;
                [cell.contentView addSubview:meibai];
            }
                break;
            case 7://抗老
            {
                UILabel *kanglao = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kValueTableWidth, height)];
                kanglao.text = @"3";
                kanglao.textColor = COLOR_APP_GREEN;
                kanglao.textAlignment = NSTextAlignmentCenter;
                kanglao.font = [UIFont systemFontOfSize:11];
                kanglao.numberOfLines = 2;
                [cell.contentView addSubview:kanglao];
            }
                break;
            case 8://成分
            {
                for (NSInteger i=0; i<3; i++) {
                    UILabel *kanglao = [[UILabel alloc] initWithFrame:CGRectMake(10, kDefaultCellHeight*i, kValueTableWidth-20, kDefaultCellHeight)];
                    kanglao.text = @"山梨坦倍半异硬脂酸酯";
                    kanglao.textAlignment = NSTextAlignmentCenter;
                    kanglao.font = [UIFont systemFontOfSize:10];
                    kanglao.numberOfLines = 3;
                    [cell.contentView addSubview:kanglao];
                    
                    [Utils addLine:CGRectMake(0, kDefaultCellHeight*(i+1)-0.5, kValueTableWidth, 0.5) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
                }
            }
                break;
                
            default:
                break;
        }
        
        [Utils addLine:CGRectMake(kValueTableWidth-0.5, 0, 0.5, height) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
        if (tableView.tag==1) {
            [Utils addLine:CGRectMake(0.5, 0, 0.5, height) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
        }
        if (indexPath.row!=8) {
            [Utils addLine:CGRectMake(0, height-0.5, kValueTableWidth, 0.5) superView:cell.contentView withColor:COLOR_APP_LIGHTGRAY];
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
