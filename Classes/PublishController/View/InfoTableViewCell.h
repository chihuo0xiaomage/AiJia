//
//  InfoTableViewCell.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-12.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
    //- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target;
@property(nonatomic, strong)NSDictionary *addressDic;
@property(nonatomic, strong)UIButton *editorButton;
@end
