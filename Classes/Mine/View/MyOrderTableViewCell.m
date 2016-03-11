//
//  MyOrderTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "MyOrderData.h"
#import "UIImageView+WebCache.h"
@implementation MyOrderTableViewCell

    //Initialize the orders interface
- (id)initWithStyleOrder:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenBounds.size.width - 120, 20)];
            //self.orderNumberLabel.text = @"订单号:15021054015382011";
        self.orderNumberLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.orderNumberLabel];
        
        self.orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_orderNumberLabel), _orderNumberLabel.frame.origin.y, kScreenBounds.size.width - 30 - _orderNumberLabel.bounds.size.width, _orderNumberLabel.bounds.size.height + 10)];
        self.orderStatusLabel.backgroundColor = [UIColor cyanColor];
        self.orderStatusLabel.font = [UIFont boldSystemFontOfSize:17.0];
            //self.orderStatusLabel.text = @"等待付款";
        self.orderStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.orderStatusLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.orderStatusLabel];
        
        self.orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, kSetFrameY(_orderNumberLabel), _orderNumberLabel.bounds.size.width, _orderNumberLabel.bounds.size.height)];
            //self.orderPriceLabel.text = @"订单金额:￥77.9";
        self.orderPriceLabel.font = _orderNumberLabel.font;
        self.orderPriceLabel.textColor = [UIColor redColor];
        [self addSubview:self.orderPriceLabel];
        
        self.orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, kSetFrameY(_orderPriceLabel), _orderNumberLabel.bounds.size.width, _orderNumberLabel.bounds.size.height)];
            //self.orderTimeLabel.text = @"下单日期:2015-02-08 18:12:47";
        self.orderTimeLabel.font = _orderPriceLabel.font;
        [self addSubview:_orderTimeLabel];
    }
    return self;
}
- (void)setMyOrderData:(MyOrderData *)myOrderData
{
    if (_myOrderData != myOrderData) {
        _myOrderData = myOrderData;
    }
        //NSLog(@"%@", _myOrderData.orderNumber);
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@", _myOrderData.orderNumber];
        //NSLog(@"---------%@", _myOrderData.orderStatus);
        //_orderStatusLabel.text
    if ([_myOrderData.orderStatus isEqualToString:@"cancel"]) {
            //NSLog(@"已取消");
        _orderStatusLabel.text = @"已取消";
    }else if ([_myOrderData.orderStatus isEqualToString:@"wait_seller_send_goods"]){
            //NSLog(@"等待发货");
        _orderStatusLabel.text = @"等待发货";
    }else if ([_myOrderData.orderStatus isEqualToString:@"wait_buyer_confirm_goods"]){
            //NSLog(@"等待收货");
        _orderStatusLabel.text = @"等待收货";
    }else if ([_myOrderData.orderStatus isEqualToString:@"trade_finished"]){
            //NSLog(@"交易完成");
        _orderStatusLabel.text = @"交易完成";
    }else if ([_myOrderData.orderStatus isEqualToString:@"wait_buyer_pay"]){
            //NSLog(@"等待付款");
        _orderStatusLabel.text = @"等待付款";
    }
    _orderPriceLabel.text = [NSString stringWithFormat:@"订单金额:￥%.2f", [_myOrderData.orderPrice floatValue]];
    _orderTimeLabel.text = [NSString stringWithFormat:@"下单日期:%@", _myOrderData.orderTime];
}
    //Initializes the commodity interface
- (id)initWithStyleGoods:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 70, 70)];
            //self.shopImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.shopImageView];
        
        self.shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_shopImageView)+5, _shopImageView.frame.origin.y, self.bounds.size.width - 100, 30)];
            //self.shopNameLabel.backgroundColor = [UIColor yellowColor];
        self.shopNameLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_shopNameLabel];
        
        self.shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopNameLabel.frame.origin.x, kSetFrameY(_shopNameLabel) + 10, _shopNameLabel.bounds.size.width * 2/3, 30)];
        self.shopPriceLabel.textColor = [UIColor orangeColor];
        self.shopPriceLabel.font = [UIFont systemFontOfSize:16.0];
            //self.shopPriceLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_shopPriceLabel];
        
        self.shopNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_shopPriceLabel), _shopPriceLabel.frame.origin.y, _shopNameLabel.bounds.size.width/3, _shopPriceLabel.bounds.size.height)];
        self.shopNumberLabel.font = [UIFont systemFontOfSize:16.0];
            //_shopNumberLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_shopNumberLabel];
    }
    return self;
}
- (void)setShopOrderData:(MyOrderData *)shopOrderData
{
    if (_shopOrderData != shopOrderData) {
        _shopOrderData = shopOrderData;
    }
        //NSLog(@"%@", _shopOrderData);
        //NSLog(@"%@", _shopOrderData.imageUrl);
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:_shopOrderData.imageUrl] placeholderImage:nil];
    _shopImageView.contentMode = UIViewContentModeScaleAspectFit;
    _shopNameLabel.text = _shopOrderData.name;
    _shopPriceLabel.text =[NSString stringWithFormat:@"单价:￥%.2f", [_shopOrderData.price floatValue]];
    _shopNumberLabel.text = [NSString stringWithFormat:@"数量:%@", _shopOrderData.number];
}
- (id)initWithStylePay:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [self viewWithPayOrCancelOrderWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
    }
    return self;
}
- (UIView *)viewWithPayOrCancelOrderWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(40, 10, 100, 30);
    self.payButton.backgroundColor = [UIColor redColor];
    [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.payButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [view addSubview:_payButton];
    
    self.cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelOrderButton.frame = CGRectMake(kSetFrameX(_payButton) + 40, _payButton.frame.origin.y, _payButton.bounds.size.width, _payButton.bounds.size.height);
    self.cancelOrderButton.backgroundColor = [UIColor redColor];
    [self.cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelOrderButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [view addSubview:_cancelOrderButton];
    return view;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
