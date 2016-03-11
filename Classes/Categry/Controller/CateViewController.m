    //
    //  CateViewController.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-1.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //

#import "CateViewController.h"
#import "SharedHandle.h"
#import "NetWorking.h"
#import "CateCollectionViewCell.h"
#import "HeadCollectionReusableView.h"
#import "CateSmallTitleData.h"
#import "RDVTabBarController.h"
#import "CateListViewController.h"
static NSString * const cateBigTitle = @"cateBigTitle";
static NSString * const cateSmallTitle = @"cateSmallTitle";
@interface CateViewController ()
{
    UITableView      *_tabelView;
    UICollectionView *_collectionView;
    NSArray          *_bigTitleArray;
    NSMutableArray   *_shopArray;
    NSArray          *_shopTitleArray;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation CateViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cateBigTitle object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cateSmallTitle object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        //使用通知回调数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateRequestBigTitleEnd:) name:cateBigTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateReuqestSmallTitleEnd:) name:cateSmallTitle object:nil];
    _shopArray = [NSMutableArray array];
    [self loadControl];
    [self cateRequestBigTitle];
        // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
#pragma mark - 网络请求
- (void)cateRequestBigTitle
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.catelogy.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&catelogId=0&isIcon=false&isDescription=false"];
    [NetWorking netWorkingWithUrl:urlStr identification:cateBigTitle];
}
- (void)cateRequestBigTitleEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        _bigTitleArray = [dic objectForKey:@"catelogs"];
        if (_bigTitleArray != nil && _bigTitleArray != NULL) {
            [self cateReuqestSmallTitle:[_bigTitleArray[0] objectForKey:@"cid"]];
            [_tabelView reloadData];
        }
    }
}
- (void)cateReuqestSmallTitle:(NSString *)parentId
{
    if (parentId != nil && ![parentId  isEqual:@""]) {
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.product.catelogy.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone&ParentId=%@", parentId];
        [NetWorking netWorkingWithUrl:urlStr identification:cateSmallTitle];
    }
}
- (void)cateReuqestSmallTitleEnd:(id)sender
{
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.hidesWhenStopped = YES;
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else {
        NSDictionary *shopDic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        _shopTitleArray = [shopDic objectForKey:@"catelogDetail"];
        [_shopArray removeAllObjects];
       
            
               for (NSDictionary * titleDic in _shopTitleArray) {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in [titleDic objectForKey:@"grandList"]) {
                CateSmallTitleData *smallModel = [[CateSmallTitleData alloc] initWithSmallData:dic];
                [array addObject:smallModel];
            }
            [_shopArray addObject:array];
        }
       
        
        [_collectionView reloadData];
    }
}
#pragma mark - 添加控件
- (void)loadControl
{
    _tabelView = [SharedHandle sharedWithTableViewFrame:CGRectMake(0, 0, 110, kScreenBounds.size.height - 49) target:self];
    _tabelView.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    [self.view addSubview:_tabelView];
    
    _collectionView = [self collectionViewWithFrame:CGRectMake(_tabelView.frame.size.width, 64, kScreenBounds.size.width - _tabelView.bounds.size.width, kScreenBounds.size.height - 49 - 64) layout:[self setLayoutWithItemSize:CGSizeMake(60, 60)]];
    [self.view addSubview:_collectionView];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectMake(0, 0, _collectionView.bounds.size.width, _collectionView.bounds.size.height);
    _activityIndicatorView.center = CGPointMake(_collectionView.bounds.size.width / 2, _collectionView.bounds.size.height / 2);
        //_activityIndicatorView.backgroundColor = [UIColor redColor];
    _activityIndicatorView.hidden = YES;
    [_collectionView addSubview:_activityIndicatorView];
}
#pragma mark - 创建控件
- (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout
{
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView setDelegate:(id<UICollectionViewDelegate>)self];
    [collectionView setDataSource:(id<UICollectionViewDataSource>)self];
    [collectionView registerClass:[CateCollectionViewCell class] forCellWithReuseIdentifier:@"CateCell"];
    [collectionView registerClass:[HeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    collectionView.backgroundColor = [UIColor clearColor];
    return collectionView;
}
- (UICollectionViewFlowLayout *)setLayoutWithItemSize:(CGSize)itemSize
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    return layout;
}
#pragma mark - Delegate
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(210, 20);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeadCollectionReusableView * headerView = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    headerView.backgroundColor = kRGBA(240.0, 240.0, 240.0, 1.0);
    headerView.label.text = [_shopTitleArray[indexPath.section] objectForKey:@"name"];
    return headerView;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateListViewController * cateListViewController = [[CateListViewController alloc] init] ;
    cateListViewController.catelogId = ((CateSmallTitleData *)_shopArray[indexPath.section][indexPath.row]).shopID;
    cateListViewController.title = ((CateSmallTitleData *)_shopArray[indexPath.section][indexPath.row]).shopName;
    [self.navigationController pushViewController:cateListViewController animated:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_shopTitleArray count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_shopArray[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateCollectionViewCell * cateCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CateCell" forIndexPath:indexPath];
    cateCell.smallTitleModel = _shopArray[indexPath.section][indexPath.row];
    return cateCell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bigTitleArray != nil && _bigTitleArray != NULL) {
        [self cateReuqestSmallTitle:[_bigTitleArray[indexPath.row] objectForKey:@"cid"]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bigTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = kRGBA(236, 236, 236, 1.0);
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = view;
    }
    cell.textLabel.text = [_bigTitleArray[indexPath.row] objectForKey:@"name"];
    return cell;
}
#pragma mark - 动画方法
- (void)catalogOfAnimationEffects:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexpath
{
    if (indexpath.row > 0 && indexpath.row < _bigTitleArray.count - 9) {
        [tableView setContentOffset:CGPointMake(0, indexpath.row * 50 - 64) animated:YES];
    }else if (indexpath.row != 0){
        [tableView setContentOffset:CGPointMake(0, (_bigTitleArray.count - 9) * 50 - 64) animated:YES];
    }
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
