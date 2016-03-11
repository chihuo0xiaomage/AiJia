//
//  BingCardViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-26.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "BingCardViewController.h"
#import "RDVTabBarController.h"
#import "AddCardViewController.h"
@interface BingCardViewController ()
{
    UILabel *_cardNoLabel;
    NSDictionary *_memberInfo;
}
@end

@implementation BingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    self.title = @"我的卡包";
    _memberInfo = kGetData(@"memberInfo");
    [self loadCotntrol];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, kScreenBounds.size.height - 69, kScreenBounds.size.width - 20, 35);
    [button setBackgroundColor:[UIColor redColor]];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [button setTitle:@"添加绑定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addCardNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - Load control
- (void)loadCotntrol
{
    if (![[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
        _cardNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenBounds.size.width - 20, 40)];
        _cardNoLabel.backgroundColor = [UIColor whiteColor];
        _cardNoLabel.text = [NSString stringWithFormat:@"卡号:%@", [_memberInfo objectForKey:@"cardNo"]];
        [self.view addSubview:_cardNoLabel];
    }
}
- (void)addCardNow
{
    [self.navigationController pushViewController:[[AddCardViewController alloc] init] animated:YES];
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
