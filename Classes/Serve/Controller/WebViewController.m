//
//  WebViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "WebViewController.h"
#import "RDVTabBarController.h"
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"服务中心"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadControl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)loadControl
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL * url = [NSURL URLWithString:_webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
