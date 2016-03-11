//
//  ClearViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-8.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ClearViewController.h"
#import "RDVTabBarController.h"
#import "HeaderView.h"
#import "SharedHandle.h"
#import "ClearTableViewCell.h"
#import "NetWorking.h"
#import "ClearModel.h"
#import "AddressViewController.h"
static NSString *const getDefaultAddress = @"getDefaultAddress";
static NSString *const paymentMethod = @"paymentMethod";
static NSString *const shippingMethod = @"shippingMethod";
static NSString *const sinceInfonmation = @"sinceInfonmation";
@interface ClearViewController ()
{
    UITableView *_tableView;
    HeaderView  *_headerView;
    UILabel     *_sumPriceLabel;
    NSArray     *_addressArray;
    NSArray     *_paymentDic;
    NSArray     *_shippingDic;
    NSArray     *_sinceInformationDic;
    ClearModel  *_clearModel;
    NSMutableDictionary *_orderDataDic;
    NSMutableData *_data;
    UIAlertView *_isAddressAlertView;
    UIAlertView *_selectPayAlertView;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *_payMenthod;
}
@end

@implementation ClearViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:paymentMethod object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:shippingMethod object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sinceInfonmation object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"填写订单";
    self.selfgetTime = @"";
    _orderDataDic = [NSMutableDictionary dictionary];
    self.selfgetAreaName = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPaymentMethodEnd:) name:paymentMethod object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShippingMethodEnd:) name:shippingMethod object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSinceSomeInformationEnd:) name:sinceInfonmation object:nil];
    [[SharedHandle sharedHandle] setDelegate:(id<SharedHandleDelegate>)self];
    [self loadControl];
    [self getTheDefaultShippingAddress];
    [self getPaymentMethod];
    [self getShippingMethod];
    [self getSinceSomeInformation];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - Network request
/**
 *获取支付方法
 **/
- (void)getPaymentMethod
{
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.order.paymentMethod.get&v=1.0&format=json&locale=zh_CN&client=iPhone"];
    [NetWorking netWorkingWithUrl:strUrl identification:paymentMethod];
}
- (void)getPaymentMethodEnd:(id)sender
{
    
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        _paymentDic = [[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil] objectForKey:@"paymentMethodList"];
        [self clearModel];
    }
}
/**
 *获取配送方法
 **/
- (void)getShippingMethod
{
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.order.deliveryMethod.get&v=1.0&format=json&locale=zh_CN&client=iPhone"];
    [NetWorking netWorkingWithUrl:strUrl identification:shippingMethod];
}
- (void)getShippingMethodEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        _shippingDic = [[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil] objectForKey:@"deliveryMethodList"];
        [self clearModel];
    }
    
}
/**
 *获取自提点信息
 **/
- (void)getSinceSomeInformation
{
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.selfgetarea.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone"];
    [NetWorking netWorkingWithUrl:strUrl identification:sinceInfonmation];
}
- (void)getSinceSomeInformationEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        _sinceInformationDic = [[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil] objectForKey:@"selfgetList"];
        [self clearModel];
    }
}
/**
 *新数据的封装
 **/
- (void)clearModel
{
    //NSLog(@"%@ == %@ == %@", _sinceInformationDic, _shippingDic, _payMenthod);
    //if (_sinceInformationDic && _shippingDic && _paymentDic) {
        NSInteger index = 0;
        for (NSDictionary *dic in _shippingDic) {
            index ++;
            [_orderDataDic setObject:[dic objectForKey:@"deliveryMethodName"] forKey:[NSString stringWithFormat: @"deliveryMethodName%ld", (long)index]];
            [_orderDataDic setObject:[dic objectForKey:@"deliveryMethodId"] forKey:[NSString stringWithFormat:@"deliveryMethodId%ld", (long)index]];
        }
        index = 0;
        for (NSDictionary *dic in _paymentDic) {
            index ++;
            [_orderDataDic setObject:[dic objectForKey:@"payType"] forKey:[NSString stringWithFormat:@"payType%ld", (long)index]];
            [_orderDataDic setObject:[dic objectForKey:@"paymentMethodID"] forKey:[NSString stringWithFormat:@"paymentMethodID%ld", (long)index]];
            [_orderDataDic setObject:[dic objectForKey:@"paymentMethodName"] forKey:[NSString stringWithFormat:@"paymentMethodName%ld", (long)index]];
        }
//        index = 0;
//        for (NSDictionary *dic in _sinceInformationDic) {
//            index ++;
//            [_orderDataDic setObject:[dic objectForKey:@"adress"] forKey:[NSString stringWithFormat:@"adress%ld", (long)index]];
//            [_orderDataDic setObject:[dic objectForKey:@"name"] forKey:[NSString stringWithFormat:@"name%ld", (long)index]];
//            [_orderDataDic setObject:[dic objectForKey:@"selfgetAreaId"] forKey:[NSString stringWithFormat:@"selfgetAreaId%ld", (long)index]];
//        }
   // }
}
//获取收货地址
- (void)getTheDefaultShippingAddress
{
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheDefaultShippingAddressEnd:) name:getDefaultAddress object:nil];
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.receiver.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:strUrl identification:getDefaultAddress];
}
- (void)getTheDefaultShippingAddressEnd:(id)sender
{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView setHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getDefaultAddress object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _addressArray = [dic objectForKey:@"receivers"];
            if (_addressArray.count == 0) {
                _headerView.addressView.hidden = NO;
            }else{
                _headerView.addressDic = _addressArray[0];
                //                NSLog(@"_headerView.addressDic = %@", _headerView.addressDic);
            }
        }
    }
}
#pragma mark - The load control
- (void)loadControl
{
    _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 64, kScreenBounds.size.width, 120) target:self];
    [self.view addSubview:_headerView];
    
    _tableView = [SharedHandle sharedWithTableViewFrame:CGRectMake(0, kSetFrameY(_headerView), kScreenBounds.size.width, kScreenBounds.size.height - _headerView.bounds.size.height - 64 - 49) target:self];
    _tableView.tableHeaderView = [self headerView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [self footerView:CGRectMake(_tableView.frame.origin.x, kSetFrameY(_tableView), kScreenBounds.size.width, 49)];
    [self.view addSubview:footerView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = self.view.center;
    _activityIndicatorView.hidden = YES;
    [self.view addSubview:_activityIndicatorView];
}
- (UIView *)headerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 20)];
    view.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
    label.text = @"订单详情:";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor orangeColor];
    [view addSubview:label];
    return view;
}
- (UIView *)footerView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    //view.backgroundColor = [UIColor yellowColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianxiedingdan.png"]];
    imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, 49);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 65, 29)];
    //label.backgroundColor = [UIColor redColor];
    label.text = @"应付金额:";
    label.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:label];
    
    _sumPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(label) + 5, label.frame.origin.y, 120, 29)];
    _sumPriceLabel.text = @"00.00";
    _sumPriceLabel.textColor = [UIColor redColor];
    _sumPriceLabel.text = _sumPrice;
    //_sumPriceLabel.backgroundColor = [UIColor redColor];
    [view addSubview:_sumPriceLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kSetFrameX(_sumPriceLabel) + 10, 8, 100, 33);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitOrders) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_isAddressAlertView == alertView) {
        if (buttonIndex == 1) {
            [self newAddress];
        }
    }else if (_selectPayAlertView == alertView){
        [SharedHandle choiceOfPayment:buttonIndex target:self];
    }
}
- (void)newAddress
{
    AddressViewController *addressViewController = [[AddressViewController alloc] init];
    addressViewController.title = @"新建地址";
    [self.navigationController pushViewController:addressViewController animated:YES];
}
#pragma mark - 提交订单
/**
 *进行订单的提交
 **/
- (void)submitOrders
{
    if (_addressArray.count == 0) {
        _isAddressAlertView = [[UIAlertView alloc] initWithTitle:@"添加收货地址" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [_isAddressAlertView show];
        return;
    }
    //NSLog(@"提交订单");
    /**
     提交订单需要很多的参数
     所有参数根据后台文档进行整体的封装
     参数名字按照后台的文档为准
     在不同的选择支付方式下 有些参数需要回传空值
     **/
    NSMutableArray *orderItemArray = [NSMutableArray array];
    //商品总价格
    NSString *shopSumPrice = [_sumPrice substringFromIndex:1];
    //商品总数量
    NSString *shopSumNumber = _sumNumber;
    //    NSLog(@"%@", shopSumPrice);
    //    NSLog(@"%@", shopSumNumber);
    //    NSLog(@"%@", _shopArray);
    for (NSDictionary *dic in _shopArray) {
        [orderItemArray addObject:@{@"quantity":[dic objectForKey:@"quantity"], @"goodsId":[dic objectForKey:@"gid"]}];
    }
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:orderItemArray options:0 error:nil];
    NSString *orderItemArrayJson = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSArray *array = [_headerView.selectPayLabel.text componentsSeparatedByString:@"  "];
    _payMenthod = [array firstObject];
    NSString *deliveryMenthod = [array lastObject];
    NSString *paymentMethodID;
    NSString *paymentMethodName;
    NSString *payType;
    /**
     *对提交订单需要的参数进行处理
     **/
    //支付方式参数
    if ([_payMenthod isEqualToString:@"在线支付"]) {
        paymentMethodID = [_orderDataDic objectForKey:@"paymentMethodID1"];
        paymentMethodName = [_orderDataDic objectForKey:@"paymentMethodName1"];
        payType = [_orderDataDic objectForKey:@"payType1"];
    }else if ([_payMenthod isEqualToString:@"货到付款"]){
        paymentMethodID = [_orderDataDic objectForKey:@"paymentMethodID2"];
        paymentMethodName = [_orderDataDic objectForKey:@"paymentMethodName2"];
        payType = [_orderDataDic objectForKey:@"payType2"];
    }
    NSString *deliveryMethodId;
    NSString * deliveryMethodName;
    /**
     *配送参数
     **/
    /**
     *自提信息
     **/
    //NSString *selfgetAreaName= @"";
    NSString *selfgetTime = _selfgetTime;
    NSString *selfgetAreaId = @"";
    if ([deliveryMenthod isEqualToString:@"卖家配送"]) {
        deliveryMethodId = [_orderDataDic objectForKey:@"deliveryMethodId3"];
        deliveryMethodName = [_orderDataDic objectForKey:@"deliveryMethodName3"];
    }else if ([deliveryMenthod isEqualToString:@"上门自提"]){
        deliveryMethodId = [_orderDataDic objectForKey:@"deliveryMethodId1"];
        deliveryMethodName = [_orderDataDic objectForKey:@"deliveryMethodName1"];
        //selfgetAreaName = [_orderDataDic objectForKey:@"name1"];
        selfgetAreaId = [_orderDataDic objectForKey:@"selfgetAreaId1"];
        //NSLog(@"_orderDataDic === %@", _orderDataDic);
    }
    /**
     *收货人信息
     **/
    NSString *shipName;
    NSString *shipAreaId;
    NSString *shipAreaPath;
    NSString *shipAddress;
    NSString *shopZipCode;
    NSString *shipMobile;
    for (NSDictionary *dic in _addressArray) {
        shipName = [dic objectForKey:@"name"];
        shipAreaId = [dic objectForKey:@"areaId"];
        shipAreaPath = [dic objectForKey:@"areaPath"];
        shipAddress = [dic objectForKey:@"address"];
        shopZipCode = [dic objectForKey:@"zipCode"];
        shipMobile = [dic objectForKey:@"mobile"];
    }
    NSDictionary *orderDic = @{@"memberId":kGetData(@"memberId"), @"goodsTotalQuantity":shopSumNumber, @"goodsTotalPrice":shopSumPrice, @"deliveryFee":@"0.0", @"totalAmount":shopSumPrice, @"paymentMethodId":paymentMethodID, @"paymentMethodName":paymentMethodName, @"payType":@"online", @"deliveryMethodId":@"295281734390517760", @"deliveryMethodName":@"卖家配送", @"shipName":shipName, @"shipAreaId":@"", @"shipAreaPath":@"", @"shipAddress":shipAddress, @"shopZipCode":shopZipCode, @"shipMobile":shipMobile, @"selfgetAreaName":@"", @"selfgetTime":@"", @"selfgetAreaId":@""};
    NSData *data = [NSJSONSerialization dataWithJSONObject:orderDic options:0 error:nil];
    NSString *orderDicJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@%@", orderItemArrayJson,orderDicJson);
    /**
     *获取服务器系统时间
     **/
    NSString * systemUrlStr = @"http://www.ajtzx.com/mall//systemdate.jsp?r='+Math.random()";
    NSURL * url = [NSURL URLWithString:systemUrlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        }
        if (response && [(NSHTTPURLResponse *)response statusCode] == 200) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString * _systemTime = [[NSString alloc] initWithData:data encoding:enc];
            _systemTime = [_systemTime substringFromIndex:2];
            if (![_systemTime isEqualToString:@""] && _systemTime != nil) {
                /**
                 *开始网络请求
                 **/
                [self submitOrderToServe:orderDicJson info:orderItemArrayJson systemTime:_systemTime];
            }
        }
    }];
}
- (void)submitOrderToServe:(NSString *)order info:(NSString *)orderItemArray systemTime:(NSString *)systemTime
{
    
    NSString * keyValues = [NSString stringWithFormat:@"appKey=00001&method=wop.product.order.add&v=1.0&format=json&locale=zh_CN&timestamp=%@&client=iPhone",systemTime];
    //NSLog(@"%@", keyValues);
    NSString *sign = [NetWorking submitGenerate:keyValues];
    NSString * body = [[NSString stringWithFormat:@"%@&order=%@&orderItemArray=%@&sign=%@", keyValues, order, orderItemArray, sign] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:HTTP];
   // NSLog(@"完整的url:%@?%@", HTTP, [NSString stringWithFormat:@"%@&order=%@&orderItemArray=%@&sign=%@", keyValues, order, orderItemArray, sign]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma mark - UIConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [NSMutableData dataWithCapacity:1];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   // NSLog(@"======%@", [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil]);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
    if (resultCode == 56) {
         [[[UIAlertView alloc] initWithTitle:@"对不起,库存不足,请选其他商品" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
   else if (resultCode == 0) {
        
        if ([_payMenthod isEqualToString:@"货到付款"]) {
            [[[UIAlertView alloc] initWithTitle:@"订单已经提交,请您等待收货" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else {
            SharedHandle *shareHandle = [SharedHandle sharedHandle];
            //NSLog(@"++++++++++++%@", shareHandle.payDataDic);
            NSDictionary *memberInfo = kGetData(@"memberInfo");
            //NSLog(@"%@", memberInfo);
            NSDictionary *payDic = @{@"cardNo":[memberInfo objectForKey:@"cardNo"], @"ecardNo":[memberInfo objectForKey:@"ecard"], @"order":[dic objectForKey:@"orderSn"]};
            //        [shareHandle.payDataDic setValue:[memberInfo objectForKey:@"cardNo"] forKey:@"cardNo"];
            //        [shareHandle.payDataDic setValue:[memberInfo objectForKey:@"ecard"] forKey:@"ecardNo"];
            //        [shareHandle.payDataDic setValue:[dic objectForKey:@"orderSn"] forKey:@"order"];
            shareHandle.payDataDic = [NSMutableDictionary dictionaryWithDictionary:payDic];
            [self submitOrdersEnd:shareHandle.payDataDic];
        }
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"-----------%@", error);
}
- (void)submitOrdersEnd:(id)sender
{
    //NSLog(@"%@", sender);
    _selectPayAlertView = [[UIAlertView alloc] initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"会员卡", @"银联卡",nil];
    [_selectPayAlertView show];
    //    [_shopArray removeAllObjects];
    //    [_tableView reloadData];
    // NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    
}
#pragma mark - SharedHandleDelegate
- (void)updateMyOrder
{
    //NSLog(@"刷新界面");
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    ClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[ClearTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.shopDic = _shopArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
