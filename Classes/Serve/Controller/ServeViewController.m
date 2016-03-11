//
//  ServeViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ServeViewController.h"
#import "SharedHandle.h"
#import "WebViewController.h"
@interface ServeViewController ()
{
    NSArray     *_imageArray;
    NSArray     *_titleArray;
    NSArray     *_httpUrlArray;
    UITableView *_tableView;
}
@end

@implementation ServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _httpUrlArray = @[@"http://mobile.wp99.cn/vipeng/web/weix/go_wether.do",@"http://mobile.wp99.cn/vipeng/web/weix/go_fanyi.do",@"http://m.kuaidi100.com"];
    _titleArray = @[@"天气神", @"翻译通", @"快递100"];
        //_httpUrlArray = @[];
    [self loadControl];
    
}
#pragma mark - 添加控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.tableFooterView = [[UIView alloc] init];
        // NSLog(@"%@", _tableView);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *web = [[WebViewController alloc] init];
    web.webUrl = _httpUrlArray[indexPath.row];
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentfier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
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
