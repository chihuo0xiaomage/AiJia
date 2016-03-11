//
//  CartTableViewCell.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-6.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView  *IDImageView;
@property(nonatomic, strong)NSDictionary *dataDic;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target;
@end
