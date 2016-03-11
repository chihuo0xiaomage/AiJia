//
//  CateListViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-6.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "CateListViewController.h"
#import "RDVTabBarController.h"
#import "CateListCollectionViewCell.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "FooterView.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
static NSString *const cateList = @"cateList";
@interface CateListViewController ()
{
    UICollectionView *_collectionView;
    NSMutableArray   *_dataArray;
    FooterView       *_footerView;
    NSMutableArray   *_selectArray;
    NSInteger         _pageNumber;
}
@property(nonatomic, assign)BOOL header;
@property(nonatomic, assign)BOOL footer;
@end

@implementation CateListViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cateList object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateListRequestEnd:) name:cateList object:nil];
    _pageNumber = 1;
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    [self loadControl];
    [self cateListReuqest];
    [self headerRefreshing];
    [self footerRefreshing];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 下拉刷新
- (void)headerRefreshing
{
    __block CateListViewController *mySelf = self;
    [_collectionView addHeaderWithCallback:^{
        mySelf.header = YES;
        mySelf.footer = NO;
        [mySelf setupRefresh];
    }];
}
#pragma mark - 上拉加载更多
- (void)footerRefreshing
{
    __block CateListViewController *mySelf = self;
    [_collectionView addFooterWithCallback:^{
        mySelf.footer = YES;
        mySelf.header = NO;
        [mySelf setupRefresh];
    }];
}

#pragma mark -
- (void)setupRefresh
{
    if (_header) {
        _pageNumber = 1;
        [self cateListReuqest];
    }
    if (_footer) {
        _pageNumber ++;
        [self cateListReuqest];
    }
}

#pragma mark - 开始网络请求
- (void)cateListReuqest
{
    NSString * strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.search.goods.byCatelog.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&pageNumber=%ld&pageSize=10&catelogId=%@", (long)_pageNumber,_catelogId];
    [NetWorking netWorkingWithUrl:strUrl identification:cateList];
}
- (void)cateListRequestEnd:(id)sender
{
    if (_header) {
        [_collectionView headerEndRefreshing];
    }else if (_footer){
        [_collectionView footerEndRefreshing];
    }
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
                if (_pageNumber == 1) {
                    [_dataArray removeAllObjects];
                }
                NSArray *array = [dic objectForKey:@"goods"];
                if (array.count) {
                    [_dataArray addObjectsFromArray:array];
                    [_collectionView reloadData];
                }
                
            }
        }
    }
}
#pragma mark - 加载控件
- (void)loadControl
{
    _collectionView = [self collectionViewWithFrame:CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height - 50) layout:[self setLayoutWithItemSize:CGSizeMake(150, 180)]];
    [self.view addSubview:_collectionView];
    
    _footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, kScreenBounds.size.height - 49, kScreenBounds.size.width, 49) target:self];
    _footerView.shopIdArray = [NSMutableArray array];
    [self.view addSubview:_footerView];
}
- (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout
{
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView setDelegate:(id<UICollectionViewDelegate>)self];
    [collectionView setDataSource:(id<UICollectionViewDataSource>)self];
    [collectionView registerClass:[CateListCollectionViewCell class] forCellWithReuseIdentifier:@"listCell"];
        //    [collectionView registerClass:[HeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    collectionView.backgroundColor = [UIColor clearColor];
    return collectionView;
}
- (UICollectionViewFlowLayout *)setLayoutWithItemSize:(CGSize)itemSize
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(0, 7.50, 0, 7.50);
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    return layout;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateListCollectionViewCell *cateListCell = (CateListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_selectArray containsObject:indexPath]) {
        [_selectArray removeObject:indexPath];
        [_footerView.shopIdArray removeObject:[_dataArray[indexPath.item] objectForKey:@"gid"]];
            //cateListCell.IDImageView.backgroundColor = [UIColor grayColor];
        cateListCell.IDImageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }else{
        [_selectArray addObject:indexPath];
        [_footerView.shopIdArray addObject:[_dataArray[indexPath.item] objectForKey:@"gid"]];
            //cateListCell.IDImageView.backgroundColor = [UIColor redColor];
        cateListCell.IDImageView.image = [UIImage imageNamed:@"duihao-red.png"];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateListCollectionViewCell *cateListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    cateListCell.backgroundColor = [UIColor whiteColor];
    [cateListCell.moreInfo addTarget:self action:@selector(showMoreShopInfo:) forControlEvents:UIControlEventTouchUpInside];
    cateListCell.dataDic = _dataArray[indexPath.item];
    if ([_selectArray containsObject:indexPath]) {
            //cateListCell.IDImageView.backgroundColor = [UIColor redColor];
        cateListCell.IDImageView.image = [UIImage imageNamed:@"duihao-red.png"];
    }else{
            //cateListCell.IDImageView.backgroundColor = [UIColor grayColor];
        cateListCell.IDImageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }
    return cateListCell;
}
- (void)showMoreShopInfo:(UIButton *)btn
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(CateListCollectionViewCell *)[btn superview]];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.image = [[[btn superview] subviews][2] image];
    detailViewController.imageUrl = [_dataArray[indexPath.item] objectForKey:@"image"];
    detailViewController.goodID = [_dataArray[indexPath.item] objectForKey:@"gid"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
