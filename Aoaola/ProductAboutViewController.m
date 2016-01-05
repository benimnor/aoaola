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
#import "BBBadgeBarButtonItem.h"
#import "ProductDetailViewController.h"

@interface ProductAboutViewController ()

@property (strong, nonatomic) BBBadgeBarButtonItem *compareBtn;
@end

@implementation ProductAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品相关";
    
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
        _compareBtn.badgeValue = [NSString stringWithFormat:@"%d",LOAD_INTEGER(@"compareCount")];
    }
    
    [self refrushCompareNum];
}

- (void)showCompareView{

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

- (void)refrushCompareNum{
    //    NSDictionary *dict = LOAD_VALUE(@"compareDict");
    NSInteger count = LOAD_INTEGER(@"compareCount");
    if (count<=0) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = _compareBtn;        
        _compareBtn.badgeValue = [NSString stringWithFormat:@"%d",count];
    }
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
