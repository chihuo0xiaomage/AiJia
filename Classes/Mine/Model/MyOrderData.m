//
//  MyOrderData.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MyOrderData.h"

@implementation MyOrderData
- (id)initWithOrderNumber:(id)dic
{
    self = [super init];
    if (self) {
        self.orderNumber = [dic objectForKey:@"oSn"];
        self.orderPrice = [dic objectForKey:@"totalAmount"];
        self.orderTime = [dic objectForKey:@"createDate"];
        self.orderStatus = [dic objectForKey:@"orderStatus"];
    }
    return self;
}
- (id)initWithMyGoods:(id)dic
{
    self = [super init];
    if (self) {
        self.imageUrl = [dic objectForKey:@"image"];
        self.name = [dic objectForKey:@"name"];
        self.price = [dic objectForKey:@"price"];
        self.number = [dic objectForKey:@"quantity"];
    }
    return self;
}
@end
