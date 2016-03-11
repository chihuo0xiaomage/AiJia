//
//  ImageView.m
//  BaoYuanWeiPeng
//
//  Created by 宝源科技 on 14-6-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic"]];
        self.imageView.frame = frame;
        [self addSubview:self.imageView];
    }
    return self;
}


@end
