//
//  CartTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-6.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NetWorking.h"
#import "CartViewController.h"
static NSString *const changeCartShopNumber = @"changeCartShopNumber";
@interface CartTableViewCell ()
{
    UIImageView *_IDImageView;
    UIImageView *_dataImageView;
    UILabel     *_nameLabel;
    UILabel     *_priceLabel;
    UIButton    *_subtractButton;
    UILabel     *_numberLabel;
    UIButton    *_addButton;
    UILabel     *_sumPriceLabel;
    CartViewController *_target;
}
@end

@implementation CartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _target = target;
        _IDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
            //_IDImageView.backgroundColor = [UIColor yellowColor];
      _IDImageView.image = [UIImage imageNamed:@"duihao-red.png"];
       
        [self addSubview:_IDImageView];
        
        _dataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSetFrameX(_IDImageView)+ 5, 5, 60, 60)];
        _dataImageView.backgroundColor = [UIColor redColor];
        [self addSubview:_dataImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_dataImageView)+5, _dataImageView.frame.origin.y, kScreenBounds.size.width - (kSetFrameX(_dataImageView)) - 30, 35)];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.numberOfLines = 0;
//        _nameLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, kSetFrameY(_nameLabel), _nameLabel.bounds.size.width, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:15.0];
        _priceLabel.textColor = [UIColor orangeColor];
//        _priceLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_priceLabel];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_dataImageView.frame.origin.x, kSetFrameY(_dataImageView), 40, 30)];
        label.text = @"数量:";
        label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:label];
        
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractButton.frame = CGRectMake(kSetFrameX(label), label.frame.origin.y, label.bounds.size.height, label.bounds.size.height);
            //_subtractButton.backgroundColor = [UIColor yellowColor];
        [_subtractButton setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(changShopNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_subtractButton];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_subtractButton)+5, _subtractButton.frame.origin.y+5, 40, 20)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
            //_numberLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_numberLabel];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kSetFrameX(_numberLabel)+5, _subtractButton.frame.origin.y, _subtractButton.bounds.size.width, _subtractButton.bounds.size.height);
        [_addButton setImage:[UIImage imageNamed:@"jia.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(changShopNumber:) forControlEvents:UIControlEventTouchUpInside];
            //_addButton.backgroundColor = [UIColor yellowColor];
        [self addSubview:_addButton];
        
        UILabel *subtotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_addButton)+10, _addButton.frame.origin.y, label.bounds.size.width - 5, label.bounds.size.height)];
        subtotalLabel.text = @"小计:";
            //subtotalLabel.backgroundColor = [UIColor redColor];
        subtotalLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:subtotalLabel];
        
        _sumPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(subtotalLabel), subtotalLabel.frame.origin.y, 80, subtotalLabel.bounds.size.height)];
        _sumPriceLabel.font = subtotalLabel.font;
        _sumPriceLabel.textColor = [UIColor redColor];
        _sumPriceLabel.text = @"￥123.000";
        [self addSubview:_sumPriceLabel];
    };
    return self;
}
- (void)changShopNumber:(UIButton *)btn
{
    if (btn == _subtractButton && [_numberLabel.text integerValue] > 0) {
        _numberLabel.text = [NSString stringWithFormat:@"%d", [_numberLabel.text intValue] - 1];
    }else if (btn == _addButton){
        _numberLabel.text = [NSString stringWithFormat:@"%d", [_numberLabel.text intValue] + 1];
    }
    [self changeCartShopNumber];
        //_sumPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", [self sumTotalPrice]];
}
- (void)changeCartShopNumber
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCartShopNumberEnd:) name:changeCartShopNumber object:nil];
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.cart.item.mod&v=1.0&format=json&locale=zh_CN&client=iPhone&cartItemId=%@&quantity=%@", [_dataDic objectForKey:@"cid"], _numberLabel.text];
    [NetWorking netWorkingWithUrl:urlStr identification:changeCartShopNumber];
}
- (void)changeCartShopNumberEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changeCartShopNumber object:nil];
    [_target cartRequestData];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [_dataImageView sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"image"]] placeholderImage:nil];
    _dataImageView.contentMode = UIViewContentModeScaleToFill;
    _nameLabel.text = [_dataDic objectForKey:@"name"];
    _priceLabel.text = [NSString stringWithFormat:@"单价:￥%.2f", [[_dataDic objectForKey:@"price"] floatValue]];
    _numberLabel.text = [NSString stringWithFormat:@"%@", [_dataDic objectForKey:@"quantity"]];
    _sumPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self sumTotalPrice]];
}
- (CGFloat)sumTotalPrice
{
    CGFloat sumPrice = [_numberLabel.text integerValue] * [[_dataDic objectForKey:@"price"] floatValue];
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
