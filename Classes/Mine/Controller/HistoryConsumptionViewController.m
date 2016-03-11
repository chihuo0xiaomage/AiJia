//
//  HistoryConsumptionViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "HistoryConsumptionViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "HistoryTableViewCell.h"
#import "NetWorking.h"
static NSString *const historyData = @"historyData";
@interface HistoryConsumptionViewController ()
{
    UITableView *_tableView;
    NSDictionary*_memberInfo;
    NSArray     *_historyDataArray;
}
@end

@implementation HistoryConsumptionViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:historyData object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费历史";
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyRequestDataEnd:) name:historyData object:nil];
    _memberInfo = kGetData(@"memberInfo");
    [self loadControl];
    [self historyRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 网络请求
- (void)historyRequestData
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.wscard.consum&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&cardNo=%@&pageSize=20&pageNumber=1&startTime=%@&endTime=%@", [_memberInfo objectForKey:@"cardNo"], [self getStartTime], [self getSystemTime:nil]];
    [NetWorking netWorkingWithUrl:urlStr identification:historyData];
}
- (void)historyRequestDataEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            //NSLog(@"%@", dic);
        if (resultCode == 0) {
            _historyDataArray = [dic objectForKey:@"consumList"];
            [_tableView reloadData];
        }
    }
}
- (NSString *)getStartTime
{
    NSMutableString *startTime = [self getSystemTime:nil];
    NSInteger year = [[startTime substringToIndex:4] integerValue];
    NSInteger month = [[startTime substringWithRange:NSMakeRange(5, 2)] integerValue];
    month = month - 1;

    if (month == 0) {
        year--;
        month = 12;
    }
    [startTime replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%ld", (long)year]];
    [startTime replaceCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld", (long)month]];
    return startTime;
}
    //时间请求
- (NSMutableString *)getSystemTime:(NSString *)time
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return [NSMutableString stringWithFormat:@"%@", currentDateStr];
}
#pragma mark - 加载控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    }
    [[cell subviews][1]  setText:[_memberInfo objectForKey:@"cardNo"]];
    cell.historyData = _historyDataArray[indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
