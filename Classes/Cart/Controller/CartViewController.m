//
//  CartViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CartViewController.h"
#import "SharedHandle.h"
#import "CartTableViewCell.h"
#import "NetWorking.h"
#import "RDVTabBarController.h"
#import "ClearView.h"
#import "MJRefresh.h"
static NSString *cartData = @"cartData";
static NSString *deleteShopCart = @"deleteShopCart";
@interface CartViewController ()
{
    UITableView *_tableView;
    NSArray     *_dataArray;
    RDVTabBarController *_rdvTabBarController;
    ClearView   *_clearView;
    NSMutableArray *_clearArray;
    NSMutableArray *_deleteArray;
    NSMutableArray *_selectArray;
    UIImageView    *_imageView;
}
@end

@implementation CartViewController
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"购物车";
    _clearArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    _deleteArray = [NSMutableArray array];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteShopCart)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"shanchu-grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(deleteShopCart)];
    [self loadControl];
    [self cartRequestData];
}
#pragma mark - 下拉刷新
- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(cartRequestData)];
}
#pragma mark - Delete shopping cart of goods
- (void)deleteShopCart
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.cart.item.del&v=1.0&format=json&locale=zh_CN&client=iPhone&cartItemDelArray=%@", [self wrapTheString]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShopCartEnd:) name:deleteShopCart object:nil];
    [NetWorking netWorkingWithUrl:urlStr identification:deleteShopCart];
}
- (void)deleteShopCartEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deleteShopCart object:nil];
    [_selectArray removeAllObjects];
    [self cartRequestData];
}
- (NSString *)wrapTheString
{
    NSMutableArray *cartArray = [NSMutableArray array];
    [_deleteArray removeObjectsInArray:_clearArray];
    for (NSDictionary *shopdic in _deleteArray) {
        NSString *cartId = [shopdic objectForKey:@"cid"];
        NSDictionary *cartIdDic = @{@"cartItemId":cartId};
        [cartArray addObject:cartIdDic];
    }
    NSDictionary *jsonDic = @{@"cartItemDelList":cartArray};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kGetData(@"memberId")) {
        [self setupRefresh];
    }
    _rdvTabBarController = [self rdv_tabBarController];
    CGFloat hight = 49;
    if (_rdvTabBarController.tabBarHidden && _isPush) {
        hight = 49;
    }else{
        hight = 49 * 2;
        [_rdvTabBarController setTabBarHidden:NO animated:YES];
    }
    _tableView.frame = CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height - hight);
    _clearView.frame = CGRectMake(0, kSetFrameY(_tableView), kScreenBounds.size.width, 49);
    _clearView.hidden = YES;
    [self loadSumData];
}
- (void)cartRequestData
{
    if (kGetData(@"memberId")) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartRequestDataEnd:) name:cartData object:nil];
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.cart.item.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:urlStr identification:cartData];
    }else{
        [_tableView headerEndRefreshing];
    }
}
- (void)cartRequestDataEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cartData object:nil];
    [_tableView headerEndRefreshing];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
                _dataArray = [dic objectForKey:@"cartItem"];
                if (_dataArray != NULL && _dataArray.count != 0) {
                    [_clearArray setArray:_dataArray];
                    [_deleteArray addObjectsFromArray:_clearArray];
                    [self loadSumData];
                    _imageView.hidden = YES;
                }else{
                    _imageView.hidden = NO;
                    [SharedHandle sharedPromptBox:@"您的购物车还没有商品呀"];
                    _clearView.hidden = YES;
//                    _imageView.hidden = YES;
                }
                [_tableView reloadData];
            }
        }
    }
}
- (void)loadSumData
{
    _clearView.numberLabel.text = [NSString stringWithFormat:@"%.0f", [self calculateNumberOrPrice:@"quantity"]];
    _clearView.sumPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self calculateNumberOrPrice:@"price"]];
    [_clearView.clearButton setTitle:[NSString stringWithFormat:@"结算(%@)", _clearView.numberLabel.text] forState:UIControlStateNormal];
    if (_clearArray.count == 0) {
        _clearView.hidden = YES;
    }else{
        _clearView.hidden = NO;
    }
}
- (CGFloat)calculateNumberOrPrice:(id)sender
{
    CGFloat sum=0;
    for (NSDictionary *dic in _clearArray) {
        if ([sender isEqualToString:@"quantity"]){
        sum += [[dic objectForKey:sender] floatValue];
        }else if ([sender isEqualToString:@"price"]){
            sum += [[dic objectForKey:@"quantity"] floatValue] * [[dic objectForKey:@"price"] floatValue];
        }
    }
    return sum;
}
#pragma mark - 加载控件
- (void)loadControl{
    _tableView = [SharedHandle sharedWithTableViewFrame:self.view.frame target:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _clearView = [[ClearView alloc] initWithFrame:CGRectZero target:self];
    [self.view addSubview:_clearView];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouwuche.png"]];
    _imageView.frame = CGRectMake(40, 80, kScreenBounds.size.width - 80, 200);
        //_imageView.backgroundColor = [UIColor yellowColor];
        //_imageView.center = _tableView.center;
    [_tableView addSubview:_imageView];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell *cartCell = (CartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([_selectArray containsObject:indexPath]) {
            //cartCell.IDImageView.backgroundColor = [UIColor yellowColor];
        cartCell.IDImageView.image = [UIImage imageNamed:@"duihao-red.png"];
        [_selectArray removeObject:indexPath];
        [_clearArray addObject:_dataArray[indexPath.row]];
    }else{
        [_selectArray addObject:indexPath];
        [_clearArray removeObject:_dataArray[indexPath.row]];
            //cartCell.IDImageView.backgroundColor = [UIColor grayColor];
        cartCell.IDImageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }
        //[self loadSumData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier target:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.dataDic = _dataArray[indexPath.row];
    if ([_selectArray containsObject:indexPath]) {
            //cell.IDImageView.backgroundColor = [UIColor grayColor];
        cell.IDImageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }else{
            //cell.IDImageView.backgroundColor = [UIColor yellowColor];
        cell.IDImageView.image = [UIImage imageNamed:@"duihao-red.png"];
    }
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
