//
//  Ane-cardViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-26.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "Ane-cardViewController.h"
#import "RDVTabBarController.h"
#import "NetWorking.h"
#import "SharedHandle.h"
static NSString *const redBalance = @"redBalance";
@interface Ane_cardViewController ()
{
    UILabel *_balance;
    NSDictionary *_memberInfo;
}
@end

@implementation Ane_cardViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:redBalance object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子卡(红包)余额";
    self.view.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anECardRequestDataEnd:) name:redBalance object:nil];
    _memberInfo = kGetData(@"memberInfo");
    [self loadControl];
    [self anECardRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - Load control
- (void)loadControl
{
    UIView *view = [self viewWithFrame:CGRectMake(0, 64, kScreenBounds.size.width, 60)];
    [self.view addSubview:view];
}
#pragma mark - networking request
- (void)anECardRequestData
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.payment.cardyue.getlyt&v=1.0&format=json&locale=zh_CN&client=iPhone&cardNo=%@&uniqueCode=39602&shopNo=1000&posNo=01&workNo=1004", [_memberInfo objectForKey:@"ecard"]];
    [NetWorking netWorkingWithUrl:urlStr identification:redBalance];
}
- (void)anECardRequestDataEnd:(id)sender
{
    
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            _balance.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"totalMoney"]];
        }
    }
}
- (UIView *)viewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 20)];
    label.text = @"余额:";
    [view addSubview:label];
    
    _balance = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(label) + 10, label.frame.origin.y, 120, 20)];
    _balance.textColor = [UIColor orangeColor];
        //_balance.text = @"20元";
    [view addSubview:_balance];
    
    return view;
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
