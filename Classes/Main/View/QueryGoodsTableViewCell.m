//
//  QueryGoodsTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "QueryGoodsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface QueryGoodsTableViewCell ()
{
    UIImageView *_aImageView;
    UILabel     *_nameLabel;
    UILabel     *_priceLabel;
}
@end

@implementation QueryGoodsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _aImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_aImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_aImageView) + 10, _aImageView.frame.origin.y, kScreenBounds.size.width - 120, 30)];
            //_nameLabel.backgroundColor = [UIColor redColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, kSetFrameY(_nameLabel) + 5, _nameLabel.bounds.size.width, 25)];
        _priceLabel.font = [UIFont systemFontOfSize:16.0];
        _priceLabel.textColor = [UIColor orangeColor];
            //_priceLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_priceLabel];
    }
    return self;
}
- (void)setSearchDic:(NSDictionary *)searchDic
{
    if (_searchDic != searchDic) {
        _searchDic = searchDic;
    }

    NSURL *url = [NSURL URLWithString: [_searchDic objectForKey:@"image"]];
    [_aImageView sd_setImageWithURL:url placeholderImage:nil];
    _aImageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameLabel.text = [_searchDic objectForKey:@"fullName"];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[_searchDic objectForKey:@"price"] floatValue]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
