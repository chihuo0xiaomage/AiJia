//
//  AddressView.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-12.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressScrollView : UIScrollView
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSDictionary *addressDic;
- (id)initWithFrame:(CGRect)frame target:(id)target;
- (void)theChangeOfAddress:(NSString *)aim;
@end
