//
//  ListCollectionViewCell.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListCollectionViewCellDelegate <NSObject>

- (void)forMoreDetails:(NSString *)shopId;

@end

@interface ListCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *IDimageView;
@property(nonatomic, strong)NSDictionary *dic;
@property(nonatomic, strong)UIButton *moreInfoButton;
@property(nonatomic, assign)id<ListCollectionViewCellDelegate>delegate;
@end
