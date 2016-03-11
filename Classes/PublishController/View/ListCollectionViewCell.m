//
//  ListCollectionViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SharedHandle.h"
@interface ListCollectionViewCell ()
{
    UIImageView *_IDimageView;
    UIImageView *_dataImageView;
    UILabel     *_nameLabel;
    UILabel     *_nowLabel;
    UILabel     *_originalLabel;
    UIButton    *_moreInfoButton;
    UIView      *_lineView;
}
@end

@implementation ListCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _IDimageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 30, 30)];
            //_IDimageView.backgroundColor = [UIColor grayColor];
        _IDimageView.image = [UIImage imageNamed:@"duihao-grey.png"];
            //_IDimageView.highlightedImage = [UIImage imageNamed:@"boutique.png"];
        [self addSubview:_IDimageView];
        
        _dataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSetFrameX(_IDimageView) + 5, 0, 100, 110)];
            //_dataImageView.backgroundColor = [UIColor brownColor];
        [self addSubview:_dataImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_IDimageView.frame.origin.x, kSetFrameY(_dataImageView), 140, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_nameLabel];
        
        _nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(_IDimageView.frame.origin.x, kSetFrameY(_nameLabel), 70, 20)];
        _nowLabel.font = [UIFont systemFontOfSize:14.0];
        _nowLabel.textColor = [UIColor orangeColor];
        _nowLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nowLabel];
        
        _originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nowLabel.frame.origin.x, kSetFrameY(_nowLabel), _nowLabel.bounds.size.width, _nowLabel.bounds.size.height)];
        _originalLabel.font = [UIFont systemFontOfSize:12.0];
        _originalLabel.textAlignment = NSTextAlignmentCenter;
        _originalLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_originalLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [_originalLabel addSubview:_lineView];
        
        _moreInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreInfoButton.frame = CGRectMake(kSetFrameX(_nowLabel), _nowLabel.frame.origin.y + 5, 70, 30);
        _moreInfoButton.backgroundColor = [UIColor lightGrayColor];
        _moreInfoButton.layer.cornerRadius = 3.0;
        _moreInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_moreInfoButton setTitle:@"更多详情" forState:UIControlStateNormal];
        [self addSubview:_moreInfoButton];
    }
    return self;
}
- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
    [_dataImageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"image"]] placeholderImage:nil];
    _dataImageView.contentMode =UIViewContentModeScaleToFill;
    _nameLabel.text = [_dic objectForKey:@"name"];
    _nowLabel.text = [NSString stringWithFormat:@"￥%.2f", [[dic objectForKey:@"price"] floatValue]];
    _originalLabel.text = [NSString stringWithFormat:@"￥%.2f", [[dic objectForKey:@"marketPrice"] floatValue]];
    CGFloat width = [SharedHandle widthLabelWithFont:_originalLabel.font sendString:_originalLabel.text height:_originalLabel.bounds.size.height];
    _lineView.frame = CGRectMake((_originalLabel.bounds.size.width - width)/2, _originalLabel.bounds.size.height/2, width, 1.0);
}
@end
