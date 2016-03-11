//
//  DetailViewController.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-3.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "DetailViewController.h"
#import "FooterView.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "UIImageView+WebCache.h"
#import "RDVTabBarController.h"
static NSString * const Detail = @"Detail";
@interface DetailViewController ()
{
    UIImageView *_imageView;
    UILabel     *_nameLabel;
    UILabel     *_originalPriceLabel;
    UILabel     *_nowPriceLabel;
    UILabel     *_detailLabel;
    UIView      *_lineView;
    FooterView  *_footerView;
    CGFloat      _height;
}
@end

@implementation DetailViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Detail object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kRGBA(236.0, 236.0, 236.0, 1.0)];
    self.title = @"商品详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailRequestDataEnd:) name:Detail object:nil];
    [self loadControl];
    [self detailRequestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
#pragma mark 开始网络请求
-(void)detailRequestData{
    NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.goods.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone&goodsId=%@&isIntroduction=true", _goodID];
    [NetWorking netWorkingWithUrl:strUrl identification:Detail];
}
- (void)detailRequestDataEnd:(id)sender{
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender   object]];
    }else{
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        if (dic != nil && dic != NULL) {
            NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
            if (resultCode == 0) {
                [self loadData:[dic objectForKey:@"goodsDetail"]];
            }
        }
    }
}
- (void)loadData:(id)sender
{
        //NSLog(@"%@", sender);
    _imageView.image = _image;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameLabel.text = [sender objectForKey:@"name"];
    _originalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[sender objectForKey:@"marketPrice"] floatValue]];
    CGFloat width = [SharedHandle widthLabelWithFont:_originalPriceLabel.font sendString:_originalPriceLabel.text height:_originalPriceLabel.bounds.size.height] + 60;
    _lineView.frame = CGRectMake(_originalPriceLabel.frame.origin.x - 40, kSetFrameY(_originalPriceLabel) - _originalPriceLabel.bounds.size.height/2, width, 1.0);
    _nowPriceLabel.text =[NSString stringWithFormat:@"￥%.2f", [[sender objectForKey:@"price"] floatValue]];
    NSMutableArray * shopArray = [NSMutableArray arrayWithObject:[sender objectForKey:@"gid"]];
    [_footerView.buyNowArray removeAllObjects];
    if (_footerView.buyNowArray == nil) {
        _footerView.buyNowArray = [NSMutableArray array];
    }
    NSDictionary *dic = @{@"gid":[sender objectForKey:@"gid"], @"image":_imageUrl, @"name":[sender objectForKey:@"name"], @"price":[NSString stringWithFormat:@"%.2f", [[sender objectForKey:@"price"] floatValue]], @"quantity":@"1"};
    _footerView.shopIdArray = shopArray;
    [_footerView.buyNowArray addObject:dic];
//    _footerView.shopNumber = 1;
}
#pragma mark - 加载控件
- (void)loadControl
{
    UIView * view = [self LTViewWithFrame:self.view.frame action:nil];
    [self.view addSubview:view];
}
#pragma mark - 创建控件
- (UIView *)LTViewWithFrame:(CGRect)frame action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kRGBA(236.0, 236.0, 236.0, 1.0);
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenBounds.size.width, kScreenBounds.size.height/2 - 64)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSetFrameY(_imageView), kScreenBounds.size.width, 40)];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.textColor = [UIColor orangeColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_nameLabel];
    
    UILabel *originalName = [[UILabel alloc] initWithFrame:CGRectMake(0, kSetFrameY(_nameLabel) + 1, 140, 20)];
    originalName.backgroundColor = [UIColor whiteColor];
    originalName.textAlignment = NSTextAlignmentRight;
    originalName.text = @"原价:";
    originalName.textColor = [UIColor lightGrayColor];
    [view addSubview: originalName];
    
    _originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(originalName), kSetFrameY(_nameLabel) + 1, kScreenBounds.size.width - originalName.bounds.size.width, 20)];
        //_originalPriceLabel.text = @"12.90";
    _originalPriceLabel.backgroundColor = [UIColor whiteColor];
    _originalPriceLabel.textColor = [UIColor lightGrayColor];
    [view addSubview:_originalPriceLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:_lineView];
    
    UILabel *nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSetFrameY(originalName), originalName.bounds.size.width, 20)];
    nowLabel.text = @"促销价:";
    nowLabel.backgroundColor = [UIColor whiteColor];
    nowLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:nowLabel];
    
    _nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSetFrameX(nowLabel), nowLabel.frame.origin.y, _originalPriceLabel.bounds.size.width, 20)];
    _nowPriceLabel.backgroundColor = [UIColor whiteColor];
        //_nowPriceLabel.text = @"12.90";
    _nowPriceLabel.textColor = [UIColor redColor];
    [view addSubview:_nowPriceLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSetFrameY(nowLabel) + 1, kScreenBounds.size.width, 30)];
    _detailLabel.backgroundColor = [UIColor whiteColor];
    [view addSubview:_detailLabel];
    
    _footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, kSetFrameY(_detailLabel) + 20, kScreenBounds.size.width, 49) target:self];
    _footerView.backgroundColor = [UIColor clearColor];
    [view addSubview:_footerView];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
