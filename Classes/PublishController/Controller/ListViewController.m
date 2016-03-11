//
//  ListViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "ListViewController.h"
#import "RDVTabBarController.h"
#import "ListCollectionViewCell.h"
#import "FooterView.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
static NSString * const Recommend = @"Recommend";
@interface ListViewController ()
{
    UICollectionView *_collectionView;
    NSMutableArray   *_receiveArray;
    NSMutableArray   *_selectArray;
    FooterView       *_footerView;
    NSInteger         _pageNumber;
}
@property(nonatomic, assign)BOOL header;
@property(nonatomic, assign)BOOL footer;
@end

@implementation ListViewController
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"锦悦城网上商城";
    _selectArray = [NSMutableArray array];
    _pageNumber = 1;
    _receiveArray = [NSMutableArray array];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self loadControl];
    [self listRequestData];
    [self headerRefreshing];
    [self footerRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark - 下拉刷新
- (void)headerRefreshing
{
    __block ListViewController *mySelf = self;
    [_collectionView addHeaderWithCallback:^{
            //NSLog(@"===========23");
        mySelf.header = YES;
        mySelf.footer = NO;
        [mySelf setupRefresh];
    }];
}
#pragma mark - 上拉加载更多
- (void)footerRefreshing
{
    __block ListViewController *mySelf = self;
    [_collectionView addFooterWithCallback:^{
            //NSLog(@"--------");
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
        [self listRequestData];
    }
    if (_footer) {
        _pageNumber ++;
        [self listRequestData];
    }

}
#pragma mark 开始进行网络数据的请求
- (void)listRequestData
{
//    NSString *urlStr =  [NSString stringWithFormat:@"appKey=00001&method=wop.product.search.goods.byRecommend.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&type=%@&pageSize=10&pageNumber=1", _type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listRequestDataEnd:) name:Recommend object:nil];
    _url = [_url stringByReplacingCharactersInRange:NSMakeRange(_url.length - 1, 1) withString:[NSString stringWithFormat:@"%ld", (long)_pageNumber]];
       //NSLog(@"%@", _url);
    [NetWorking netWorkingWithUrl:_url identification:Recommend];
}
- (void)listRequestDataEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Recommend object:nil];
        //NSLog(@"================1");
    if (_header) {
            //NSLog(@"================");
        [_collectionView headerEndRefreshing];
    }else if (_footer){
        [_collectionView footerEndRefreshing];
    }
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
            //NSLog(@"dic =======%@", dic);
        if (dic != nil && dic != NULL) {
            if (_pageNumber == 1) {
                [_receiveArray removeAllObjects];
            }
            NSArray *array = [dic objectForKey:@"goods"];
            if (array.count != 0) {
                _footerView.hidden = NO;
                [_receiveArray addObjectsFromArray:array];
                [_collectionView reloadData];
            }
//            }else{
//                [[[UIAlertView alloc] initWithTitle:@"网络不稳定,请您稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            }
        }
    }
}
#pragma mark - 加载控件
- (void)loadControl
{
    _collectionView = [self collectionViewWithFrame:CGRectMake(0, 0, kBoundWidth, kBoundHeight - 49) layout:[self setLayoutWithItemSize:CGSizeMake(150, 180)]];
    [self.view addSubview:_collectionView];
    
    _footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, kScreenBounds.size.height - 49, 320, 49) target:self];
    _footerView.shopIdArray = [NSMutableArray array];
    _footerView.hidden = YES;
    [self.view addSubview:_footerView];
}
#pragma mark - 创建控件
- (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout
{
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView setDelegate:(id<UICollectionViewDelegate>)self];
    [collectionView setDataSource:(id<UICollectionViewDataSource>)self];
    [collectionView registerClass:[ListCollectionViewCell class] forCellWithReuseIdentifier:@"listCell"];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ListCollectionViewCell *listCell = (ListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_selectArray containsObject:indexPath]) {
        [_selectArray removeObject:indexPath];
        [_footerView.shopIdArray removeObject:[_receiveArray[indexPath.item] objectForKey:@"gid"]];
            //listCell.IDimageView.backgroundColor = [UIColor grayColor];
        listCell.IDimageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }else{
        [_selectArray addObject:indexPath];
        [_footerView.shopIdArray addObject:[_receiveArray[indexPath.item] objectForKey:@"gid"]];
            //listCell.IDimageView.backgroundColor = [UIColor yellowColor];
        listCell.IDimageView.image = [UIImage imageNamed:@"duihao-red.png"];
    }

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _receiveArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCollectionViewCell *listCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    listCollectionViewCell.backgroundColor = [UIColor whiteColor];
    [listCollectionViewCell.moreInfoButton addTarget:self action:@selector(isShowMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    listCollectionViewCell.dic = _receiveArray[indexPath.item];
    if ([_selectArray containsObject:indexPath]) {
            //listCollectionViewCell.IDimageView.backgroundColor = [UIColor yellowColor];
        listCollectionViewCell.IDimageView.image = [UIImage imageNamed:@"duihao-red.png"];
    }else{
            //listCollectionViewCell.IDimageView.backgroundColor = [UIColor grayColor];
        listCollectionViewCell.IDimageView.image = [UIImage imageNamed:@"duihao-grey.png"];
    }
    return listCollectionViewCell;
}
- (void)isShowMoreInfo:(UIButton *)btn
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(ListCollectionViewCell *)[btn superview]];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.goodID = [_receiveArray[indexPath.row] objectForKey:@"gid"];
    detailViewController.imageUrl = [_receiveArray[indexPath.row] objectForKey:@"image"];
    detailViewController.image = [[[btn superview] subviews][2] image];
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

@end
