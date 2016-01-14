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

@implementation CompareProductViewController {
    NSMutableArray *datas;
    float maxHeight;
    NSInteger maxCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    {//用于解决不同版本的iOS对ScrollView的contentInset支持不统一的问题
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    maxHeight = -1;
    self.navigationItem.title = @"产品对比";
    
    titleArr = [[NSArray alloc] initWithObjects:@"图片",@"名字",@"功效",@"备案",@"危险",@"孕妇\n禁用",@"美白",@"抗老",@"成分", nil];
    datas = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kTableWidth, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH-kTableWidth, SCREEN_HEIGHT-(NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT))];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *ids = @"";
    for (NSDictionary *dict in [UIApplication appDelegate].compareDatas) {
        ids = [ids stringByAppendingString:[dict[@"id"] stringValue]];
        ids = [ids stringByAppendingString:@","];
        [datas addObject:[NSNull null]];
    }
    ids = [ids substringToIndex:ids.length-1];
    NSArray *tempIds = [ids componentsSeparatedByString:@","];
    [ALRequest requestPOSTAPI:@"productNew/getByIds" postData:@{@"ids": ids} success:^(id result) {
        NSArray *temp = result[@"obj"];
        if (temp&&temp.count>0) {
            for (NSDictionary *dict in temp) {
                NSString *idstr = [dict[@"id"] stringValue];
                NSMutableDictionary *tempDict = [dict mutableCopy];
                NSArray *elements = [dict[@"element"] componentsSeparatedByString:@","];
                if (elements.count<=0) {
                    [tempDict setObject:@[] forKey:@"elements"];
                } else {
                    [tempDict setObject:elements forKey:@"elements"];
                }
                [datas replaceObjectAtIndex:[tempIds indexOfObject:idstr] withObject:tempDict];
            }
            _scrollView.contentSize = CGSizeMake(kValueTableWidth*datas.count, 0);
            [self calcheightFromDatas];
            for (NSInteger i=1; i<=datas.count; i++) {
                UITableView *valueTableView = [[UITableView alloc] initWithFrame:CGRectMake(kValueTableWidth*(i-1), 0, kValueTableWidth, _scrollView.height) style:UITableViewStylePlain];
                valueTableView.delegate = self;
                valueTableView.dataSource = self;
                valueTableView.tag = i-1;
                valueTableView.showsVerticalScrollIndicator = NO;
                [valueTableView registerClass:[CompareProductTableViewCell class] forCellReuseIdentifier:cellIdentifier];
                valueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [_scrollView addSubview:valueTableView];
                UIView *line = [valueTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(0, 0, .5, maxHeight)];
                line.tag = -1;
                if (i==datas.count) {
                    UIView *line = [valueTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(kValueTableWidth-.5, 0, .5, maxHeight)];
                    line.tag = -1;
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
            UIView *line = [titleTableView addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(kTableWidth, 0, .5, maxHeight)];
            line.tag = -1;
            titleTableView.clipsToBounds = NO;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failed:^(id result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@", error);
    }];
}

- (void)calcheightFromDatas{
    maxCount = 0;
    for (NSDictionary *dict in datas) {
        NSArray *elements = dict[@"elements"];
        maxCount = MAX(maxCount, elements.count);
    }
    maxCount += 8;
    maxHeight = (maxCount-1)*kDefaultCellHeight+80;
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
    return maxCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) return 80;
    if (tableView.tag==100) {
        if (indexPath.row==8) {
            return kDefaultCellHeight*(maxCount-8);
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
        cell.bottomLine.hidden = indexPath.row!=(maxCount-1);
        NSDictionary *dict = datas[tableView.tag];
        if (indexPath.row==0) {
            if (cell.icon.image==nil) {
                cell.icon.bounds = CGRectMake(0, 0, height-30, height-30);
                cell.icon.center = CGPointMake(kValueTableWidth/2, height/2);
                cell.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cell.deleteBtn.frame = CGRectMake(height-20, 0, 40, 30);
                cell.deleteBtn.tempObj = tableView;
                [cell.deleteBtn setImage:[UIImage imageNamed:@"compare_deleteBtn"] forState:UIControlStateNormal];
                [cell.deleteBtn addTarget:self action:@selector(deleteTable:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cell.deleteBtn];
            }
            NSString *imgSrc = dict[@"img"];
            if (imgSrc.length>0) {
                [cell.icon sd_setImageWithURL:[NSURL URLWithString:imgSrc]];
            } else {
                cell.icon.image = [UIImage imageNamed:@"unknow"];
            }
            cell.icon.hidden = NO;
            cell.deleteBtn.hidden = NO;
            cell.label.hidden = YES;
        } else {
            cell.label.hidden = NO;
            cell.icon.hidden = YES;
            cell.deleteBtn.hidden = YES;
            switch (indexPath.row) {
                case 1://产品名称
                {
                    cell.label.frame = CGRectMake(10, 0, kValueTableWidth-20, height);
                    cell.label.text = dict[@"name"];
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                    
                    break;
                }
                case 2://功效
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = dict[@"effect"];
                    if (cell.label.text.length<=0) {
                        cell.label.text = @"暂无";
                    }
                    cell.label.textColor = COLOR_APP_GRAY;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 3://备案
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = dict[@"src"];
                    cell.label.textColor = COLOR_APP_PINK;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 4://危险
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    float safe = [dict[@"safeLevel"] floatValue];
                    if (safe<3) {
                        cell.label.textColor = APP_COLOR;
                    } else if (safe<5) {
                        cell.label.textColor = UIColorFromHex(0xFFA845);
                    } else {
                        cell.label.textColor = UIColorFromHex(0xFF4545);
                    }
                    cell.label.text = [NSString stringWithFormat:@"%.1f", safe];
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                    [cell.contentView addSubview:cell.label];
                }
                    break;
                case 5://孕妇禁用
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = [dict[@"yunfu"] stringValue];
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 6://美白
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = [dict[@"meibai"] stringValue];
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                case 7://抗老
                {
                    cell.label.frame = CGRectMake(0, 0, kValueTableWidth, height);
                    cell.label.text = [dict[@"kanglao"] stringValue];
                    cell.label.textColor = COLOR_APP_GREEN;
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:11];
                    cell.label.numberOfLines = 2;
                }
                    break;
                default:{
                    cell.label.frame = CGRectMake(10, 0, kValueTableWidth-20, kDefaultCellHeight);
                    NSArray *elements = dict[@"elements"];
                    NSInteger index = indexPath.row-8;
                    if (index<elements.count) {
                        cell.label.text = elements[index];
                    } else {
                        cell.label.text = @"";
                    }
                    cell.label.textColor = [UIColor blackColor];
                    cell.label.textAlignment = NSTextAlignmentCenter;
                    cell.label.font = [UIFont systemFontOfSize:10];
                    cell.label.adjustsFontSizeToFitWidth = YES;
                    cell.label.numberOfLines = 4;
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
    NSInteger index = [sender.tempObj tag];
    [[UIApplication appDelegate].compareDatas removeObjectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefrushCompareNum object:nil];
    if (datas.count<=1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [datas removeObjectAtIndex:index];
    for (UITableView *table in _scrollView.subviews) {
        if ([table isKindOfClass:[UITableView class]]) {
            if (table.tag==index) {
                [table removeFromSuperview];
            }
            if (table.tag>index) {
                table.tag --;
            }
            table.x = table.tag*kValueTableWidth;
            if (table.tag+1==datas.count) {
                UIView *line = [table addLine:COLOR_APP_LIGHTGRAY frame:CGRectMake(kValueTableWidth-.5, 0, .5, maxHeight)];
                line.tag = -1;
            }

        }
    }
    [self calcheightFromDatas];
    for (UITableView *table in _scrollView.subviews) {
        if ([table isKindOfClass:[UITableView class]]) {
            [table reloadData];
            for (UIView *temp in table.subviews) {
                if (temp.tag==-1) {
                    temp.height = maxHeight;
                }
            }
        }
    }
    UITableView *table = (UITableView*)[self.view viewWithTag:100];
    [table reloadData];
    for (UIView *temp in table.subviews) {
        if (temp.tag==-1) {
            temp.height = maxHeight;
        }
    }
}

#pragma mark -
#pragma mark - table 联动


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag!=100) {
        UITableView *table = (UITableView*)[self.view viewWithTag:100];
        [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
    }

    for (UITableView *table in _scrollView.subviews) {
        if ([table isKindOfClass:[UITableView class]]&&table!=scrollView) {
            [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:NO];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag!=100) {
        UITableView *table = (UITableView*)[self.view viewWithTag:100];
        [table setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    }
    for (UITableView *table in _scrollView.subviews) {
        if ([table isKindOfClass:[UITableView class]]&&table!=scrollView) {
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
