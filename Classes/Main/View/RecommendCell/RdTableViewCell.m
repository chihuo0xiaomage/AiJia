//
//  RdTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "RdTableViewCell.h"

@interface RdTableViewCell ()
{
    id  _target;
    SEL _action;
    NSMutableArray *_imageViewArray;
}
@end

@implementation RdTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _target = target;
        _action = action;
        _imageViewArray = [NSMutableArray array];
        [self addControl];
    }
    return self;
}
- (void)addControl
{
    NSArray * imageUrlArray = @[@"newProduct.png", @"boutique.png", @"huddle.png"];
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 +  i * 105, 5, 100, 70)];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:imageUrlArray[i]];
        [_imageViewArray addObject:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:_target action:_action];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
