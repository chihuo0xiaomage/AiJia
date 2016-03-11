//
//  RedConsumptionViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-26.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "RedConsumptionViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "RedTableViewCell.h"
static NSString *const ecardConsumption = @"ecardConsumption";
@interface RedConsumptionViewController ()
{
    UITableView *_tableView;
    NSDictionary*_memberInfo;
    NSArray     *_ecardArray;
}
@end

@implementation RedConsumptionViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ecardConsumption object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"电子卡(红包)消费";
    _memberInfo = kGetData(@"memberInfo");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardConsumptionHistoryEnd:) name:ecardConsumption object:nil];
    [self loadControl];
    [self cardConsumptionHistory];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - Query an e-card consumption history
- (void)cardConsumptionHistory
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.wscard.consum&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=39602&cardNo=%@&pageSize=20&pageNumber=1&startTime=%@&endTime=%@", [_memberInfo objectForKey:@"ecard"], [self getStartTime], [self getSystemTime:nil]];
    [NetWorking netWorkingWithUrl:urlStr identification:ecardConsumption];
}
- (void)cardConsumptionHistoryEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _ecardArray = [dic objectForKey:@"consumList"];
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
- (NSMutableString *)getSystemTime:(NSString *)time
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return [NSMutableString stringWithFormat:@"%@", currentDateStr];
}
#pragma mark - Load Control
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ecardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfeir = @"cell";
    RedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfeir];
    if (!cell) {
        cell = [[RedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfeir];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        //NSLog(@"%@", _ecardArray[indexPath.row]);
    cell.redDic = _ecardArray[indexPath.row];
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
