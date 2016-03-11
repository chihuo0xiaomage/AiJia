//
//  SeckillViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "SeckillViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
static NSString *seckillData = @"seckillData";
@interface SeckillViewController ()
{
    UITableView *_tableView;
    NSArray     *_seckillArray;
}
@end

@implementation SeckillViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:seckillData object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限时抢购";
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSeckillShopRequestEnd:) name:seckillData object:nil];
    [self loadControl];
    [self getSeckillShopRequest];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark -
- (void)getSeckillShopRequest
{
    NSString *urlStr =  @"appKey=00001&method=wop.goods.byFlashSale.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone";
    [NetWorking netWorkingWithUrl:urlStr identification:seckillData];
}
- (void)getSeckillShopRequestEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"秒杀未开始,请您等待" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加载控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
