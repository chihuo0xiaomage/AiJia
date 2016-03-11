//
//  RegisterViewController.h
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-4.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginViewController.h"
@interface RegisterViewController : UIViewController<UIAlertViewDelegate>

@property(strong,nonatomic)UITextField *userName;
@property(strong,nonatomic)UITextField *userPwd;
@property(strong,nonatomic)UITextField *confirmPwd;
@property(strong,nonatomic)UIButton *registUser;

@property(strong,nonatomic)NSDictionary *mdic;
@end
