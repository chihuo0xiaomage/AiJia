    //
    //  PasswordChangeScrollView.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-10.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //

#import "PasswordChangeScrollView.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "PasswordChangeViewController.h"
static NSString *const changePassword = @"changPassword";
@interface PasswordChangeScrollView ()
{
    UITextField *_cardNoTextField;
    UITextField *_usedTextField;
    UITextField *_newTextField;
    UITextField *_onceNewTextField;
    UIButton    *_changeButton;
    NSDictionary*_memberInfo;
    PasswordChangeViewController *_passwordViewController;
}
@end

@implementation PasswordChangeScrollView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _memberInfo = kGetData(@"memberInfo");
        _passwordViewController = target;
        [self setDelegate:(id<UIScrollViewDelegate>)self];
        _cardNoTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(15, 10, kScreenBounds.size.width - 30, 40) placeholder:nil title:@"卡号:" secureTextEntry:NO target:self];
        _cardNoTextField.text = [_memberInfo objectForKey:@"cardNo"];
        _cardNoTextField.userInteractionEnabled = NO;
        [self addSubview:_cardNoTextField];
        
        _usedTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_cardNoTextField.frame.origin.x, kSetFrameY(_cardNoTextField) + 10, _cardNoTextField.bounds.size.width, _cardNoTextField.bounds.size.height) placeholder:@"原始密码" title:@"密码:" secureTextEntry:YES target:self];
        [self addSubview:_usedTextField];
        
        _newTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_usedTextField.frame.origin.x, kSetFrameY(_usedTextField)+10, _usedTextField.bounds.size.width, _usedTextField.bounds.size.height) placeholder:@"新密码" title:@"密码:" secureTextEntry:YES target:self];
        [self addSubview:_newTextField];
        
        _onceNewTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_newTextField.frame.origin.x, kSetFrameY(_newTextField)+10, _newTextField.bounds.size.width, _newTextField.bounds.size.height) placeholder:@"确认新密码" title:@"密码:" secureTextEntry:YES target:self];
        [self addSubview:_onceNewTextField];
        
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.frame = CGRectMake(_onceNewTextField.frame.origin.x, kSetFrameY(_onceNewTextField)+ 15, _onceNewTextField.bounds.size.width, _onceNewTextField.bounds.size.height);
        [_changeButton setTitle:@"确认" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_changeButton addTarget:self action:@selector(changPasswordRequestData) forControlEvents:UIControlEventTouchUpInside];
        _changeButton.backgroundColor = [UIColor redColor];
        [self addSubview:_changeButton];
    }
    return self;
}
#pragma mark - 开始网络请求
- (void)changPasswordRequestData
{
    if (![_usedTextField.text isEqualToString:@""] && ![_newTextField.text isEqualToString:@""] && ![_onceNewTextField.text isEqualToString:@""]) {
        if ([_newTextField.text isEqualToString: _onceNewTextField.text]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changPasswordRequestDataEnd:) name:changePassword object:nil];
            NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.wscard.passwd.change&v=1.0&format=json&locale=zh_CN&client=iPhone&cardNo=%@&uniqueCode=35701&oldPwd=%@&newPwd=%@", [_memberInfo objectForKey:@"cardNo"], _usedTextField.text, _newTextField.text];
            [NetWorking netWorkingWithUrl:urlStr identification:changePassword];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"您两次输入的密码不一样" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"请您完善信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
}
- (void)changPasswordRequestDataEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changePassword object:nil];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_passwordViewController.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        //NSLog(@"%@", textField.text);
    if (textField.text.length >= 6) {
        return NO;
    }
    return [self validateNumber:string];
}
    //限制输入的字符类型 输入字数;
- (BOOL)validateNumber:(NSString*)number
{

    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        //NSLog(@"==========开始编辑");
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (kScreenBounds.size.height == 480) {
        [UIView beginAnimations:nil context:nil];
        if (textField == _usedTextField) {
            self.contentOffset = CGPointMake(0, -64);
        }else if (textField == _newTextField) {
            self.contentOffset = CGPointMake(0, -14);
        }else if (textField == _onceNewTextField){
            self.contentOffset = CGPointMake(0, 36);
        }
        [UIView commitAnimations];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_usedTextField resignFirstResponder];
    [_newTextField resignFirstResponder];
    [_onceNewTextField resignFirstResponder];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
