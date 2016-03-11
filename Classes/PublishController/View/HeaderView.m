//
//  HeaderView.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-4.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "HeaderView.h"
#import "SharedHandle.h"
#import "InformationViewController.h"
#import "PayTypeViewController.h"
#import "AddressScrollView.h"
#import "AddressViewController.h"
#import "ClearViewController.h"
@interface HeaderView ()
{
    UIViewController *_target;
    UILabel *_infoLabel;
    UILabel *_manLabel;
    UILabel *_mobelLabel;
    UILabel *_addressLabel;
    UILabel *_payTypeLabel;
    UILabel *_selectPayLabel;
}
@end

@implementation HeaderView
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, 40);
        imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, kSetFrameY(imageView), kScreenBounds.size.width - 40, frame.size.height - imageView.bounds.size.height)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor brownColor];
        label.numberOfLines = 0;
        [self addSubview:label];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        _target = target;
        self.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
        UIView *titleView = [self viewTitle];
        [self addSubview:titleView];
        
        UIView *infoView = [self viewWithFrame:CGRectMake(titleView.frame.origin.x, kSetFrameY(titleView)+1, kScreenBounds.size.width, 50) ManInfo:@selector(pushLookForAddressViewController)];
        [self addSubview:infoView];
        
        self.addressView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianjiashouhuorendizhi.png"]];
        _addressView.frame = infoView.frame;
        _addressView.backgroundColor = [UIColor yellowColor];
        _addressView.userInteractionEnabled = YES;
        _addressView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newAddressView)];
        [_addressView addGestureRecognizer:tap];
        [self addSubview:_addressView];
        
        UIView *payTypeView = [self viewWithFrame:CGRectMake(0, kSetFrameY(infoView)+1, kScreenBounds.size.width, 37) action:@selector(pushLookForPayTypeController)];
            //((ClearViewController *)_target).paySendInfo = _selectPayLabel.text;
        [self addSubview:payTypeView];
    }
    return self;
}
- (void)newAddressView
{
    AddressViewController *addressViewController = [[AddressViewController alloc] init];
    addressViewController.title = @"新建地址";
    [_target.navigationController pushViewController:addressViewController animated:YES];
}
- (void)pushLookForAddressViewController
{
    [_target.navigationController pushViewController:[[InformationViewController alloc] init] animated:YES];
}
- (void)pushLookForPayTypeController
{
    PayTypeViewController *payType = [[PayTypeViewController alloc] init];
    payType.label = _selectPayLabel;
    payType.clearViewController = (ClearViewController *)_target;
    [_target.navigationController pushViewController:payType animated:YES];
}
- (UIView *)viewTitle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    _infoLabel.font = [UIFont systemFontOfSize:18.0];
    _infoLabel.text = @"收货人信息";
    [view addSubview:_infoLabel];
    return view;
}
- (UIView *)viewWithFrame:(CGRect)frame ManInfo:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:tap];
    _manLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
    _manLabel.text = @"姓名:";
    _manLabel.font = [UIFont systemFontOfSize:14.0];
    _manLabel.textColor = [UIColor orangeColor];
    [view addSubview:_manLabel];
    
    _mobelLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_manLabel) + 15, _manLabel.frame.origin.y, 150, 20)];
    _mobelLabel.text = @"手机:";
    _mobelLabel.textColor = [UIColor orangeColor];
    _mobelLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:_mobelLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_manLabel.frame.origin.x, kSetFrameY(_manLabel), 300, 20)];
    _addressLabel.text = @"地址:";
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    _addressLabel.textColor = [UIColor orangeColor];
    [view addSubview:_addressLabel];
    return view;
}
- (UIView *)viewWithFrame:(CGRect)frame action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    //[view addGestureRecognizer:tap];
    _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width/2 - 20, frame.size.height)];
    _payTypeLabel.text = @"支付及配送方式";
    _payTypeLabel.font = [UIFont systemFontOfSize:16.0];
    [view addSubview:_payTypeLabel];
    
    _selectPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_payTypeLabel) + 10, 0, frame.size.width/2, frame.size.height)];
    _selectPayLabel.text = @"在线支付  卖家配送";
    _selectPayLabel.font = [UIFont systemFontOfSize:15.0];
    _selectPayLabel.textColor = [UIColor orangeColor];
    [view addSubview:_selectPayLabel];
    return view;
}
#pragma mark - no address
- (void)setAddressDic:(NSDictionary *)addressDic
{
    if (_addressDic != addressDic) {
        _addressDic = addressDic;
    }
        //NSLog(@"======= ");
    _manLabel.text = [NSString stringWithFormat:@"姓名:%@", [_addressDic objectForKey:@"name"]];
    _mobelLabel.text = [NSString stringWithFormat:@"手机:%@", [_addressDic objectForKey:@"mobile"]];
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@%@", [_addressDic objectForKey:@"areaName"],[_addressDic objectForKey:@"address"]];
}


@end
