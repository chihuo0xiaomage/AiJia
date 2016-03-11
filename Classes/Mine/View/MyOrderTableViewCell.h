//
//  MyOrderTableViewCell.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderData;
@interface MyOrderTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *orderNumberLabel;
@property(nonatomic, strong)UILabel *orderStatusLabel;
@property(nonatomic, strong)UILabel *orderPriceLabel;
@property(nonatomic, strong)UILabel *orderTimeLabel;

@property(nonatomic, strong)UIImageView *shopImageView;
@property(nonatomic, strong)UILabel *shopNameLabel;
@property(nonatomic, strong)UILabel *shopPriceLabel;
@property(nonatomic, strong)UILabel *shopNumberLabel;

@property(nonatomic, strong)MyOrderData *myOrderData;
@property(nonatomic, strong)MyOrderData *shopOrderData;
- (id)initWithStyleOrder:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyleGoods:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (id)initWithStylePay:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)UIButton *cancelOrderButton;
@end
