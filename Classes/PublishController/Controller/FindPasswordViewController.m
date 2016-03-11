//
//  FindPasswordViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
static NSString *const MessageAuthenticationCode = @"MessageAuthenticationCode";
static NSString *findLoginPassword = @"findLoginPassword";
@interface FindPasswordViewController ()
{
    UITextField *_iphoneTextField;
    UITextField *_securityTextField;
    UITextField *_newPasswordTextField;
    UITextField *_onceNewPasswordTextField;
    NSString    *_seq;//序号
    UIButton    *_button;
    UIButton    *_findButton;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"找回密码"];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [self loadControl];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(_iphoneTextField.frame.origin.x, kSetFrameY(_iphoneTextField) + 20, _iphoneTextField.bounds.size.width, 35);
    _button.backgroundColor = [UIColor redColor];
    [_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(isInputIPhone:) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.view addSubview:_button];
    
    _findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _findButton.frame = CGRectMake(_iphoneTextField.frame.origin.x, kSetFrameY(_iphoneTextField) + 20, _iphoneTextField.bounds.size.width, 35);
    _findButton.backgroundColor = [UIColor redColor];
    [_findButton setTitle:@"确定" forState:UIControlStateNormal];
    [_findButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    _findButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _findButton.hidden = YES;
    [self.view addSubview:_findButton];
    
    
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = self.view.center;
    _activityIndicatorView.frame = self.view.frame;
    _activityIndicatorView.hidden = YES;
    _activityIndicatorView.tintColor = [UIColor whiteColor];
    [self.view addSubview:_activityIndicatorView];
    // Do any additional setup after loading the view.
}
- (void)isInputIPhone:(UIButton *)btn
{
    if (![_iphoneTextField.text isEqualToString:@""]) {
            //NSLog(@"获取验证码");
        [_iphoneTextField resignFirstResponder];
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        [self getVerificationCode];
    }else {
        [SharedHandle sharedPromptBox:@"完善信息"];
    }
}
#pragma mark -获取找回密码的验证码
- (void)getVerificationCode
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVerificationCodeEnd:) name:MessageAuthenticationCode object:nil];
    NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.send.message&v=1.0&format=json&locale=zh_CN&client=iPhone&mobile=%@&mmstemplate=mobile&uniqueCode=35701",  _iphoneTextField.text];
    
        //NSLog(@"%@", urlStr);
    [NetWorking netWorkingWithUrl:urlStr identification:MessageAuthenticationCode];
}
- (void)getVerificationCodeEnd:(id)sender
{
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MessageAuthenticationCode object:nil];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _seq = [dic objectForKey:@"seq"];
//            [_button setTitle:@"确定" forState:UIControlStateNormal];
//            [_button addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
            [_button setHidden:YES];
            [_findButton setHidden:NO];
            _iphoneTextField.hidden = YES;
            _securityTextField.hidden = NO;
            _newPasswordTextField.hidden = NO;
            _onceNewPasswordTextField.hidden = NO;
            _findButton.frame = CGRectMake(_button.frame.origin.x, kSetFrameY(_onceNewPasswordTextField) + 20, _button.bounds.size.width, _button.bounds.size.height);
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
#pragma mark - 确定修改密码
- (NSString *)replaceCharaer:(NSString *)sender
{
    NSString *replace1 = [sender stringByReplacingOccurrencesOfString:@"=" withString:@"."];
    NSString *replace2 = [replace1 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *replace3 = [replace2 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    return replace3;
}
- (void)findPassword
{
        //NSLog(@"找回密码");
    if ([_onceNewPasswordTextField.text isEqualToString:_newPasswordTextField.text] && ![_onceNewPasswordTextField.text isEqualToString:@""] && ![_securityTextField.text isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findPasswordEnd:) name:findLoginPassword object:nil];
        NSString *newPassword = [self replaceCharaer:[[SharedHandle sharedHandle] base64:_onceNewPasswordTextField.text]];
        NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.passwd.recovery&v=1.0&format=json&locale=zh_CN&client=iPhone&userName=%@&newPasswd=%@&captcha=%@&seq=%@&mmstemplate=mobile&uniqueCode=35701",  _iphoneTextField.text, newPassword, _securityTextField.text, _seq];
        [NetWorking netWorkingWithUrl:urlStr identification:findLoginPassword];
    }else if ([_securityTextField.text isEqualToString:@""] || [_onceNewPasswordTextField.text isEqualToString:@""] || [_newPasswordTextField.text isEqualToString:@""]){
        [SharedHandle sharedPromptBox:@"您的信息不完整"];
    }else{
        [SharedHandle sharedPromptBox:@"您两次输入的密码不通"];
    }
    
}
- (void)findPasswordEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加载控件
- (void)loadControl
{
    _iphoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, kScreenBounds.size.width - 30, 35)];
    [_iphoneTextField setDelegate:(id<UITextFieldDelegate>)self];
    _iphoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _iphoneTextField.placeholder = @"请输入手机号";
    _iphoneTextField.backgroundColor = [UIColor whiteColor];
    _iphoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_iphoneTextField];
    
    _securityTextField = [[UITextField alloc] initWithFrame:_iphoneTextField.frame];
    [_securityTextField setDelegate:(id<UITextFieldDelegate>)self];
    _securityTextField.placeholder = @"请输入验证码";
    _securityTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _securityTextField.borderStyle = UITextBorderStyleRoundedRect;
    _securityTextField.backgroundColor = [UIColor whiteColor];
    _securityTextField.hidden = YES;
    [self.view addSubview:_securityTextField];
    
    _newPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_securityTextField.frame.origin.x, kSetFrameY(_securityTextField) + 10, _securityTextField.bounds.size.width, _securityTextField.bounds.size.height)];
    [_newPasswordTextField setDelegate:(id<UITextFieldDelegate>)self];
    _newPasswordTextField.placeholder = @"新密码";
    _newPasswordTextField.secureTextEntry = YES;
    _newPasswordTextField.backgroundColor = [UIColor whiteColor];
    _newPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _newPasswordTextField.hidden = YES;
    [self.view addSubview:_newPasswordTextField];
    
    _onceNewPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_newPasswordTextField.frame.origin.x, kSetFrameY(_newPasswordTextField) + 10, _securityTextField.bounds.size.width, _securityTextField.bounds.size.height)];
    [_onceNewPasswordTextField setDelegate:(id<UITextFieldDelegate>)self];
    _onceNewPasswordTextField.placeholder = @"新密码确认";
    _onceNewPasswordTextField.secureTextEntry = YES;
    _onceNewPasswordTextField.backgroundColor = [UIColor whiteColor];
    _onceNewPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _onceNewPasswordTextField.hidden = YES;
    [self.view addSubview:_onceNewPasswordTextField];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_iphoneTextField resignFirstResponder];
    [_newPasswordTextField resignFirstResponder];
    [_onceNewPasswordTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
