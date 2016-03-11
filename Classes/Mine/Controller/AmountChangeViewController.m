//
//  AmountChangeViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-9.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "AmountChangeViewController.h"
#import "RDVTabBarController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "HistoryTableViewCell.h"
static NSString *const amountData = @"amountData";
@interface AmountChangeViewController ()
{
    UITableView *_tableView;
    NSDictionary*_memberInfo;
    NSArray     *_amountArray;
}
@end

@implementation AmountChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金额变动";
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(amountRequestDataEnd:) name:amountData object:nil];
    _memberInfo = kGetData(@"memberInfo");
    [self loadControl];
    [self amountRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 网络请求
- (void)amountRequestData
{
   NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.wscard.money&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&cardNo=%@&pageSize=20&pageNumber=1&startTime=%@&endTime=%@", [_memberInfo objectForKey:@"cardNo"], [self getStartTime], [self getSystemTime:nil]];
    
    [NetWorking netWorkingWithUrl:urlStr identification:amountData];
}
- (void)amountRequestDataEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _amountArray = [dic objectForKey:@"moneyList"];
            if (_amountArray != nil && _amountArray != NULL && _amountArray.count != 0) {
                [_tableView reloadData];
            }else{
                [SharedHandle sharedPromptBox:@"一个月内没有金额变动"];
            }
        }
    }
}
- (NSString *)getStartTime
{
    NSMutableString *startTime = [self getSystemTime:nil];
    NSInteger year = [[startTime substringToIndex:4] integerValue];
    NSInteger month = [[startTime substringWithRange:NSMakeRange(5, 2)] integerValue];
        //month = 01;
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
    return _amountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    }
    cell.amountData = _amountArray[indexPath.row];
    [[cell subviews][1] setText:[_memberInfo objectForKey:@"cardNo"]];
    
 
    
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
