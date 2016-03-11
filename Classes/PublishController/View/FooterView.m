    //
    //  FooterView.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-3.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //

#import "FooterView.h"
#import "LoginViewController.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "CartViewController.h"
#import "ClearViewController.h"
static NSString * const joinCart = @"joinCart-shop";
@interface FooterView ()
{
    UIButton *_onceBuyButton;
    UIButton *_joinCartButton;
    id        _target;
}
@end

@implementation FooterView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _target = target;
        _onceBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onceBuyButton.frame = CGRectMake(40, 10, 110, 29);
        _onceBuyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _onceBuyButton.backgroundColor = [UIColor redColor];
        [_onceBuyButton addTarget:self action:@selector(nowStartBuy) forControlEvents:UIControlEventTouchUpInside];
        [_onceBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [self addSubview:_onceBuyButton];
        
        _joinCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinCartButton.frame = CGRectMake(kSetFrameX(_onceBuyButton) + 20, _onceBuyButton.frame.origin.y, _onceBuyButton.bounds.size.width, _onceBuyButton.bounds.size.height);
        _joinCartButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _joinCartButton.backgroundColor = [UIColor orangeColor];
        [_joinCartButton setTitle:@"添加到购物车" forState:UIControlStateNormal   ];
        [_joinCartButton addTarget:self action:@selector(startJoinCart:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_joinCartButton];
    }
    return self;
}
- (void)nowStartBuy
{
    if (kGetData(@"memberId")) {
        ClearViewController *clearViewController = [[ClearViewController alloc] init];
        clearViewController.shopArray = _buyNowArray;
        clearViewController.sumPrice = [NSString stringWithFormat:@"￥%.2f", [[_buyNowArray[0] objectForKey:@"price"] floatValue]];
            //NSLog(@"clearViewController.shopArray === %@", clearViewController.shopArray);
        clearViewController.sumNumber = [_buyNowArray[0] objectForKey:@"quantity"];
        UIViewController *viewController = (UIViewController *)_target;
        [viewController.navigationController pushViewController:clearViewController animated:YES];
    }else{
            //NSLog(@"登陆");
        UIViewController *viewController = (UIViewController *)_target;
        [viewController.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    
}
- (void)startJoinCart:(UIButton *)btn
{
    if (kGetData(@"memberId")) {
        if (_shopIdArray != NULL && _shopIdArray != nil) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startJoinCartEnd:) name:joinCart object:nil];
            for (NSString *shipId in _shopIdArray) {
                NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.cart.item.add&v=1.0&format=json&locale=zh_CN&client=iPhone&goodsId=%@&memberId=%@&quantity=1", shipId, kGetData(@"memberId")];
                [NetWorking netWorkingWithUrl:urlStr identification:joinCart];
            }
        }
    }else{
        UIViewController *viewController = (UIViewController *)_target;
        [viewController.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}
- (void)startJoinCartEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:joinCart object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
                [[[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:self cancelButtonTitle:@"再逛逛" otherButtonTitles:@"去购物车", nil] show];
            }
        }
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CartViewController *cartViewController = [[CartViewController alloc] init];
        cartViewController.isPush = YES;
        [[(UIViewController *)_target navigationController] pushViewController:cartViewController animated:YES];
    }
}


@end
