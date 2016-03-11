//
//  ClearView.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-8.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ClearView.h"
#import "ClearViewController.h"
#import "CartViewController.h"
@interface ClearView ()
{
    CartViewController *_viewController;
    UILabel          *_numberLabel;
    UILabel          *_moreInfoLabel;
    UILabel          *_sumPriceLabel;
    UIButton         *_clearButton;
}
@end

@implementation ClearView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tianxiedingdan.png"]];
        imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, 49);
        [self addSubview:imageView];
        
        _viewController = target;
            //self.backgroundColor = [UIColor yellowColor];
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 49)];
            //_numberLabel.backgroundColor = [UIColor redColor];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.font = [UIFont systemFontOfSize:16.0];
        _numberLabel.text = @"120";
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_numberLabel];
        
        _moreInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_numberLabel), _numberLabel.frame.origin.y, 90, _numberLabel.bounds.size.height)];
            //_moreInfoLabel.backgroundColor = [UIColor whiteColor];
        _moreInfoLabel.font = [UIFont systemFontOfSize:16.0];
        _moreInfoLabel.text = @"件商品 共计:";
        [self addSubview:_moreInfoLabel];
        
        _sumPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_moreInfoLabel), _moreInfoLabel.frame.origin.y, 85, _moreInfoLabel.bounds.size.height)];
            //_sumPriceLabel.backgroundColor = [UIColor whiteColor];
        _sumPriceLabel.text = @"￥1296.90";
        _sumPriceLabel.font = [UIFont systemFontOfSize:16.0];
        _sumPriceLabel.textColor = [UIColor redColor];
        [self addSubview:_sumPriceLabel];
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(kSetFrameX(_sumPriceLabel) + 5, _sumPriceLabel.frame.origin.y + 10, 90, 29);
        [_clearButton addTarget:self action:@selector(clearViewController) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.backgroundColor = [UIColor redColor];
        [_clearButton setTitle:@"结算(120)" forState:UIControlStateNormal];
        [self addSubview:_clearButton];
    }
    return self;
}
- (void)clearViewController
{
    ClearViewController *clearViewController = [[ClearViewController alloc] init];
    clearViewController.shopArray = _viewController.clearArray;
    clearViewController.sumPrice = _sumPriceLabel.text;
    clearViewController.sumNumber = _numberLabel.text;
    [_viewController.navigationController pushViewController:clearViewController animated:YES];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [_viewController.navigationController pushViewController:[[ClearViewController alloc] init] animated:YES];
//}

@end
