    //
    //  AddressViewController.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-11.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //

#import "AddressViewController.h"
#import "AddressScrollView.h"
#import "NetWorking.h"
#import "SharedHandle.h"
NSString *const deleteAddress = @"deleteAddress";
@interface AddressViewController ()
{
    AddressScrollView *_addressView;
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnBackLastpage)];
    [self loadControl];
}
- (void)returnBackLastpage
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Show data
#pragma mark - Network request
- (void)deleteShipingAddress:(UIButton *)button
{
        //NSLog(@"删除地址");
        //因为时间比较紧, 需要进行修改
    if (_addressId.count == 0) {
        [self newAddressController];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShipingAddressEnd:) name:deleteAddress object:nil];
        for (NSString *addressId in _addressId) {
            NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.receiver.del&v=1.0&format=json&locale=zh_CN&client=iPhone&receiverId=%@", addressId];
            [NetWorking netWorkingWithUrl:strUrl identification:deleteAddress];
       }
    }
}
- (void)deleteShipingAddressEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deleteAddress object:nil];
    [self newAddressController];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
        //先删除所有的购物地址, 再进行新建地址
    
}
    // To create a new address
- (void)newAddressController
{
    [_addressView theChangeOfAddress:self.title];
}
#pragma mark - The load control
- (void)loadControl
{
    _addressView = [[AddressScrollView alloc] initWithFrame:self.view.frame target:self];
    _addressView.addressDic = _addressDic;
    UIButton *button = [[_addressView subviews] lastObject];
    [button addTarget:self action:@selector(deleteShipingAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addressView];
    UIView *view = [self viewWithFrame:self.view.frame];
    view.hidden = YES;
    [self.view addSubview:view];
}
- (UIView *)viewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    _addressView.tableView = [SharedHandle sharedWithTableViewFrame:CGRectMake(40, 100, kScreenBounds.size.width - 80, kScreenBounds.size.height - 200) target:_addressView];
    UIView *backView = [[UIView alloc] initWithFrame:view.frame];
    backView.backgroundColor = [UIColor darkGrayColor];
    backView.alpha = 0.6;
    [view addSubview:backView];
    [view addSubview:_addressView.tableView];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
