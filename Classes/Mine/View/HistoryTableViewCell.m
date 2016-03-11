//
//  BalanceTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()
{
    UILabel *_cardNoLabel;
    UILabel *_typeLabel;
    UILabel *_priceLabel;
    UILabel *_timeLabel;
    UILabel *_addressLabel;
}
@end

@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cardNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenBounds.size.width-30, 30)];
        _cardNoLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cardNoLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cardNoLabel.frame.origin.x, kSetFrameY(_cardNoLabel), 40, _cardNoLabel.bounds.size.height)];
        _typeLabel.backgroundColor = [UIColor whiteColor];
        _typeLabel.textColor = [UIColor grayColor];
        [self addSubview:_typeLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_typeLabel), _typeLabel.frame.origin.y, _cardNoLabel.bounds.size.width-_typeLabel.bounds.size.width, 30)];
        _priceLabel.backgroundColor = [UIColor whiteColor];
        _priceLabel.textColor = [UIColor orangeColor];
        [self addSubview:_priceLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeLabel.frame.origin.x, kSetFrameY(_typeLabel), _cardNoLabel.bounds.size.width*2/3, _typeLabel.bounds.size.height)];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_timeLabel), _timeLabel.frame.origin.y, _cardNoLabel.bounds.size.width/3, _timeLabel.bounds.size.height)];
        _addressLabel.font = [UIFont systemFontOfSize:16];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_addressLabel];
    }
    return self;
}
- (void)setHistoryData:(NSDictionary *)historyData
{
    if (_historyData != historyData) {
        _historyData = historyData;
    }
    _typeLabel.text = [_historyData objectForKey:@"dtype"];
    _priceLabel.text = [NSString stringWithFormat:@"%@元", [_historyData objectForKey:@"dcard_money"]];
    _timeLabel.text = [_historyData objectForKey:@"ddate"];
    _addressLabel.text = [_historyData objectForKey:@"dshopName"];
}
- (void)setAmountData:(NSDictionary *)amountData
{
    if (_amountData != amountData) {
        _amountData = amountData;
    }
    _typeLabel.text = [_amountData objectForKey:@"dchangeType"];
    _priceLabel.text = [_amountData objectForKey:@"dchangeMoney"];
    _timeLabel.text = [_amountData objectForKey:@"ddate"];
    _addressLabel.text = [_amountData objectForKey:@"dshopName"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
