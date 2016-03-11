//
//  ClearTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ClearTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ClearTableViewCell ()
{
    UIImageView *_shopImageView;
    UILabel     *_nameLabel;
    UILabel     *_priceLabel;
    UILabel     *_numberLabel;
    UILabel     *_sumPriceLabel;
}
@end

@implementation ClearTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            //_shopImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_shopImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_shopImageView) + 5, 5, kScreenBounds.size.width - 80, 20)];
            //_nameLabel.backgroundColor = [UIColor redColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, kSetFrameY(_nameLabel) + 10, 80, 20)];
        _priceLabel.text = @"单价:650.00";
        _priceLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_priceLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_priceLabel) + 10, _priceLabel.frame.origin.y, 50, 20)];
        _numberLabel.font = [UIFont systemFontOfSize:14.0];
        _numberLabel.text = @"数量:10";
        [self addSubview:_numberLabel];
        
        _sumPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_numberLabel) + 10, _numberLabel.frame.origin.y, 100, 20)];
        _sumPriceLabel.font = [UIFont systemFontOfSize:14.0];
        _sumPriceLabel.text = @"小计:￥65.00";
        _sumPriceLabel.textColor = [UIColor redColor];
            //_sumPriceLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_sumPriceLabel];
    }
    return self;
}
- (void)setShopDic:(NSDictionary *)shopDic
{
    if (_shopDic != shopDic) {
            //NSLog(@"%@", _shopDic);
        _shopDic = shopDic;
        [_shopImageView sd_setImageWithURL:[NSURL URLWithString:[_shopDic objectForKey:@"image"]] placeholderImage:nil];
        _shopImageView.contentMode = UIViewContentModeScaleAspectFit;
        _nameLabel.text = [_shopDic objectForKey:@"name"];
        _priceLabel.text = [NSString stringWithFormat:@"单价:%@", [_shopDic objectForKey:@"price"]];
        _numberLabel.text = [NSString stringWithFormat:@"数量:%@", [_shopDic objectForKey:@"quantity"]];
        _sumPriceLabel.text = [NSString stringWithFormat:@"小计:￥%.2f", [self sumPrice]];
    }
}
- (CGFloat)sumPrice
{
    CGFloat sumPrice = [[_shopDic objectForKey:@"quantity"] integerValue] * [[_shopDic objectForKey:@"price"] floatValue];
    return sumPrice;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
