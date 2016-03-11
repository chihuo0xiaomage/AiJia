//
//  CateSmallTitleData.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateSmallTitleData : NSObject
@property(nonatomic, strong)NSString * titleName;
@property(nonatomic, strong)NSString * shopName;
@property(nonatomic, strong)NSString * urlImage;
@property(nonatomic, strong)NSString * shopID;

- (id)initWithSmallData:(id)sender;
@end
