//
//  FooterView.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterView : UIView

@property(nonatomic, strong)NSMutableArray *shopIdArray;
@property(nonatomic, strong)NSMutableArray *buyNowArray;
@property(nonatomic, assign)NSInteger shopNumber;
- (id)initWithFrame:(CGRect)frame target:(id)target;
@end
