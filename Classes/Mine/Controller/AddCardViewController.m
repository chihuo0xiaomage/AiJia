//
//  AddCardViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-10.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "AddCardViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "MineViewController.h"
static NSString *const addCard = @"addCard";
@interface AddCardViewController ()
{
    UITextField *_cardNoTextField;
    UITextField *_cardPasswordTextField;
    NSDictionary*_memberInfo;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation AddCardViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:addCard object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"卡绑定";
    _memberInfo = kGetData(@"memberInfo");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCardToUserReuqestEnd:) name:addCard object:nil];
    [self loadControl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_cardNoTextField.frame.origin.x, kSetFrameY(_cardPasswordTextField) + 20, _cardPasswordTextField.bounds.size.width, 35);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"绑定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [button addTarget:self action:@selector(addCardToUserReuqest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.frame = self.view.frame;
    _activityIndicatorView.hidden = YES;
    [self.view addSubview:_activityIndicatorView];
    // Do any additional setup after loading the view.
}
#pragma mark - 开始网络请求
- (void)addCardToUserReuqest
{
    if ([_cardNoTextField.text isEqualToString:@""] || [_cardPasswordTextField.text isEqualToString:@""]) {
        [SharedHandle sharedPromptBox:@"请您先完善信息"];
    }else{
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.wscard.binding&v=1.0&format=json&locale=zh_CN&client=iPhone&id=%@&cardNo=%@&cardPwd=%@&uniqueCode=35701", [_memberInfo objectForKey:@"id"], _cardNoTextField.text, _cardPasswordTextField.text];
      [NetWorking netWorkingWithUrl:urlStr identification:addCard];
    }
}
- (void)addCardToUserReuqestEnd:(id)sender
{
        //NSLog(@"-----------%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView stopAnimating];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberInfo"];
            [self onceGetMemberInfo];
        }else if (resultCode == 29){
            [[[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
- (void)onceGetMemberInfo
{
    [[self.navigationController.viewControllers firstObject] mineGetMemberInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 添加控件
- (void)loadControl
{
    _cardNoTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, kScreenBounds.size.width - 20, 35)];
    _cardNoTextField.backgroundColor = [UIColor whiteColor];
    _cardNoTextField.placeholder = @"卡号";
    _cardNoTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_cardNoTextField setDelegate:(id<UITextFieldDelegate>)self];
    [self.view addSubview:_cardNoTextField];
    
    _cardPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_cardNoTextField.frame.origin.x, kSetFrameY(_cardNoTextField) + 10, _cardNoTextField.bounds.size.width, 35)];
    _cardPasswordTextField.backgroundColor = [UIColor whiteColor];
    _cardPasswordTextField.placeholder = @"密码";
    _cardPasswordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _cardPasswordTextField.secureTextEntry = YES;
    [_cardPasswordTextField setDelegate:(id<UITextFieldDelegate>)self];
    [self.view addSubview:_cardPasswordTextField];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_cardNoTextField resignFirstResponder];
    [_cardPasswordTextField resignFirstResponder];
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
