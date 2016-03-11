//
//  MyOrderViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MyOrderViewController.h"
#import "SharedHandle.h"
#import "RDVTabBarController.h"
#import "NetWorking.h"
#import "MyOrderData.h"
#import "MyOrderTableViewCell.h"
static NSString *const myOrder = @"myOrder";
static NSString *const cancelMyOrder = @"cancelMyOrder";
@interface MyOrderViewController ()
{
    UITableView    *_tableView;
    NSMutableArray *_myOrderArray;
    NSDictionary   *_memberInfo;
}
@end

@implementation MyOrderViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:myOrder object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cancelMyOrder object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrderRequestDataEnd:) name:myOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderEnd:) name:cancelMyOrder object:nil];
    _memberInfo = kGetData(@"memberInfo");
    _myOrderArray = [NSMutableArray array];
    [self loadControl];
    [self myOrderRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 开始网络请求
- (void)myOrderRequestData
{
     NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.order.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&pageSize=10&pageNumber=1&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:urlStr identification:myOrder];
}
- (void)myOrderRequestDataEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
            //NSLog(@"%@", dic);
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [_myOrderArray removeAllObjects];
            for (NSDictionary *orderDic in [dic objectForKey:@"order"]) {
                NSMutableArray * modelArray = [NSMutableArray array];
                MyOrderData *myOrder = [[MyOrderData alloc] initWithOrderNumber:orderDic];
                [modelArray addObject:myOrder];
//-----此处 goods ---->goodes这个没有图片 ----->ordergoods这个是正确的
                for (NSDictionary *goods in [orderDic objectForKey:@"ordergoods"]) {
                        //NSLog(@"%@", goods);
                    MyOrderData *myGoods = [[MyOrderData alloc] initWithMyGoods:goods];
                    [modelArray addObject:myGoods];
                }
                [_myOrderArray addObject:modelArray];
            }
            [_tableView reloadData];
        }
            //NSLog(@"%@", _myOrderArray);
    }
}
#pragma mark - 加载控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset: UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins: UIEdgeInsetsZero];
//    }
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    NSLog(@"-------");
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 30)];
//    view.backgroundColor = [UIColor yellowColor];
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    return 30.0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == [_myOrderArray[indexPath.section] count]) {
        return 60;
    }
    return 80;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myOrderArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *orderStatus = ((MyOrderData *)_myOrderArray[section][0]).orderStatus;
        //NSLog(@"%@", orderStatus);
    
    if (![orderStatus isEqualToString:@"wait_buyer_pay"]) {
        return [_myOrderArray[section] count];
    }
    return [_myOrderArray[section] count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [self createOrderNumber:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.row < [_myOrderArray[indexPath.section] count]){
        return [self createGoods:tableView cellForRowAtIndexPath:indexPath];
    }else{
        static NSString *CellIdentfier = @"cell";
        MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (!cell) {
            cell = [[MyOrderTableViewCell alloc] initWithStylePay:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
            cell.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.payButton addTarget:self action:@selector(selectPaymentMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelOrderButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)selectPaymentMethod:(UIButton *)btn
{
    MyOrderTableViewCell *cell = (MyOrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    MyOrderData *myOrderData = _myOrderArray[indexPath.section][0];
//    NSLog(@"%@==", myOrderData.orderNumber);
//    NSLog(@"%@", _memberInfo);
    SharedHandle *sharedHandle = [SharedHandle sharedHandle];
    [sharedHandle setDelegate:(id<SharedHandleDelegate>)self];
    NSDictionary *payDic = @{@"order":myOrderData.orderNumber, @"cardNo":[_memberInfo objectForKey:@"cardNo"], @"ecardNo":[_memberInfo objectForKey:@"ecard"]};
    sharedHandle.payDataDic = [NSMutableDictionary dictionaryWithDictionary:payDic];
   // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"天中行卡", @"银联卡", @"电子卡(红包)", nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"会员卡", @"银联卡", nil];
    [alertView show];
}
#pragma mark - SharedHandleDelegate
- (void)updateMyOrder
{
    [self myOrderRequestData];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [SharedHandle choiceOfPayment:buttonIndex target:self];
}
- (void)cancelOrder:(UIButton *)btn
{
        //NSLog(@"取消订单");
    MyOrderTableViewCell *myOrderTableViewCell = (MyOrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:myOrderTableViewCell];
    NSString *orderNumber = ((MyOrderData *)_myOrderArray[indexPath.section][0]).orderNumber;
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.order.cancel&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&orderSn=%@", orderNumber];
    [NetWorking netWorkingWithUrl:urlStr identification:cancelMyOrder];
}
- (void)cancelOrderEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [self myOrderRequestData];
        }
    }
}
- (UITableViewCell *)createOrderNumber:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myOrderCellIdentfier = @"orderCell";
    MyOrderTableViewCell *myOrderCell = [tableView dequeueReusableCellWithIdentifier:myOrderCellIdentfier];
    if (!myOrderCell) {
        myOrderCell = [[MyOrderTableViewCell alloc] initWithStyleOrder:UITableViewCellStyleDefault reuseIdentifier:myOrderCellIdentfier];
        myOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    myOrderCell.myOrderData = _myOrderArray[indexPath.section][0];
    return myOrderCell;
}
- (UITableViewCell *)createGoods:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodCellIdentfier = @"goodCell";
    MyOrderTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:goodCellIdentfier];
    if (!goodCell) {
        goodCell = [[MyOrderTableViewCell alloc] initWithStyleGoods:UITableViewCellStyleDefault reuseIdentifier:goodCellIdentfier];
        goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    goodCell.shopOrderData = _myOrderArray[indexPath.section][indexPath.row];
    return goodCell;
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
