//
//  ProductAboutViewController.m
//  Aoaola
//
//  Created by Peter on 16/1/5.
//  Copyright © 2016年 Scofield. All rights reserved.
//

#import "ProductAboutViewController.h"
#import "AdditionsMacro.h"
#import "SearchInfoViewCell.h"
#import "ProductAboutCell.h"
#import "ProductDetailViewController.h"
#import "CompareProductViewController.h"

@interface ProductAboutViewController ()

@end

@implementation ProductAboutViewController{
    UIView *compareNumView;
    UILabel *comparNumLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品相关";
    self.view.backgroundColor = UIColorFromHex(0xF7F7F7);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) return 191;
    return 164;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        static NSString *cellId = @"ProductAboutCell";
        ProductAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            UINib *nib=[UINib nibWithNibName:cellId bundle:nil ];
            [tableView registerNib:nib forCellReuseIdentifier:cellId];
            cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        }
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=0) {
        ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
