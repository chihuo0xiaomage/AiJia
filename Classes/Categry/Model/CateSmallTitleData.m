//
//  CateSmallTitleData.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CateSmallTitleData.h"

@implementation CateSmallTitleData
- (id)initWithSmallData:(id)sender
{
    self = [super init];
    if (self) {
        self.shopName = [sender objectForKey:@"name"];
        self.shopID = [sender objectForKey:@"pid"];
        self.urlImage = [sender objectForKey:@"icon"];
    }
    return self;
}
@end
