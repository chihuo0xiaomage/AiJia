//
//  CateCollectionViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CateCollectionViewCell.h"
#import "CateSmallTitleData.h"
#import "UIImageView+WebCache.h"
@interface CateCollectionViewCell ()
{
    UILabel     *_titleLabel;
    UIImageView *_imageView;
}
@end

@implementation CateCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 15)];
            //_titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.bounds.size.height, frame.size.width, frame.size.height - _titleLabel.bounds.size.height)];
        //_imageView.backgroundColor = [UIColor greenColor];
        [self addSubview:_imageView];
    }
    return self;
}
- (void)setSmallTitleModel:(CateSmallTitleData *)smallTitleModel
{
    if (_smallTitleModel != smallTitleModel) {
        _smallTitleModel = smallTitleModel;
    }
    _titleLabel.text = _smallTitleModel.shopName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_smallTitleModel.urlImage] placeholderImage:[UIImage imageNamed:@"fenlei.png"]];
    
}
@end
