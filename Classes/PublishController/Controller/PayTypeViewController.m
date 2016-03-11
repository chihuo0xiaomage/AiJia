//
//  PayTypeViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "PayTypeViewController.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "PayTypeSelectView.h"
#import "ClearViewController.h"
static NSString *const getTime = @"getTime";
@interface PayTypeViewController ()
{
    UIColor *_color;
    NSMutableArray *_selectPayArray;
    NSMutableArray *_deliveryArray;
    UIView *_payType;
    UIView *_distributionType;
    NSString *_title1;
    NSString *_title2;
    UIView   *_timeView;
    UIView   *_addressView;
    PayTypeSelectView *_payTypeSelectView;
    NSArray  *_dateArray;
    NSMutableArray  *_setDateArray;
    ClearViewController *_clearViewController;
    BOOL      _selectArrdress;
    NSArray  *_takeAddressArray;
}
@end

@implementation PayTypeViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getTime object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"选择支付及配送方式";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfoDataEnd:) name:getTime object:nil];
    _setDateArray = [NSMutableArray array];
//    _clearViewController = self.navigationController.viewControllers[1];
    _payType = [self viewWithFrame:CGRectMake(0, 64, kScreenBounds.size.width, 90) Title:@"支付方式" title1:@"在线支付" title2:@"货到付款"];
    _title1 = @"在线支付";
    _selectPayArray = [NSMutableArray arrayWithArray:[_payType subviews]];
    [_selectPayArray removeObjectAtIndex:0];
    [self.view addSubview:_payType];
    
    _distributionType = [self viewWithFrame:CGRectMake(0, kSetFrameY(_payType) + 10, kScreenBounds.size.width, 90) Title:@"配送方式" title1:@"卖家配送" title2:@"上门自提"];
        //_distributionType.backgroundColor = [UIColor yellowColor];
    _title2 = @"卖家配送";
    _deliveryArray = [NSMutableArray arrayWithArray:[_distributionType subviews]];
    [_deliveryArray removeObjectAtIndex:0];
    [self.view addSubview:_distributionType];
    
    _timeView = [self viewWithFrame:CGRectMake(0, kSetFrameY(_distributionType) + 20, kScreenBounds.size.width, 60) action:@selector(setTime) title:@"自提时间"];
    _timeView.hidden = YES;
        //NSLog(@"%f", _timeView.frame.origin.y);
    [self.view addSubview:_timeView];
    
    _addressView = [self viewWithFrame:CGRectMake(0, kSetFrameY(_timeView), kScreenBounds.size.width, 40) action:@selector(setAddress) title:@"自提地点"];
    _addressView.hidden = YES;
    [self.view addSubview:_addressView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(15, kSetFrameY(_addressView) + 20, kScreenBounds.size.width - 30, 39);
    [button addTarget:self action:@selector(selectTheResults) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _payTypeSelectView = [[PayTypeSelectView alloc] initWithFrame:self.view.frame target:self];
    _payTypeSelectView.hidden = YES;
    [self.view addSubview:_payTypeSelectView];
    [self getInfoData];
}
//- (void)setDate
//{
//    
//}
- (void)getInfoData
{
    NSString * strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.selfgetarea.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone"];
    [NetWorking netWorkingWithUrl:strUrl identification:getTime];
}
- (void)getInfoDataEnd:(id)sender
{
        //NSLog(@"%@", [[[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil] objectForKey:@"selfgetList"][0] objectForKey:@"name"]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
//            UIButton *button = [[_addressView subviews] lastObject];
//            NSLog(@"dic = %@", dic);
//            [button setTitle:[[[dic objectForKey:@"selfgetList"] firstObject] objectForKey:@"name"] forState:UIControlStateNormal];
//            [_setDateArray removeAllObjects];
////            _setDateArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"selfgetList"]];
//            [_setDateArray addObjectsFromArray:[dic objectForKey:@"selfgetList"]];
            _takeAddressArray = [dic objectForKey:@"selfgetList"];
            
            }
    }
}
/**
 *
 **/
- (void)selectTheResults
{
    _label.text = [NSString stringWithFormat:@"%@  %@", _title1, _title2];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)viewWithFrame:(CGRect)frame Title:(NSString *)title title1:(NSString *)title1 title2:(NSString *)title2
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    label.text = title;
    [view addSubview:label];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(label.frame.origin.x, kSetFrameY(label)+10, 140, 50)];
    button1.layer.borderWidth = 1.0;
    button1.layer.borderColor = [UIColor redColor].CGColor;
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 setTitle:title1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(exchangeColor:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(kSetFrameX(button1) + 10, button1.frame.origin.y, 140, 50)];
    button2.layer.borderWidth = 1.0;
    button2.layer.borderColor = [UIColor redColor].CGColor;
    [button2 setTitle:title2 forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button2.layer.borderWidth = 1.0;
    button2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [button2 addTarget:self action:@selector(exchangeColor:) forControlEvents:UIControlEventTouchUpInside];
    button2.tintColor = [UIColor yellowColor];
    [view addSubview:button2];
    
    return view;
}
- (void)exchangeColor:(UIButton *)btn
{
    UIView * view = [btn superview];
    if (view == _payType) {
        if (btn.layer.borderColor != [UIColor redColor].CGColor) {
            _title1 = btn.titleLabel.text;
            btn.layer.borderColor = [UIColor redColor].CGColor;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            for (UIButton *button in _selectPayArray) {
                if (button != btn) {
                    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
            }
        }
    }else if (view == _distributionType){
        if ([btn.titleLabel.text isEqualToString:@"上门自提"]) {
            [self theDoorToThe];
        }else{
            [self noTheDoorToThe];
        }
        if (btn.layer.borderColor != [UIColor redColor].CGColor) {
            _title2 = btn.titleLabel.text;
            btn.layer.borderColor = [UIColor redColor].CGColor;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            for (UIButton *button in _deliveryArray) {
                if (button != btn) {
                    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
            }
        }
    }
}
- (void)theDoorToThe
{
        //NSLog(@"上门自提");
    _timeView.hidden = NO;
    _addressView.hidden = NO;
}
- (void)noTheDoorToThe
{
    _timeView.hidden = YES;
    _addressView.hidden = YES;
    _clearViewController.selfgetTime = @"";
}
- (UIView *)viewWithFrame:(CGRect)frame action:(SEL)action title:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    label.text = title;
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(kSetFrameX(label), label.frame.origin.y, kScreenBounds.size.width - 20 - label.bounds.size.width,  40);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
- (void)setTime
{
        //NSLog(@"设置时间");
    _selectArrdress = NO;
    [_setDateArray removeAllObjects];
    _dateArray = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSCalendarUnitWeekday;
//    NSDate *nowDate = [NSDate date];
        //NSLog(@"%@", nowDate);
        //NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
        //NSLog(@"%f",timeZoneOffset/60.0/60.0);
    
        //nowDate = [nowDate dateByAddingTimeInterval:timeZoneOffset];
        //NSLog(@"%@", nowDate);
//    comps = [calendar components:unitFlags fromDate:nowDate];
        //NSInteger result = [comps weekday] - 1;
        //NSLog(@"result = %d", result);
//    for (NSInteger indexPath = 0; indexPath < 5; indexPath++) {
//        [_setDateArray addObject:_dateArray[result]];
//        result ++;
//        if (result == 7) {
//            result = 0;
//        }
//    }
    [_setDateArray addObjectsFromArray:_dateArray];
    if (_setDateArray.count != 0) {
        [_payTypeSelectView.tableView reloadData];
        _payTypeSelectView.hidden = NO;
    }
}
- (void)setAddress
{
        //NSLog(@"设置地点");
        //NSLog(@"%d", _selectArrdress);
        //NSLog(@"%@", _takeAddressArray);
    _selectArrdress = YES;
    [_setDateArray removeAllObjects];
    [_setDateArray addObjectsFromArray:_takeAddressArray];
    _payTypeSelectView.hidden = NO;
    [_payTypeSelectView.tableView reloadData];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_selectArrdress) {
        /**选择自提的地点**/
        UIButton *button = [[_addressView subviews] lastObject];
        [button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _clearViewController.selfgetAreaName = cell.textLabel.text;
            //_clearViewController.selfgetAreaName = @"aaaaaaaaaaaaaaaaaaaaaa";

    }else{
        /**选择自提的时间**/
        UIButton *button = [[_timeView subviews] lastObject];
        [button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _clearViewController.selfgetTime = cell.textLabel.text;
    }
        //NSLog(@"%@", _clearViewController);
    
        //NSLog(@"%@", cell.textLabel.text);
    _payTypeSelectView.hidden = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _setDateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
    }
    if (_selectArrdress) {
        cell.textLabel.text = [_setDateArray[indexPath.row] objectForKey:@"name"];
    }else{
        cell.textLabel.text = _setDateArray[indexPath.row];
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
