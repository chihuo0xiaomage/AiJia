//
//  ClearView.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-8.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearView : UIView
@property(nonatomic, strong)UILabel * numberLabel;
@property(nonatomic, strong)UILabel *sumPriceLabel;
@property(nonatomic, strong)UIButton *clearButton;
@property(nonatomic, strong)NSString *goodsId;
- (id)initWithFrame:(CGRect)frame target:(id)target;
@end
