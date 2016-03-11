//
//  MineCollectionViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-8.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MineCollectionViewCell.h"

@interface MineCollectionViewCell ()
{
    UIImageView *_imageView;
    UILabel     *_nameLabel;
}
@end

@implementation MineCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 70)];
            //_imageView.backgroundColor = [UIColor redColor];
            //_imageView.image = [UIImage imageNamed:@"Wode@2x.png"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSetFrameY(_imageView), _imageView.bounds.size.width, 30)];
            //_nameLabel.backgroundColor = [UIColor greenColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_nameLabel];
    }
    return self;
}
- (void)setLabelName:(NSString *)labelName
{
    if (_labelName != labelName) {
        _labelName = labelName;
    }
    _nameLabel.text = _labelName;
}
- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    _imageView.image = [UIImage imageNamed:imageName];
}
@end
