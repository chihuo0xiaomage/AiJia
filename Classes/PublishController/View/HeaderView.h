//
//  HeaderView.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-4.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property(nonatomic, strong)UIImageView *addressView;
@property(nonatomic, strong)NSDictionary *addressDic;
@property(nonatomic, strong)UILabel *selectPayLabel;
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;
- (id)initWithFrame:(CGRect)frame target:(id)target;
@end
