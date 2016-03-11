    //
    //  MineViewController.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-1.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //
#import "MineViewController.h"
#import "MineCollectionViewCell.h"
#import "BalanceIntegralViewController.h"
#import "HistoryConsumptionViewController.h"
#import "AmountChangeViewController.h"
#import "PasswordChangeViewController.h"
#import "CardUnbundlingViewController.h"
#import "MyOrderViewController.h"
#import "MyViewController.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "LoginViewController.h"
#import "ChangUserPasswordViewController.h"
#import "BingCardViewController.h"
#import "RDVTabBarController.h"
static NSString *const getMemberInfo = @"getMemberInfo";
@interface MineViewController ()
{
    NSArray          *_imageNameArray;
    NSArray          *_labelNameArray;
    UICollectionView *_collectionView;
    NSDictionary     *_memberInfo;
    NSString         *_memberId;
}
@end

@implementation MineViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getMemberInfo object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    _memberInfo = kGetData(@"memberInfo");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineGetMemberInfoEnd:) name:getMemberInfo object:nil];
    _memberId = kGetData(@"memberId");
    _labelNameArray = @[@"余额积分", @"消费历史", @"金额变动", @"密码修改", @"会员卡解绑", @"我的订单", @"我的", @"登录密码修改", @"安全退出"];
    _imageNameArray = @[@"Yuejifen.png", @"Xiaofeilishi.png", @"Jinebiandong.png", @"Kamimaxiugai.png", @"Tianzhongxingkajiebang.png", @"Wodedingdan.png", @"Wode.png", @"Denglumimaxiugai.png", @"Tuichu.png"];
    [self loadControl];
    if (_memberId) {
        [self mineGetMemberInfo];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    if (![_memberId isEqualToString:kGetData(@"memberId")] && kGetData(@"memberId")) {
        [self mineGetMemberInfo];
    }
}
#pragma mark - 开始网络请求
- (void)mineGetMemberInfo
{
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.user.member.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:urlStr identification:getMemberInfo];
}
- (void)mineGetMemberInfoEnd:(id)sender
{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
                //NSLog(@"dic === %@", dic);
            kDataPersistence([dic objectForKey:@"memberDetail"], @"memberInfo");
            _memberInfo = kGetData(@"memberInfo");
                //NSLog(@" _memberInfo === %@", _memberInfo);
        }
    }
}
#pragma mark - 加载控件
- (void)loadControl
{
    _collectionView = [self collectionViewWithFrame:self.view.frame layout:[self setLayoutWithItemSize:CGSizeMake(100, 100)]];
    [self.view addSubview:_collectionView];
}
#pragma mark - 创建控件
- (UICollectionView *)collectionViewWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout
{
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView setDelegate:(id<UICollectionViewDelegate>)self];
    [collectionView setDataSource:(id<UICollectionViewDataSource>)self];
    [collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"mineCell"];
        //[collectionView registerClass:[HeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    collectionView.backgroundColor = [UIColor clearColor];
    return collectionView;
}
- (UICollectionViewFlowLayout *)setLayoutWithItemSize:(CGSize)itemSize
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = itemSize;
    layout.sectionInset = UIEdgeInsetsMake(10, 9, 0, 9);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    return layout;
}
- (void)noCardToAddCard
{
    [self.navigationController pushViewController:[[BingCardViewController alloc] init] animated:YES];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"_memberInfo === %@", _memberInfo);
    if (kGetData(@"memberId") && indexPath.row != 8) {
        switch (indexPath.row) {
            case 0:{
                if ([[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
                    [self noCardToAddCard];
                }else{
                    [self.navigationController pushViewController:[[BalanceIntegralViewController alloc] init] animated:YES];
                }
            }
                break;
            case 1:{
                if ([[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
                    [self noCardToAddCard];
                }else{
                    [self.navigationController pushViewController:[[HistoryConsumptionViewController alloc] init] animated:YES];
                }
            }
                break;
            case 2:{
                if ([[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
                    [self noCardToAddCard];
                }else{
                    [self.navigationController pushViewController:[[AmountChangeViewController alloc] init] animated:YES];
                }
            }
                break;
            case 3:{
                if ([[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
                    [self noCardToAddCard];
                }else{
                    [self.navigationController pushViewController:[[PasswordChangeViewController alloc] init] animated:YES];
                }
            }
                
                break;
            case 4:{
                if ([[_memberInfo objectForKey:@"cardNo"] isEqualToString:@""]) {
                    [self noCardToAddCard];
                }else{
                    [self.navigationController pushViewController:[[CardUnbundlingViewController alloc] init] animated:YES];
                }
            }
                
                break;
            case 5:
                [self.navigationController pushViewController:[[MyOrderViewController alloc] init] animated:YES];
                break;
            case 6:
                [self.navigationController pushViewController:[[MyViewController alloc] init] animated:YES];
                break;
            case 7:
                [self.navigationController pushViewController:[[ChangUserPasswordViewController alloc] init] animated:YES];
            default:
                break;
        }
    }else if (indexPath.row == 8){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberInfo"];
        [SharedHandle sharedPromptBox:@"您已经退出"];
    }else{
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}
    //- (void)needViewController:(id)viewController
    //{
    //    [self.navigationController pushViewController:viewController animated:YES];
    //}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell *mineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mineCell" forIndexPath:indexPath];
    mineCell.backgroundColor = [UIColor whiteColor];
    mineCell.labelName = _labelNameArray[indexPath.item];
    mineCell.imageName = _imageNameArray[indexPath.item];
    return mineCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end
