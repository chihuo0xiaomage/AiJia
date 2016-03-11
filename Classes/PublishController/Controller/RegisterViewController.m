//
//  RegistController.m
//  微朋
//
//  Created by 宝源科技 on 15-4-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

//
//  RegisterViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-4.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "RegisterViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
static NSString *const getMemberId = @"getMemberId";
@interface RegisterViewController ()

@end

@implementation RegisterViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getMemberId object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"快速注册";
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowStartRegisterEnd:) name:getMemberId object:nil];
    [self loadControl];
}
- (void)nowStartRegister
{
    NSData * data = [_userPwd.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString * userPwd = [data base64EncodedStringWithOptions:0];
    NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.user.member.zhuce&v=1.0&format=json&locale=zh_CN&client=iPhone&userName=%@&passwd=%@&uniqueCode=35701", _userName.text, userPwd];
    [NetWorking netWorkingWithUrl:urlStr identification:getMemberId];
    
}
- (void)nowStartRegisterEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
                kDataPersistence([dic objectForKey:@"memberId"], @"memberId");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if (resultCode == 31){
                [SharedHandle sharedPromptBox:@"用户名已经存在，请更换用户名"];
                [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            }
        }
    }
}
#pragma mark - 添加控件

- (void)loadControl{
    
    
        _userName=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/15, self.view.frame.size.height/15+64, self.view.frame.size.width/15*13, self.view.frame.size.height/15)];
        //手机号或
        _userName.placeholder=@"请输入用户名";
        _userName.borderStyle=UITextBorderStyleRoundedRect;
        _userName.keyboardType=UIKeyboardTypeEmailAddress;
        [self.view addSubview:_userName];
    
        _userPwd=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/15, self.view.frame.size.height/15*2+74, self.view.frame.size.width/15*13, self.view.frame.size.height/15)];
        _userPwd.placeholder=@"请输入密码";
        _userPwd.borderStyle=UITextBorderStyleRoundedRect;
        _userPwd.keyboardType=UIKeyboardTypeAlphabet;
        //_userPwd.backgroundColor=[UIColor blueColor];
        [self.view addSubview:_userPwd];
    
        _confirmPwd=[[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/15, self.view.frame.size.height/15*3+84, self.view.frame.size.width/15*13, self.view.frame.size.height/15)];
        _confirmPwd.placeholder=@"请再次输入密码";
        _confirmPwd.borderStyle=UITextBorderStyleRoundedRect;
        _confirmPwd.keyboardType=UIKeyboardTypeAlphabet;
        [self.view addSubview:_confirmPwd];
    
        _registUser=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _registUser.frame=CGRectMake(self.view.frame.size.width/15, self.view.frame.size.height/15*4+94, self.view.frame.size.width/15*13, self.view.frame.size.height/15);
        _registUser.backgroundColor=[UIColor redColor];
        [_registUser setTitle:@"注册" forState:UIControlStateNormal];
    [_registUser addTarget:self action:@selector(nowStartRegister) forControlEvents:UIControlEventTouchUpInside];
        _registUser.layer.masksToBounds=YES;
        _registUser.layer.cornerRadius=10;
        _registUser.tintColor = WHITE;
        
        [self.view addSubview:_registUser];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
