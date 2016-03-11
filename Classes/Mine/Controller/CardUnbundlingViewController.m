//
//  CardUnbundlingViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CardUnbundlingViewController.h"
#import "RDVTabBarController.h"
#import "CardUnbundScrollView.h"
#import "MineViewController.h"
@interface CardUnbundlingViewController ()

@end

@implementation CardUnbundlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡解绑";
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [self loadControl];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 加载控件
- (void)loadControl
{
    CardUnbundScrollView * cardUnbundScrollView = [[CardUnbundScrollView alloc] initWithFrame:self.view.frame target:self];
    [self.view addSubview:cardUnbundScrollView];
}
- (void)updateData
{
    MineViewController *mineViewControler = [self.navigationController.viewControllers firstObject];
    [mineViewControler mineGetMemberInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
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
