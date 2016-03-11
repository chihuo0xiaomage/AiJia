//
//  HeadCollectionReusableView.m
//  AiJia
//
//  Created by 宝源科技 on 14-12-26.
//  Copyright (c) 2014年 lipengjun. All rights reserved.
//

#import "HeadCollectionReusableView.h"

@implementation HeadCollectionReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, 20)];
        self.label.font = [UIFont systemFontOfSize:18];
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
        }
    return self;
}
@end
