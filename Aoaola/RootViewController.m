//
//  RootViewController.m
//  Aoaola
//
//  Created by Peter on 15/12/21.
//  Copyright © 2015年 Scofield. All rights reserved.
//

#import "RootViewController.h"
#import "Utils.h"
#import "SearchHistoryView.h"
#import "ProductSearchTableView.h"
#import "ElementsSearchTableView.h"
#import "CompareProductViewController.h"
#import "ProductDiscoverViewController.h"

static float gap = 8;
@interface RootViewController () <UITextFieldDelegate, SearchHistoryDelegate, ProductDiscoverDelegate>

@end

@implementation RootViewController {
    UIImageView *searchIcon;
    UITextField *searchField;
    UIButton *cancelBtn;
    UIButton *compareBtn;
    UILabel *comparNumLabel;
    UIView *contentView;
    UIView *searchView;
    SearchHistoryView *history;
    UIView *segContnet;
    UISegmentedControl *segControl;
    CGSize keyboardSize;
    ProductDiscoverViewController *mainView;
    ProductSearchTableView *productSearchView;
    ElementsSearchTableView *elementSearchView;
    NSInteger currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {//用于解决不同版本的iOS对ScrollView的contentInset支持不统一的问题
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.navigationController.navigationBar.height)];
    searchView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = searchView;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, gap, searchView.width-gap*2, searchView.height-gap*2)];
    contentView.layer.cornerRadius = 4;
    contentView.backgroundColor = [UIColor whiteColor];
    [searchView addSubview:contentView];
    
    searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchIcon"]];
    searchIcon.center = CGPointMake(contentView.width/2-searchIcon.width, contentView.height/2);
    [contentView addSubview:searchIcon];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchIcon.frame)+5, 0, 50, contentView.height)];
    searchField.placeholder = @"搜索";
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.tintColor = APP_COLOR;
    searchField.font = [UIFont systemFontOfSize:searchIcon.height];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.textColor = APP_COLOR;
    searchField.delegate = self;
    [contentView addSubview:searchField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startSearch)];
    [contentView addGestureRecognizer:tap];
    
    mainView = [[ProductDiscoverViewController alloc] init];
    mainView.view.frame = CGRectMake(0, 64, self.view.width, SCREEN_HEIGHT-64);
    mainView.cateDelegate = self;
    [self addChildViewController:mainView];
    [self.view addSubview:mainView.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNum:) name:kRefrushCompareNum object:nil];
}

- (void)reloadNum:(NSNotification *)notifi{
    if (!compareBtn) {
        compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        compareBtn.frame = CGRectMake(SCREEN_WIDTH, contentView.y, 50, contentView.height);
        [compareBtn setTitle:@"对比" forState:UIControlStateNormal];
        compareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [compareBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        [compareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [compareBtn addTarget:self action:@selector(compare) forControlEvents:UIControlEventTouchUpInside];
        [searchView addSubview:compareBtn];
        
        comparNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(compareBtn.x+compareBtn.width-10, 5, 15, 15)];
        comparNumLabel.backgroundColor = UIColorFromHex(0xFF4545);
        comparNumLabel.layer.cornerRadius = comparNumLabel.width/2;
        comparNumLabel.clipsToBounds = YES;
        comparNumLabel.textAlignment = NSTextAlignmentCenter;
        comparNumLabel.font = [UIFont systemFontOfSize:11];
        comparNumLabel.text = @"1";
        comparNumLabel.textColor = [UIColor whiteColor];
        [searchView addSubview:comparNumLabel];

        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            searchIcon.x = 10;
            searchField.x = CGRectGetMaxX(searchIcon.frame)+10;
            contentView.width = SCREEN_WIDTH-gap*2-cancelBtn.width-compareBtn.width-10;
            searchField.width = contentView.width-searchField.x;
            cancelBtn.x = CGRectGetMaxX(contentView.frame)+10;
            compareBtn.x = CGRectGetMaxX(cancelBtn.frame);
            comparNumLabel.x = compareBtn.x+compareBtn.width-15;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    if ([UIApplication appDelegate].compareDatas.count<=0) {
        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            searchIcon.x = 10;
            searchField.x = CGRectGetMaxX(searchIcon.frame)+10;
            contentView.width = SCREEN_WIDTH-gap*2-cancelBtn.width-10;
            searchField.width = contentView.width-searchField.x;
            cancelBtn.x = CGRectGetMaxX(contentView.frame)+10;
            compareBtn.x = SCREEN_WIDTH;
            comparNumLabel.x = compareBtn.x+compareBtn.width-15;
        } completion:^(BOOL finished) {
            [compareBtn removeFromSuperview];
            compareBtn = nil;
            [comparNumLabel removeFromSuperview];
            comparNumLabel = nil;
        }];
    } else {
        comparNumLabel.text = @([UIApplication appDelegate].compareDatas.count).stringValue;
    }
}

- (void)compare{
    CompareProductViewController *compare = [[CompareProductViewController alloc] initWithNibName:@"CompareProductViewController" bundle:nil];
    [self.navigationController pushViewController:compare animated:YES];
}

- (void)startSearch{
    if (![searchField isFirstResponder]) {
        [searchField becomeFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}

- (void)keyboardWillHide:(NSNotification *)notifi{
    keyboardSize = CGSizeMake(0, 0);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!cancelBtn) {
        [self showCancelBtn];
    }
    [self openHistory];
}

- (void)showCancelBtn{
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH, contentView.y, 50, contentView.height);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelBtn];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        searchIcon.x = 10;
        searchField.x = CGRectGetMaxX(searchIcon.frame)+10;
        contentView.width = SCREEN_WIDTH-gap*2-cancelBtn.width-10;
        searchField.width = contentView.width-searchField.x;
        cancelBtn.x = CGRectGetMaxX(contentView.frame)+10;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addSeg{
    if (segContnet) {
        return;
    }
    segContnet = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.width, 44)];
    segContnet.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segContnet];
    segControl = [[UISegmentedControl alloc] initWithItems:@[@"产品", @"成分"]];
    segControl.tintColor = APP_COLOR;
    segControl.frame = CGRectMake(gap, gap, self.view.width-gap*2, segContnet.height-gap*2);
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(changeType) forControlEvents:UIControlEventValueChanged];
    [segContnet addSubview:segControl];
    segContnet.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        segContnet.alpha = 1;
    }];
}

- (void)changeType{
    if (searchField.text.length<=0) {
        if (segControl.selectedSegmentIndex==0) {
            NSArray *titleStrArr = @[@"洁面",@"乳液",@"面霜",@"精华",@"化妆水",@"面膜",@"防晒",@"卸妆",@""];
            searchField.placeholder = [NSString stringWithFormat:@"搜索%@", titleStrArr[currentIndex-1]];
        } else {
            searchField.placeholder = @"搜索成分";
        }
    }
    if ([searchField isFirstResponder]) {
        if (history) {
            history.type = segControl.selectedSegmentIndex;
        }
        return;
    }
    if (segControl.selectedSegmentIndex==0&&!productSearchView) {
        [self showProductList:-1];
        return;
    }
    if (segControl.selectedSegmentIndex==1&&!elementSearchView) {
        [self showElementList];
        return;
    }
    if (searchField.text.length>0) {
        if (segControl.selectedSegmentIndex==0) {
            [productSearchView search:searchField.text];
        } else {
            [elementSearchView search:searchField.text];
        }
    }
    [UIView animateWithDuration:.3 animations:^{
        elementSearchView.alpha = segControl.selectedSegmentIndex==1;
        productSearchView.alpha = segControl.selectedSegmentIndex==0;
    }];
}

- (void)openHistory{
    if (history) {
        return;
    }
    [self addSeg];
    history = [[SearchHistoryView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+44, self.view.width, self.view.height) type:segControl.selectedSegmentIndex];
    history.historyDelegate = self;
    history.height = self.view.height-history.y-keyboardSize.height;
    history.alpha = 0;
    [self.view insertSubview:history atIndex:1];
    [UIView animateWithDuration:.3 animations:^{
        history.alpha = 1;
    } completion:^(BOOL finished) {
        mainView.view.hidden = YES;
    }];
    if (productSearchView) {
        productSearchView.alpha = 0;
    }
    if (elementSearchView) {
        elementSearchView.alpha = 0;
    }
}

- (void)closeHistory{
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        history.alpha = 0;
    } completion:^(BOOL finished) {
        [history removeFromSuperview];
        history = nil;
    }];
}

- (void)cancelSearch{
    searchField.placeholder = @"搜索";
    mainView.view.hidden = NO;
    searchField.text = @"";
    [searchField resignFirstResponder];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (productSearchView) {
            productSearchView.alpha = 0;
        }
        if (elementSearchView) {
            elementSearchView.alpha = 0;
        }
        if (history) {
            history.alpha = 0;
        }
        segContnet.alpha = 0;
        contentView.width = SCREEN_WIDTH-gap*2;
        searchField.width = 50;
        searchIcon.center = CGPointMake(contentView.width/2-searchIcon.width, contentView.height/2);
        searchField.x = CGRectGetMaxX(searchIcon.frame)+10;
        cancelBtn.x = SCREEN_WIDTH;
        if (compareBtn) {
            compareBtn.x = SCREEN_WIDTH;
            comparNumLabel.x = CGRectGetMaxX(compareBtn.frame)-15;
        }
    } completion:^(BOOL finished) {
        if (elementSearchView) {
            [elementSearchView removeFromSuperview];
            elementSearchView = nil;
        }
        if (productSearchView) {
            [productSearchView removeFromSuperview];
            productSearchView = nil;
        }
        if (history) {
            [history removeFromSuperview];
            history = nil;
        }
        if (compareBtn) {
            [compareBtn removeFromSuperview];
            compareBtn = nil;
            [comparNumLabel removeFromSuperview];
            comparNumLabel = nil;
        }
        [segContnet removeFromSuperview];
        segContnet = nil;
        [cancelBtn removeFromSuperview];
        cancelBtn = nil;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length<=0) {
        [self cancelSearch];
        return YES;
    }
    [history addHistory:textField.text];
    [self closeHistory];
    [textField resignFirstResponder];
    if (segControl.selectedSegmentIndex==0) {
        [self showProductList:-1];
    } else {
        [self showElementList];
    }
    return YES;
}

- (void)didChoiceCate:(NSInteger)index{
    currentIndex = index;
    NSArray *titleStrArr = @[@"洁面",@"乳液",@"面霜",@"精华",@"化妆水",@"面膜",@"防晒",@"卸妆",@""];
    searchField.placeholder = [NSString stringWithFormat:@"搜索%@", titleStrArr[index-1]];
    [self showCancelBtn];
    [self addSeg];
    [self showProductList:index];
}

- (void)showProductList:(NSInteger)type{
    if (productSearchView) {
        [productSearchView search:searchField.text];
        if (productSearchView.alpha==0) {
            productSearchView.alpha = 1;
        }
        return;
    }
    productSearchView = [[ProductSearchTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+44, self.view.width, self.view.height-64-44)];
    productSearchView.alpha = 0;
    if (type!=-1) {
        productSearchView.cateType = type;
    }
    [self.view insertSubview:productSearchView atIndex:1];
    [productSearchView search:searchField.text];
    [UIView animateWithDuration:.3 animations:^{
        productSearchView.alpha = 1;
        if (elementSearchView) {
            elementSearchView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        mainView.view.hidden = YES;
    }];
}

- (void)showElementList{
    if (elementSearchView) {
        [elementSearchView search:searchField.text];
        if (elementSearchView.alpha==0) {
            elementSearchView.alpha = 1;
        }
        return;
    }
    elementSearchView = [[ElementsSearchTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+44, self.view.width, self.view.height-64-44)];
    elementSearchView.alpha = 0;
    [self.view insertSubview:elementSearchView atIndex:1];
    [elementSearchView search:searchField.text];
    [UIView animateWithDuration:.3 animations:^{
        productSearchView.alpha = 0;
        elementSearchView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didChoiceHistory:(NSString *)word{
    searchField.text = word;
    if ([searchField isFirstResponder]) {
        [self closeHistory];
        [searchField resignFirstResponder];
    }
    [UIView animateWithDuration:.3 animations:^{
        if (segControl.selectedSegmentIndex==0) {
            [self showProductList:-1];
        }
        if (segControl.selectedSegmentIndex==1) {
            [self showElementList];
        }
        elementSearchView.alpha = segControl.selectedSegmentIndex==1;
        productSearchView.alpha = segControl.selectedSegmentIndex==0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
