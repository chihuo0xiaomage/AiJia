//
//  UseECardViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "UseECardViewController.h"
#import "RDVTabBarController.h"
#import "QRCodeGenerator.h"
#import "NetWorking.h"
#import "SharedHandle.h"
static NSString *ECardNo = @"ECardNo";
@interface UseECardViewController ()
{
    UIImageView *_imageView;
    NSDictionary*_memberInfo;
    NSTimer     *_timer;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation UseECardViewController
- (void)dealloc
{
        //NSLog(@"-----------");
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
        //self.title = @"电子卡(红包)";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useECardRequestEnd:) name:ECardNo object:nil];
    _memberInfo = kGetData(@"memberInfo");
    [self loadControl];
    [self useECardRequest];
    _timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(useECardRequest) userInfo:nil repeats:YES];
        //NSLog(@"%@", _memberInfo);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 加载控件
- (void)loadControl
{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = self.view.center;
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, kScreenBounds.size.width - 30, 40)];
        //label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"扫描下方二维码就可以使用%@", self.title];
    label.font = [UIFont systemFontOfSize:16.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, 240, 240)];
        //_imageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_imageView];
}
#pragma mark - 获取动态卡号
- (void)useECardRequest
{
    NSLog(@"%@", self.cardNo);
    NSString * urlStr = [NSString stringWithFormat: @"appKey=00001&method=wop.wscard.cardDynamic&v=1.0&format=json&locale=zh_CN&client=iPhone&cardNo=%@&uniqueCode=35701",self.cardNo];
    [NetWorking netWorkingWithUrl:urlStr identification:ECardNo];
}
- (void)useECardRequestEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    _activityIndicatorView.hidesWhenStopped = YES;
    [_activityIndicatorView stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ECardNo object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
                //NSLog(@"=============%@", [dic objectForKey:@"cardNo"]);
            _imageView.image = [QRCodeGenerator qrImageForString:[dic objectForKey:@"cardNo"] imageSize:_imageView.bounds.size.width];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
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
