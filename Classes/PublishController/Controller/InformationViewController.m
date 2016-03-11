//
//  InformationViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "InformationViewController.h"
#import "SharedHandle.h"
#import "AddressViewController.h"
#import "NetWorking.h"
#import "InfoTableViewCell.h"
static NSString *const addressInfo = @"addressInfo";
@interface InformationViewController ()
{
    UITableView *_tableView;
    NSArray     *_addressArray;
}
@end

@implementation InformationViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:addressInfo object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"收货人信息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressRequestDataEnd:) name:addressInfo object:nil];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建地址" style:UIBarButtonItemStyleDone target:self action:@selector(newShippingAddress)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"xinjianlianxiren.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(newShippingAddress)];
    [self loadControl];
    [self addressRequestData];
}
- (void)newShippingAddress
{
    AddressViewController *addressViewController = [[AddressViewController alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _addressArray) {
        [array addObject:[dic objectForKey:@"rId"]];
    }
    addressViewController.title = @"新建地址";
    addressViewController.addressId = array;
    [self.navigationController pushViewController:addressViewController animated:YES];
}
#pragma mark - Network request
- (void)addressRequestData
{
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.receiver.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:strUrl identification:addressInfo];
}
- (void)addressRequestDataEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
            //NSLog(@"%@", dic);
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _addressArray = [dic objectForKey:@"receivers"];
            [_tableView reloadData];
        }
    }
}
#pragma mark - The load Control
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.addressDic = _addressArray[indexPath.row];
    [cell.editorButton addTarget:self action:@selector(willEditorAddress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)willEditorAddress:(UIButton *)btn
{
    InfoTableViewCell *cell = (InfoTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    AddressViewController *addressViewController = [[AddressViewController alloc] init];
    addressViewController.addressDic = _addressArray[indexPath.row];
    addressViewController.title = @"修改地址";
    [self.navigationController pushViewController:addressViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
