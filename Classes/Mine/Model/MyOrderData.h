//
//  MyOrderData.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderData : NSObject
@property(nonatomic, strong)NSString *orderNumber;
@property(nonatomic, strong)NSString *orderStatus;
@property(nonatomic, strong)NSString *orderPrice;
@property(nonatomic, strong)NSString *orderTime;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *price;
@property(nonatomic, strong)NSString *number;

- (id)initWithOrderNumber:(id)dic;
- (id)initWithMyGoods:(id)dic;
@end
