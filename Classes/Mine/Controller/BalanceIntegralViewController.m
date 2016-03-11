//
//  BalanceIntegralViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "BalanceIntegralViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "RDVTabBarController.h"
static NSString *const balanceIntergral = @"balanceInterGral";
@interface BalanceIntegralViewController ()
{
    UITableView *_tableView;
    NSDictionary*_memberInfo;
    NSArray     *_cardTitleArray;
    NSArray     *_cardInfo;
}
@end

@implementation BalanceIntegralViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:balanceIntergral object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"余额积分";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceRequestDataEnd:) name:balanceIntergral object:nil];
    _cardTitleArray = @[@"卡号", @"总额", @"余额", @"积分"];
    _memberInfo = kGetData(@"memberInfo");
    [self loadControl];
    [self balanceRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)balanceRequestData
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.payment.cardyue.getlyt&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&cardNo=%@", [_memberInfo objectForKey:@"cardNo"]];
    [NetWorking netWorkingWithUrl:urlStr identification:balanceIntergral];
}
- (void)balanceRequestDataEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != NULL && dic != nil) {
            _cardInfo = @[
        [dic objectForKey:@"cardNo"],
        [dic objectForKey:@"totalMoney"],
        [dic objectForKey:@"consumeMoney"],
        [dic objectForKey:@"totalJifen"]];
            [_tableView reloadData];
        }
    }
}
#pragma mark - 添加控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:CGRectMake(10, 80, kScreenBounds.size.width - 20, 240) target:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _cardTitleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //cell.textLabel.backgroundColor = [UIColor yellowColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _cardInfo[indexPath.row]];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
//    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
     cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.bounds.size.width - 60, cell.textLabel.bounds.size.height);
    return cell;
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

@end
