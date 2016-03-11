//
//  PayTypeSelectView.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "PayTypeSelectView.h"

@implementation PayTypeSelectView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor darkGrayColor];
        view.alpha = 0.6;
        [self addSubview:view];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 150, kScreenBounds.size.width - 100, 250) style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5.0;
        [_tableView setDataSource:(id<UITableViewDataSource>)target];
        [_tableView setDelegate:(id<UITableViewDelegate>)target];
        [self addSubview:_tableView];
    }
    return self;
}


@end
