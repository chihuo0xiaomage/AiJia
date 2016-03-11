//
//  SearchShopViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-27.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "SearchShopViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "ListViewController.h"
#import "QueryGoodsViewController.h"
@interface SearchShopViewController ()
{
    UITextField *_searchTextField;
    BOOL         _isFirst;
}
@end

@implementation SearchShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"上一页";
    [self setNavigationBarSearchBar];
    _searchTextField = (UITextField *)self.navigationItem.titleView;
    [_searchTextField becomeFirstResponder];
        //self.navigationItem.rightBarButtonItem = nil;
        // self.navigationItem.leftBarButtonItem.image= nil;
//    [self.navigationItem.rightBarButtonItem setTitle:@"搜索"];
//    [self.navigationItem.rightBarButtonItem setAction:@selector(selectShopInformationData)];
//[self.navigationItem.rightBarButtonItem setTarget:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(selectShopInformationData)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    _isFirst = YES;
//}
- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 开始模糊查询
- (void)selectShopInformationData
{
    if (_isFirst && ![_searchTextField.text isEqualToString:@""]) {
        _isFirst = NO;
        [_searchTextField resignFirstResponder];
        NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.goods.get.bystring&v=1.0&format=json&locale=zh_CN&client=iPhone&nameStr=%@", [_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        QueryGoodsViewController *listViewController = [[QueryGoodsViewController alloc] init];
        listViewController.strUrl = urlStr;
        listViewController.title = _searchTextField.text;
            //NSLog(@"urlStr = %@", urlStr);
        [self.navigationController pushViewController:listViewController animated:YES];

    }
}
#pragma mark - 设置搜索框
- (void)setNavigationBarSearchBar{
    [SharedHandle setNagetionBar:self imageName:nil action:@selector(selectShopInformationData)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    _isFirst = YES;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self selectShopInformationData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchTextField resignFirstResponder];
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
