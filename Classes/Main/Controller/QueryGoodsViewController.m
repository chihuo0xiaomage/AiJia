//
//  QueryGoodsViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-3-11.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "QueryGoodsViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "QueryGoodsTableViewCell.h"
#import "DetailViewController.h"
static NSString *const searchData = @"searchData";
@interface QueryGoodsViewController ()
{
    UITableView *_tableView;
    NSArray     *_searchArray;
}
@end

@implementation QueryGoodsViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:searchData object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataRequestEnd:) name:searchData object:nil];
    [self loadControl];
    [self searchDataRequest];
    // Do any additional setup after loading the view.
}
#pragma mark - searchData
- (void)searchDataRequest
{
    [NetWorking netWorkingWithUrl:_strUrl identification:searchData];
}
- (void)searchDataRequestEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
           _searchArray = [dic objectForKey:@"goodsList"];
          
            if (_searchArray.count == 0) {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"未查到该商品" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
            }else{
            [_tableView reloadData];
            }
        }
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 加载控件
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryGoodsTableViewCell *cell = (QueryGoodsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.image = cell.aImageView.image;
    NSDictionary *dic = _searchArray[indexPath.row];
    detailViewController.imageUrl = [dic objectForKey:@"image"];
    detailViewController.goodID = [dic objectForKey:@"gid"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    QueryGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil) {
        cell = [[QueryGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.searchDic = _searchArray[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
