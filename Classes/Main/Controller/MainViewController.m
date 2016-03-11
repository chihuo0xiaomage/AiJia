//
//  MainViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "MainViewController.h"
#import "SharedHandle.h"
#import "AddTableViewCell.h"
#import "RdTableViewCell.h"
#import "NetWorking.h"
#import "SharedHandle.h"
//#import "HodRdTableViewCell.h"
#import "ListViewController.h"
#import "RDVTabBarController.h"
#import "DetailViewController.h"
#import "SearchShopViewController.h"
#import "SeckillViewController.h"
#import "MJRefresh.h"
static NSString * const CarouselImage = @"CarouselImage";
static NSString * const HodRecommend = @"HodRecommend";
@interface MainViewController ()
{
    UITableView *_tableView;
    NSArray     *_carouselArray;
    NSArray     *_recommendArray;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation MainViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CarouselImage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HodRecommend object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainRequestCarouselImageEnd:) name:CarouselImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainRequestRecommendEnd:) name:HodRecommend object:nil];
    [self setNavigationBarSearchBar];
    [self loadControl];
    [self mainRequestCarouselImage];
    [self mainRequestRecommend];
    [self setupRefresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
#pragma mark - 下拉刷新
- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(mainRequestRecommend)];
}
#pragma mark - 开始网络请求
    // 请求轮播图片
- (void)mainRequestCarouselImage
{
        //NSLog(@"----------1");
    NSString *urlStr = @"appKey=00001&method=wop.homepage.carousel.get&v=1.0&format=json&locale=zh_CN&client=iPhone";
    [NetWorking netWorkingWithUrl:urlStr identification:CarouselImage];
}
- (void)mainRequestCarouselImageEnd:(id)sender
{
        //NSLog(@"==========%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            _carouselArray = [dic objectForKey:@"caroursels"];
            [_tableView reloadData];
        }
    }
}
- (void)mainRequestRecommend
{
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.hidden = NO;
    NSString *urlStr =  @"appKey=00001&method=wop.product.search.goods.byRecommend.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&type=5&pageSize=10&pageNumber=1";
    [NetWorking netWorkingWithUrl:urlStr identification:HodRecommend];
}
- (void)mainRequestRecommendEnd:(id)sender
{
    [_tableView headerEndRefreshing];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            _recommendArray = [dic objectForKey:@"goods"];
            [_tableView reloadData];
        }
    }
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.hidden = YES;
}
#pragma mark - 创建控件 TableView
- (void)loadControl
{
    _tableView = [SharedHandle sharedWithTableViewFrame:CGRectMake(kFrameX, kFrameY, kBoundWidth, kBoundHeight - 49) target:self];
    [self.view addSubview:_tableView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = _tableView.frame;
    _activityIndicatorView.center = _tableView.center;
    _activityIndicatorView.color = [UIColor lightGrayColor];
//    [_activityIndicatorView startAnimating];
    [_tableView addSubview:_activityIndicatorView];
}

#pragma mark - 设置搜索框
//- (void)setNavigationBarSearchBar{
//    [SharedHandle setNagetionBar:self imageName:@"aijia.png" action:nil];
//}

- (void)setNavigationBarSearchBar{
    [SharedHandle setNagetionBar:self imageName:@"" action:nil];
}

//#pragma mark - UITextFieldDelegate
////- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
////{
////    NSLog(@"----------");
////}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"%ld", indexPath.row);
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[[SeckillViewController alloc] init] animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 160;
            break;
        case 1:
            return 80;
        case 2:
            return 100;
//        case 3:
//            return 426;
        default:
            break;
    }
    return 0.0;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [self createAds:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 1:
            return [self createRecommend:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 2:
            return [self createTimeLimit:tableView cellForRewAtIndexPath:indexPath];
            break;
//        case 3:
//            return [self createHodRd:tableView cellForRowAtIndexPath:indexPath];
        default:
            break;
    }
    static NSString * CellIdentfier = @"Adcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
- (UITableViewCell *)createAds:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * AdCellIdentfier = @"adCell";
    AddTableViewCell * adCell = [tableView dequeueReusableCellWithIdentifier:AdCellIdentfier];
    if (adCell == nil) {
        adCell = [[AddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AdCellIdentfier];
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (adCell != nil && adCell != NULL) {
        adCell.carourselsArray = _carouselArray;
    }
    return adCell;
}
- (UITableViewCell *)createRecommend:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RdCellIdentfier = @"RdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RdCellIdentfier];
    if (!cell) {
        cell = [[RdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RdCellIdentfier target:self action:@selector(RdMethod:)];
        cell.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (UITableViewCell *)createTimeLimit:(UITableView *)tableView cellForRewAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * limitCellIdentfier = @"limitCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:limitCellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:limitCellIdentfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [UIImage imageNamed:@"miaosha.png"];
    return cell;
}
/*
- (UITableViewCell * )createHodRd:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * HodRdCellIdentfier = @"HodRdCell";
    HodRdTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HodRdCellIdentfier];
    if (!cell) {
        cell = [[HodRdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HodRdCellIdentfier target:self action:@selector(HodRdMethod:)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    }
    if (_recommendArray != nil && _recommendArray != NULL) {
        cell.dataArray = _recommendArray;
    }
    return cell;
}
*/
#pragma mark - Push
- (void)RdMethod:(UITapGestureRecognizer *)tap{
    UIImageView * imageView = (UIImageView *)tap.view;
    NSArray * imageUrlArray = @[@"newProduct.png", @"boutique.png", @"huddle.png"];
    NSString *type;
    if ([imageView.image isEqual:[UIImage imageNamed:imageUrlArray[0]]]) {
        type = @"1";
    }else if ([imageView.image isEqual:[UIImage imageNamed:imageUrlArray[1]]]){
        type = @"2";
    }else{
        type = @"3";
    }
    ListViewController * listViewController = [[ListViewController alloc] init];
    listViewController.url = [NSString stringWithFormat:@"appKey=00001&method=wop.product.search.goods.byRecommend.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&type=%@&pageSize=10&pageNumber=1", type];

        //listViewController.type = type;
    [self.navigationController pushViewController:listViewController animated:YES];
}
- (void)HodRdMethod:(UITapGestureRecognizer *)tap{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    NSArray *array = [[[[[tap view] subviews] lastObject] text] componentsSeparatedByString:@"="];
    detailViewController.goodID = [array firstObject];
    NSLog(@"%@", detailViewController.goodID);
    detailViewController.image = [[[[tap view] subviews] firstObject] image];
////    NSLog(@"%@", [tap.view subviews]);
    detailViewController.imageUrl = [array lastObject];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.navigationController pushViewController:[[SearchShopViewController alloc] init] animated:YES];
    return [textField resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        //[[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
