//
//  AppDelegate.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-1.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "MainViewController.h"
#import "CateViewController.h"
#import "CartViewController.h"
//#import "ServeViewController.h"
#import "MineViewController.h"
#import "SharedHandle.h"
#import "RDVTabBarItem.h"
#import "NetWorking.h"
static NSString *const infomationData = @"infomationData";
@interface AppDelegate ()
{
    NSDictionary *_memberInfo;
    NSString     *_memberId;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.rootViewController = [self selectRootViewController];
        //[SharedHandle sharedPromptBox:@"Very Good"];
    [self customizeTabBarForController:(RDVTabBarController *)self.window.rootViewController];
    [self setNavigationBarColor];
    [self getInfomation];
    return YES;
}
- (void)getInfomation
{
    _memberInfo = kGetData(@"memberInfo");
    _memberId = kGetData(@"memberId");
    if (_memberId) {
        if ([_memberInfo count] == 0) {
           [self getMemberInfomation];
        }
    }

}
- (void)getMemberInfomation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMemberInfomationEnd:) name:infomationData object:nil];
    NSString * urlStr = [NSString stringWithFormat:@"appKey=00001&method=wop.user.member.detail.get&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@", kGetData(@"memberId")];
    [NetWorking netWorkingWithUrl:urlStr identification:infomationData];
}
- (void)getMemberInfomationEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:infomationData object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            kDataPersistence([dic objectForKey:@"memberDetail"], @"memberInfo");
            _memberInfo = kGetData(@"memberInfo");
        }
    }

}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *selectImageArray = @[@"main_select.png", @"cate_select.png", @"cart_select.png", @"mine_select.png"];
    NSArray *normalImageArray = @[@"main.png", @"cate.png", @"cart.png", @"mine.png"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:selectImageArray[index]];
        UIImage *unselectedimage = [UIImage imageNamed:normalImageArray[index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}
- (void)setNavigationBarColor
{
    [[UINavigationBar appearance] setBarTintColor:kRGBA(211, 43, 61, 1.0)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
}
- (UIViewController *)selectRootViewController{
    UIViewController * mainViewController = [[MainViewController alloc] init];
    UINavigationController * mainNC = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    mainViewController.title = @"首页";
    
    UIViewController * cateViewController = [[CateViewController alloc] init];
    UINavigationController * cateNC = [[UINavigationController alloc] initWithRootViewController:cateViewController];
    cateViewController.title = @"分类";

    UIViewController * cartViewController = [[CartViewController alloc] init];
    UINavigationController * cartNC = [[UINavigationController alloc] initWithRootViewController:cartViewController];
    cartViewController.title = @"购物车";

    UIViewController * mineViewController = [[MineViewController alloc] init];
    UINavigationController * mineNC = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    mineViewController.title = @"我的";
    
    RDVTabBarController * tabBarViewController = [[RDVTabBarController alloc] init];
    tabBarViewController.tabBar.translucent = NO;
    [tabBarViewController setViewControllers:@[mainNC, cateNC, cartNC,mineNC]];
    self.viewController = tabBarViewController;
    return _viewController;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
