//
//  RedTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-27.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "RedTableViewCell.h"

@interface RedTableViewCell ()
{
    UILabel *_redTypeLabel;
    UILabel *_redPriceLabel;
    UILabel *_timeLabel;
}
@end

@implementation RedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _redTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 20)];
            //_redTypeLabel.backgroundColor = [UIColor yellowColor];
        _redTypeLabel.text = @"消费";
        [self addSubview:_redTypeLabel];
        
        _redPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(_redTypeLabel) + 10, _redTypeLabel.frame.origin.y, 100, 20)];
        _redPriceLabel.textColor = [UIColor orangeColor];
        [self addSubview:_redPriceLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_redTypeLabel.frame.origin.x, kSetFrameY(_redTypeLabel), 160, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
            //_timeLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_timeLabel];
    }
    return self;
}
- (void)setRedDic:(NSDictionary *)redDic
{
    if (_redDic != redDic) {
        _redDic = redDic;
    }
        //NSLog(@"%@", _redDic);
    _redTypeLabel.text = [_redDic objectForKey:@"dtype"];
    _redPriceLabel.text = [NSString stringWithFormat:@"%@元", [_redDic objectForKey:@"dcard_money"]];
    _timeLabel.text = [_redDic objectForKey:@"ddate"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
