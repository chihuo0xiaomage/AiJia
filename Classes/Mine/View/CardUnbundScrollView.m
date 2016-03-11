//
//  CardUnbundScrollView.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CardUnbundScrollView.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "CardUnbundlingViewController.h"
static NSString *const cardUnBund = @"cardUnBund";
@interface CardUnbundScrollView ()
{
    UITextField *_cardNoTextField;
    UITextField *_passwordTextField;
    UIButton    *_changeButton;
    NSDictionary*_memberInfo;
    CardUnbundlingViewController *_cardUViewController;
}
@end

@implementation CardUnbundScrollView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        _cardUViewController = target;
        [self setDelegate:(id<UIScrollViewDelegate>)self];
        _memberInfo = kGetData(@"memberInfo");
        _cardNoTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(15, 10, kScreenBounds.size.width - 30, 40) placeholder:nil title:@"卡号:" secureTextEntry:NO target:self];
        _cardNoTextField.text = [_memberInfo objectForKey:@"cardNo"];
        _cardNoTextField.userInteractionEnabled = NO;
        [self addSubview:_cardNoTextField];
        
        _passwordTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_cardNoTextField.frame.origin.x, kSetFrameY(_cardNoTextField)+10, _cardNoTextField.bounds.size.width, _cardNoTextField.bounds.size.height) placeholder:@"卡密码" title:@"密码:" secureTextEntry:NO target:self];
            //[self addSubview:_passwordTextField];
        
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.frame = CGRectMake(_cardNoTextField.frame.origin.x, kSetFrameY(_passwordTextField)+15, _cardNoTextField.bounds.size.width, _cardNoTextField.bounds.size.height);
        _changeButton.backgroundColor = [UIColor redColor];
        [_changeButton setTitle:@"确定" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_changeButton addTarget:self action:@selector(cardUnbundRequestData) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_changeButton];
    }
    return self;
}
- (void)cardUnbundRequestData
{
    if (![_cardNoTextField.text isEqualToString:@""]) {
//        NSString *password = [[SharedHandle sharedHandle] base64:_passwordTextField.text];
        NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.wscard.unbind&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@&cardNo=%@&uniqueCode=35701", [_memberInfo objectForKey:@"id"], [_memberInfo objectForKey:@"cardNo"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardUnbundRequestDataEnd:) name:cardUnBund object:nil];
        [NetWorking netWorkingWithUrl:urlStr identification:cardUnBund];
    }
}
- (void)cardUnbundRequestDataEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cardUnBund object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberInfo"];
            [_cardUViewController updateData];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordTextField resignFirstResponder];
}

@end
