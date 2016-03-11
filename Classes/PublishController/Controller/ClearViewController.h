//
//  ClearViewController.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-8.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearViewController : UIViewController
@property(nonatomic, strong)NSMutableArray *shopArray;
@property(nonatomic, strong)NSString *sumPrice;
@property(nonatomic, strong)NSString *sumNumber;
@property(nonatomic, strong)NSString *selfgetTime;
@property(nonatomic, strong)NSString *selfgetAreaName;
    //@property(nonatomic, strong)NSString *paySendInfo;
- (void)getTheDefaultShippingAddress;
@end
