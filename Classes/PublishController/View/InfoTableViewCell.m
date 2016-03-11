//
//  InfoTableViewCell.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-12.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "InformationViewController.h"
@interface InfoTableViewCell ()
{
    UILabel *_nameLabel;
    UITextView *_addressLabel;
    InformationViewController *_target;
}
@end

@implementation InfoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *backImageView1 = [self imageViewWithFrame:CGRectMake(15, 10, kScreenBounds.size.width - 30, 100)];
        backImageView1.userInteractionEnabled = YES;
            //[backImageView1 setBackgroundColor:[UIColor whiteColor]];
        [backImageView1 setImage:[UIImage imageNamed:@"shouhuorenxinxi.png"]];
        [self addSubview:backImageView1];
    }
    return self;
}
- (UIImageView *)imageViewWithFrame:(CGRect)frame
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:frame];
        //backImageView.backgroundColor = [UIColor whiteColor];
        //imageView.highlightedImage = [UIImage imageNamed:@""];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 220, 30)];
    _nameLabel.font = [UIFont systemFontOfSize:16.0];
        //_nameLabel.backgroundColor = [UIColor yellowColor];
    [backImageView addSubview:_nameLabel];
    
    _addressLabel = [[UITextView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, kSetFrameY(_nameLabel), kScreenBounds.size.width - 120, 50)];
        //_addressLabel.backgroundColor = [UIColor yellowColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.userInteractionEnabled = NO;
    _addressLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //_addressLabel.backgroundColor = [UIColor redColor];
    [backImageView addSubview:_addressLabel];
    
    self.editorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_editorButton.backgroundColor = [UIColor yellowColor];
    _editorButton.frame = CGRectMake(kSetFrameX(_addressLabel), 0, 55, 100);
    [backImageView addSubview:_editorButton];
    return backImageView;
}
- (void)setAddressDic:(NSDictionary *)addressDic
{
    if (_addressDic != addressDic) {
        _addressDic = addressDic;
    }
        //NSLog(@"_addressDic = %@", _addressDic);
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[_addressDic objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_addressDic objectForKey:@"mobile"]];
    _addressLabel.text = [NSString stringWithFormat:@"%@%@", [_addressDic objectForKey:@"areaName"], [[_addressDic objectForKey:@"address"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
