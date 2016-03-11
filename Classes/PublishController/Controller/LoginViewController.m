//
//  LoginViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "LoginViewController.h"
#import "SharedHandle.h"
#import "RegisterViewController.h"
#import "NetWorking.h"
#import "RDVTabBarController.h"
#import "FindPasswordViewController.h"
static NSString *const login = @"login";
static NSString *const memberInfomationData = @"memberInfomationData";
@interface LoginViewController ()
{
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation LoginViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:login object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRequestDataEnd:) name:login object:nil];
    [self loadControl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
/**
 * 发出登录消息
 **/
- (void)loginRequestData
{
    if ([_userNameTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""]) {
        [SharedHandle sharedPromptBox:@"请您完善登录信息"];
    }else{
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
       // NSString *userName = [_userNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData * daTa = [_passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        NSString * userPwd = [daTa base64EncodedStringWithOptions:0];
        NSString * strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.user.verify&v=1.0&format=json&locale=zh_CN&client=iPhone&userName=%@&userPwd=%@", _userNameTextField.text, userPwd];
        [NetWorking netWorkingWithUrl:strUrl identification:login];
    }
}
/**
 * 登录密码确认结束
 **/
- (void)loginRequestDataEnd:(id)sender
{
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }
    else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberInfo"];
                kDataPersistence([dic objectForKey:@"userId"], @"memberId");
                kDataPersistence(_userNameTextField.text, @"userName");
                kDataPersistence(_passwordTextField.text, @"userPassword");
                [self getMemberInfomation];
            }else{
                [SharedHandle sharedPromptBox:@"密码或账号错误"];
                NSLog(@"%@",[dic objectForKey:@"resultCode"]);
                }
            }
        }
}
- (void)getMemberInfomation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMemberInfomationEnd:) name:memberInfomationData object:nil];
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.user.member.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:urlStr identification:memberInfomationData];
}
- (void)getMemberInfomationEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:memberInfomationData object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            //NSLog(@"dic === %@", dic);
            kDataPersistence([dic objectForKey:@"memberDetail"], @"memberInfo");
            [self.navigationController popViewControllerAnimated:YES];
            
                   NSString * memberInfo = kGetData(@"memberInfo");
                      NSLog(@" _memberInfo === %@", memberInfo);
        }
    }
    
}

#pragma mark - 加载控件
/**
 *创建控件
 **/
- (void)loadControl
{
    UIView * view = [self viewWithFrame:self.view.frame action:nil];
    if (![kGetData(@"userName") isEqualToString:@""]) {
        _userNameTextField.text = kGetData(@"userName");
    }
    [self.view addSubview:view];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidden = YES;
    _activityIndicatorView.frame = self.view.frame;
    [self.view addSubview:_activityIndicatorView];
}
#pragma mark - 方法
#pragma mark - 注册方法
- (void)registerViewcontroller
{
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
}
#pragma mark - 创建控件
- (UIView *)viewWithFrame:(CGRect)frame action:(SEL)action
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeTheKeyboard)];
    [view addGestureRecognizer:tap];
    view.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:nil];
    imageView.frame = CGRectMake(0, 64, kScreenBounds.size.width, 80);
    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:@"beijing.png"];
    [view addSubview:imageView];
    _userNameTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(0, kSetFrameY(imageView), kScreenBounds.size.width, 40) placeholder:@"请输入用户名" title:@"账号:" secureTextEntry:NO target:self];
    [view addSubview:_userNameTextField];
    
    _passwordTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(0, kSetFrameY(_userNameTextField) + 1.0, kScreenBounds.size.width, 40) placeholder:@"请输入密码" title:@"密码:" secureTextEntry:YES target:self];
    [view addSubview:_passwordTextField];
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, kSetFrameY(_passwordTextField) + 30, kScreenBounds.size.width - 40, 35);
    loginButton.backgroundColor = [UIColor redColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginRequestData) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [view addSubview:loginButton];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(loginButton.frame.origin.x, kSetFrameY(loginButton) + 10, 120, 30)];
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    //[registerButton setBackgroundColor:[UIColor yellowColor]];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerViewcontroller) forControlEvents:UIControlEventTouchUpInside];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
   
    [view addSubview:registerButton];
    
    UIButton *findPassword = [[UIButton alloc] initWithFrame:CGRectMake(kSetFrameX(registerButton) + 80, registerButton.frame.origin.y, 80, 30)];
    //findPassword.backgroundColor = [UIColor redColor];
    [findPassword setTitle:@"找回密码" forState:UIControlStateNormal];
    findPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [findPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [findPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    findPassword.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [view addSubview:findPassword];
    
    return view;
}
- (void)findPassword
{
    [self.navigationController pushViewController:[[FindPasswordViewController alloc] init] animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)takeTheKeyboard
{
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
