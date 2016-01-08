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

#define kTableWidth 40

@interface CompareProductViewController () <UITableViewDelegate,
                                            UITableViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegateFlowLayout>

{
    NSArray *titleArr;
}

@property (nonatomic, strong) UITableView *titleTableView;
@property (nonatomic, strong) UICollectionView *valueCollectionView;
@end

@implementation CompareProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"产品对比";
    
    titleArr = [[NSArray alloc] initWithObjects:@"图片",@"名字",@"功效",@"备案",@"危险",@"孕妇\n禁用",@"美白",@"抗老",@"成分", nil];
    
    _titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, kTableWidth, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT) style:UITableViewStylePlain];
    _titleTableView.delegate = self;
    _titleTableView.dataSource = self;
    _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_titleTableView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _valueCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTableWidth, NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT, SCREEN_HEIGHT-kTableWidth, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT+STATUSBARHEIGHT) collectionViewLayout:flowLayout];
    _valueCollectionView.dataSource=self;
    _valueCollectionView.delegate=self;
    [_valueCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    //注册Cell，必须要有
    [_valueCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self.view addSubview:_valueCollectionView];
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
    if (indexPath.row==0) return 100;
    if (indexPath.row==8) return 132;
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = COLOR_APP_LIGHTGRAY;
    
    CGFloat height = 44;
    if (indexPath.row==0) {
        height = 100;
    }
    if (indexPath.row==8) {
        height = 132;
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTableWidth, height)];
    title.text = titleArr[indexPath.row];
    title.textColor = COLOR_APP_GRAY;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:11];
    title.numberOfLines = 2;
    [cell.contentView addSubview:title];
    
    
    [Utils addLine:CGRectMake(0, height-0.5, kTableWidth, 0.5) superView:cell.contentView withColor:COLOR_APP_WHITE];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 145;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = COLOR(arc4random()%255, arc4random()%255, arc4random()%255, 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(44, 44);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
