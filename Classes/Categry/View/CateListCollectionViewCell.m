//
//  CateListCollectionViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-6.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CateListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface CateListCollectionViewCell ()
{
    UIImageView *_IDImageView;
    UIImageView *_dataImageView;
    UILabel     *_nameLabel;
    UIButton    *_moreInfo;
}
@end

@implementation CateListCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _IDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 30, 30)];
//        _IDImageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_IDImageView];
        
        _dataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSetFrameX(_IDImageView) + 5, 0, 100, 100)];
            //_dataImageView.backgroundColor = [UIColor brownColor];
        [self addSubview:_dataImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_IDImageView.frame.origin.x, kSetFrameY(_dataImageView), 140, 40)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
            //_nameLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:_nameLabel];
        
        _moreInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreInfo.frame = CGRectMake(75, kSetFrameY(_nameLabel) + 5, 70, 30);
        [_moreInfo setTitle:@"更多详情" forState:UIControlStateNormal];
        _moreInfo.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _moreInfo.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_moreInfo];
    }
    return self;
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [_dataImageView sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"image"]] placeholderImage:nil];
    _dataImageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameLabel.text = [_dataDic objectForKey:@"name"];
}
@end
