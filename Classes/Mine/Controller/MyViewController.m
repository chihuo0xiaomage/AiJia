//
//  MyViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MyViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "Ane-cardViewController.h"
//#import "RedConsumptionViewController.h"
#import "BingCardViewController.h"
#import "UseECardViewController.h"

//static NSString *const sendRed = @"sendRed";

//static NSString *const getRed = @"getRed";
@interface MyViewController ()
{
    UITableView *_tableView;
    NSArray     *_titleArray;
   // UIAlertView *_sendRedAlertView;
   // UIAlertView *_cardPasswordAlertView;
   // UIAlertView *_getRedAlertView;
   // UITextField *_cardPasswordtextField;
    //UITextField *_phonetextfield;
    UITextField *_amounttextfield;
    NSDictionary*_memberInfo;
    UIAlertView *_bindCardAlertView;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"个人中心";
    _memberInfo = kGetData(@"memberInfo");
        //NSLog(@"_memberInfo = %@", _memberInfo);
   // _titleArray = @[@"", @"发放电子卡", @"领取电子卡", @"电子卡余额", @"电子卡消费历史", @"使用电子卡", @"使用会员卡", @"我的卡包"];
    _titleArray = @[@"",@"我的卡包"];
    [self loadControl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    if (alertView == _sendRedAlertView) {
        if (buttonIndex == 1) {
            if ([_phonetextfield.text isEqualToString:@""] || [_amounttextfield.text isEqualToString:@""]) {
                [SharedHandle sharedPromptBox:@"信息不完整,重新填写"];
            }else{
            _cardPasswordAlertView = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _cardPasswordAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            _cardPasswordtextField = [_cardPasswordAlertView textFieldAtIndex:0];
            _cardPasswordtextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _cardPasswordtextField.placeholder = @"请输入您的卡密码";
            [_cardPasswordAlertView show];
            }
        }
    }else if (alertView == _cardPasswordAlertView){
        if (![_cardPasswordtextField.text isEqualToString:@""]) {
            [self startSendingARedEnvelope];
        }else{
            [SharedHandle sharedPromptBox:@"密码不能为空"];
            [_sendRedAlertView show];
        }
        
    }
     */
    if (alertView == _bindCardAlertView){
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[[BingCardViewController alloc] init] animated:YES];
        }
    }
}
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (alertView == _sendRedAlertView) {
//        [_sendRedAlertView show];
//    }
//}
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (alertView == _sendRedAlertView) {
//        [_sendRedAlertView show];
//    }
//}
#pragma mark - Start sending a red envelope
/*
- (void)startSendingARedEnvelope
{
        //NSLog(@"开始发送红包");
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.hongbao.issue&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&shopNo=1000&posNo=01&workNo=1004&memberId=%@&passwd=%@&receiverMobile=%@&amount=%@", kGetData(@"memberId"), _cardPasswordtextField.text, _phonetextfield.text, _amounttextfield.text];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSendingARedEnvelopeEnd:) name:sendRed object:nil];
    [NetWorking netWorkingWithUrl:urlStr identification:sendRed];
}
- (void)startSendingARedEnvelopeEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sendRed object:nil];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[[UIAlertView alloc] initWithTitle:@"发送成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定, 请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }

}
 */
#pragma mark - To receive a red envelope
/*
- (void)toReceiveARedEnvelope
{
        //NSLog(@"领取红包");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReceiveARedEnvelopeEnd:) name:getRed object:nil];
    NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.receiver.hongbao.get&v=1.0&format=json&locale=zh_CN&client=iPhone&userName=%@&uniqueCode=39602", [_memberInfo objectForKey:@"userName"]];
    [NetWorking netWorkingWithUrl:urlStr identification:getRed];
}
- (void)toReceiveARedEnvelopeEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getRed object:nil];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[[UIAlertView alloc] initWithTitle:@"领取成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else if(resultCode == 32){
            [[[UIAlertView alloc] initWithTitle:@"没有红包可领" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
 */
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.row);
    switch (indexPath.row) {
            /*
        case 1:{
            if ([[_memberInfo objectForKey:@"cardNo"] isEqual:@""]) {
                _bindCardAlertView = [[UIAlertView alloc] initWithTitle:@"请您先去绑卡" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [_bindCardAlertView show];
            }else{
            _sendRedAlertView = [[UIAlertView alloc] initWithTitle:@"发送红包" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _sendRedAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            _phonetextfield = [_sendRedAlertView textFieldAtIndex:0];
            _phonetextfield.placeholder = @"请输入手机号";
            _phonetextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _amounttextfield = [_sendRedAlertView textFieldAtIndex:1];
            _amounttextfield.placeholder = @"请输入金额";
            _amounttextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _amounttextfield.secureTextEntry = NO;
            [_sendRedAlertView show];
            }
        }
            break;
        case 2:{
            [self toReceiveARedEnvelope];
        }
            break;
        case 3:{
            [self.navigationController pushViewController:[[Ane_cardViewController alloc] init] animated:YES];
        }
            break;
        case 4:{
            [self.navigationController pushViewController:[[RedConsumptionViewController alloc] init] animated:YES];
        }
            break;
        case 5:{
            UseECardViewController *eCardVC = [[UseECardViewController alloc] init];
            eCardVC.title = @"电子卡";
            eCardVC.cardNo = [_memberInfo objectForKey:@"ecard"];
            [self.navigationController pushViewController:eCardVC animated:YES];
        }
            break;
            
        case 6:{
            if ([[_memberInfo objectForKey:@"cardNo"] isEqual:@""]){
            [self.navigationController pushViewController:[[BingCardViewController alloc] init] animated:YES];
            }else{
                UseECardViewController *cardNoVC = [[UseECardViewController alloc] init];
                cardNoVC.title = @"会员卡";
                cardNoVC.cardNo = [_memberInfo objectForKey:@"cardNo"];
                [self.navigationController pushViewController:cardNoVC animated:YES];
            }
        }
            break;
             */
        case 1:{
            [self.navigationController pushViewController:[[BingCardViewController alloc] init] animated:YES];
        }
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 44;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _titleArray[indexPath.row];
//        cell.imageView.backgroundColor = [UIColor yellowColor];
    }else{
        UIImageView *view = [[UIImageView alloc] init];
            //view.backgroundColor = [UIColor redColor];
        view.image = [UIImage imageNamed:@"gerenzhongxin.png"];
        cell.backgroundView = view;
        cell.textLabel.text = [NSString stringWithFormat:@"用户:%@", [_memberInfo objectForKey:@"userName"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前卡:%@", [_memberInfo objectForKey:@"cardNo"]];
       
       // cell.imageView.image = [UIImage imageNamed:@"gerenzhongxin-logo.png"];
       
        cell.imageView.image = [UIImage imageNamed:@"Icon-60.png"];
        cell.imageView.layer.cornerRadius = 8.0;
        cell.imageView.layer.masksToBounds = YES;
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
    return cell;
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
