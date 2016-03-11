//
//  ClearModel.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-5.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearModel : NSObject
@property(nonatomic, strong)NSString *memberId;
@property(nonatomic, strong)NSString *goodsTotalQuantity;
@property(nonatomic, strong)NSString *goodsTotalPrice;
@property(nonatomic, strong)NSString *deliveryFee;
@property(nonatomic, strong)NSString *totalAmount;
@property(nonatomic, strong)NSString *paymentMethodId;
@property(nonatomic, strong)NSString *payMethodName;
@property(nonatomic, strong)NSString *payType;
@property(nonatomic, strong)NSString *deliveryMethodId;
@property(nonatomic, strong)NSString *deliveryMethodName;
@property(nonatomic, strong)NSString *shipName;
@property(nonatomic, strong)NSString *shipAreaId;
@property(nonatomic, strong)NSString *shipAreaPath;
@property(nonatomic, strong)NSString *shipAddress;
@property(nonatomic, strong)NSString *shopZipCode;
@property(nonatomic, strong)NSString *shipPhone;
@property(nonatomic, strong)NSString *shipMobile;
@property(nonatomic, strong)NSString *selfgetAreaName;
@property(nonatomic, strong)NSString *selfgetTime;
@property(nonatomic, strong)NSString *selfgetAreaId;
@property(nonatomic, strong)NSString *goodsId;
@property(nonatomic, strong)NSString *quantity;
- (id)initWithDic:(NSDictionary *)dic;
@end
