//
//  SharedHandle.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SharedHandleDelegate <NSObject>
@optional
- (void)updateMyOrder;
@end

@interface SharedHandle : NSObject
@property(nonatomic, assign)id<SharedHandleDelegate>delegate;
@property(nonatomic, strong)NSMutableDictionary *payDataDic;//存放支付使用到的数据
+ (instancetype)sharedHandle;
    //设置搜索框
+ (void)setNagetionBar:(id)target imageName:(NSString *)imageName action:(SEL)action;
    //返回TableView 控件
+ (UITableView *)sharedWithTableViewFrame:(CGRect)frame target:(id)target;
    //提示框
+ (BOOL)sharedPromptBox:(NSString *)title;
    //动态计算高度
+ (CGFloat)heightLabelWithFont:(UIFont *)font sendString:(NSString *)sendStr width:(CGFloat)width;
+ (CGFloat)widthLabelWithFont:(UIFont *)font sendString:(NSString *)sendStr height:(CGFloat)height;
    //登录
+ (UITextField *)sharedWithTextFieldFrame:(CGRect)frame placeholder:(NSString *)placeholder title:(NSString *)title secureTextEntry:(BOOL)secureTextEntry target:(id)target;
    //验证手机好是否正确
//+ (BOOL)validateMobile:(NSString *)mobile;

    //选择支付方式
+ (void)choiceOfPayment:(NSInteger)buttonIndex target:(id)target;
- (NSString *) base64:(NSString *)password;

@end
