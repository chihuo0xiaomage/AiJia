//
//  ChangUserPasswordViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ChangUserPasswordViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
static NSString *const changLoginPassword = @"changLoginPassword";
@interface ChangUserPasswordViewController ()
{
    UITextField *_oldTextField;
    UITextField *_newTextField;
    UITextField *_onceNewTextField;
    NSDictionary*_memberInfo;
}
@end

@implementation ChangUserPasswordViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changLoginPassword object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"账户安全";
    _memberInfo = kGetData(@"memberInfo");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changUserPasswordEnd:) name:changLoginPassword object:nil];
    [self loadControl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_onceNewTextField.frame.origin.x, kSetFrameY(_onceNewTextField) + 20, _onceNewTextField.bounds.size.width, _onceNewTextField.bounds.size.height);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [button addTarget:self action:@selector(changUserPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
#pragma mark - 修改密码
- (void)changUserPassword
{
    if ([_newTextField.text isEqualToString:_onceNewTextField.text] && ![_newTextField.text isEqualToString:@""] && ![_oldTextField.text isEqualToString:@""] && ![_onceNewTextField.text isEqualToString:@""]) {
        SharedHandle *sharedHandle = [SharedHandle sharedHandle];
        NSString *oldPassword =[self ReplacetheSpecialCharacters: [sharedHandle base64:_oldTextField.text]];
        NSString *newPassword =[self ReplacetheSpecialCharacters: [sharedHandle base64:_newTextField.text]];
        NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.member.passwd.mod&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@&oldPasswd=%@&newPasswd=%@&uniqueCode=35701", [_memberInfo objectForKey:@"id"],[oldPassword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], newPassword];
//        [NetWorking netWorkingWithUrl:urlStr identification:changLoginPassword];
        [NetWorking netWorkingWithUrl:HTTP body:urlStr identification:changLoginPassword];
    }else{
        [SharedHandle sharedPromptBox:@"您的信息填写有误, 请再次确认"];
    }

}
- (void)changUserPasswordEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败,请您再次尝试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}
- (NSString *)ReplacetheSpecialCharacters:(NSString *)sender
{
    NSString *replace1 = [sender stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString *replace2 = [replace1 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *replace3 = [replace2 stringByReplacingOccurrencesOfString:@"=" withString:@"."];
    return replace3;
}
#pragma mark - 加载控件
- (void)loadControl
{
    _oldTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(15, 80, kScreenBounds.size.width - 30, 35) placeholder:@"原始密码" title:@"密码:" secureTextEntry:YES target:self];
    _oldTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_oldTextField];
    
    _newTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_oldTextField.frame.origin.x, kSetFrameY(_oldTextField) + 10, _oldTextField.bounds.size.width, _oldTextField.bounds.size.height) placeholder:@"新密码" title:@"密码:" secureTextEntry:YES target:self];
    _newTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_newTextField];
    
    _onceNewTextField = [SharedHandle sharedWithTextFieldFrame:CGRectMake(_newTextField.frame.origin.x, kSetFrameY(_newTextField) + 10, _newTextField.bounds.size.width, _newTextField.bounds.size.height) placeholder:@"确认新密码" title:@"密码:" secureTextEntry:YES target:self];
    _onceNewTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_onceNewTextField];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_oldTextField resignFirstResponder];
    [_newTextField resignFirstResponder];
    [_onceNewTextField resignFirstResponder];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
