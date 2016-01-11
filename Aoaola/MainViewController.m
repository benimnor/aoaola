//
//  MainViewController.m
//  Aoaola
//
//  Created by Peter on 15/12/21.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "MainViewController.h"
#import "AdditionsMacro.h"
#import "AAButton.h"

#define kImageWidth   SCREEN_WIDTH/3
#define kImageHeight  SCREEN_WIDTH/3
@interface MainViewController ()
{
    NSArray *titleStrArr;
}

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    titleStrArr = [[NSArray alloc] initWithObjects:@"洁面",@"乳液",@"面霜",@"精华",@"化妆水",@"面膜",@"防晒",@"卸妆",@"全部", nil];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainTableView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.view addSubview:_mainTableView];
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor = [UIColor clearColor];
    _mainTableView.delegate = self;
    
    float size = ceil(SCREEN_WIDTH/3);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, size*3)];
    for (NSInteger i=0; i<9; i++) {
        AAButton *btn = [AAButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mainproduct_%ld",i+1]];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:titleStrArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleEdgeInsets = UIEdgeInsetsMake(size*.8, -image.size.width, 10, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, (size-image.size.width)/2, 20, 0);
        btn.frame = CGRectMake(i%3*size, i/3*size, size, size);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(choiceCate:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(size, 0, .5, headerView.height)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(size*2, 0, .5, headerView.height)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size, headerView.width, .5)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size*2, headerView.width, .5)];
    [headerView addLine:COLOR_APP_WHITE frame:CGRectMake(0, size*3, headerView.width, .5)];

    _mainTableView.tableHeaderView = headerView;
}

- (void)choiceCate:(AAButton *)btn{
    if (_delegate) {
        [_delegate didChoiceCate:btn.tag];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageWidth;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //九宫格效果
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kImageWidth*2-20)];
            image.center = CGPointMake(SCREEN_WIDTH/2, kImageWidth);
            image.image = [UIImage imageNamed:@"maintablepic1"];
            [cell addSubview:image];
    }
    return cell;
}

-(void)imageItemClick:(UIButton *)button{
    NSString *msg = [NSString stringWithFormat:@"%@",titleStrArr[button.tag-100]];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<3) {
        return;
    }
}

@end
