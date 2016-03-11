//
//  HodRdTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//
/*
#import "HodRdTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SharedHandle.h"
@interface HodRdTableViewCell ()
{
    UIImageView *_imageView;
    UILabel     *_nameLabel;
    UILabel     *_nowPriceLabel;
    UILabel     *_originalPriceLabel;
    UIView      *_lineView;
    NSMutableArray *_imageArray;
}
@end

@implementation HodRdTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 300, 19)];
        label.text = @"今日推荐";
        [self addSubview:label];
        _imageArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                UIView * view = [self LTViewWithFrame:CGRectMake(5 + j * ((kScreenBounds.size.width - 15)/2 + 5), label.bounds.size.height + 205 * i, (kScreenBounds.size.width - 15)/2, 200)];
                [_imageArray addObject:view];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
                [view addGestureRecognizer:tap];
                [self addSubview:view];
            }
        }
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    for (int i = 0; i < 4; i++) {
       // NSURL *urlImage = [NSURL URLWithString:[_dataArray[i] objectForKey:@"image"]];
       
        UIView *view = _imageArray[i];
        UIImageView * imageView = [view subviews][0];
      //  UILabel * nameLabel = [view subviews][1];
      //  UILabel * nowLabel = [view subviews][2];
      //  UILabel * originalPriceLabel = [view subviews][3];
      //  UIView * lineView = [view subviews][4];
      //  UILabel *IDLabel = [view subviews][5];
        //[imageView sd_setImageWithURL:urlImage placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //nameLabel.text = [dataArray[i] objectForKey:@"name"];
        
       // nowLabel.text = [NSString stringWithFormat:@"现价:￥%.2f", [[_dataArray[i] objectForKey:@"marketPrice"] floatValue]];
        //originalPriceLabel.text = [NSString stringWithFormat:@"原件:￥%.2f",[[_dataArray[i] objectForKey:@"price"] floatValue]];
        CGFloat width = [SharedHandle widthLabelWithFont:originalPriceLabel.font sendString:originalPriceLabel.text height:originalPriceLabel.bounds.size.height] + 10;
        lineView.frame = CGRectMake((originalPriceLabel.bounds.size.width - width) / 2, originalPriceLabel.frame.origin.y + originalPriceLabel.bounds.size.height / 2, width, 1.0);
       // IDLabel.text =[NSString stringWithFormat:@"%@=%@", [_dataArray[i] objectForKey:@"gid"], [_dataArray[i] objectForKey:@"image"]];
    }
}
- (UIView *)LTViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height - 60)];
    [view addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bounds.size.height, view.frame.size.width, 20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:_nameLabel];
    
    _nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x,kSetFrameY(_nameLabel), _nameLabel.bounds.size.width, 20)];
    _nowPriceLabel.textColor = [UIColor orangeColor];
    _nowPriceLabel.textAlignment = NSTextAlignmentCenter;
        //_nowPriceLabel.text = @"现价:￥72.0";
    [view addSubview:_nowPriceLabel];
    
    _originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nowPriceLabel.frame.origin.x, kSetFrameY(_nowPriceLabel), _nowPriceLabel.bounds.size.width, _nowPriceLabel.bounds.size.height)];
    _originalPriceLabel.textAlignment = NSTextAlignmentCenter;
    _originalPriceLabel.textColor = [UIColor grayColor];
    _originalPriceLabel.font = [UIFont systemFontOfSize:14.0];
        //_originalPriceLabel.backgroundColor = [UIColor yellowColor];
        //_originalPriceLabel.text = @"原价:￥72.0";
    [view addSubview:_originalPriceLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor grayColor];
    [view addSubview:_lineView];
    
    UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:IDLabel];
    return view;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
*/