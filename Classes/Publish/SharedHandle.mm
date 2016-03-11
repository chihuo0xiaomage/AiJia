    //
    //  SharedHandle.m
    //  AiJia_2014
    //
    //  Created by 宝源科技 on 15-2-1.
    //  Copyright (c) 2015年 lipengjun. All rights reserved.
    //

#import "SharedHandle.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NetWorking.h"
#import "GTMBase64.h"
#import "MyViewController.h"
//#import "UMSPay_QMJF_KaBase64.h"
//#import "UMSPay_QMJF_iPhone.h"
//银联支付

#import "UPPayPlugin.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#import "BingCardViewController.h"
//static NSString *redPay = @"redPay";
static NSString *cardPay = @"cardPay";
static NSString *bankcardPay = @"bankcardPay";
static NSString *PayData = @"PayData";
static NSString *noticvieBack = @"noticvieBack";
@interface SharedHandle ()<UPPayPluginDelegate>
{
    UIAlertView *_alertView; /**
                              *密码输入提示框
                              **/
    UIAlertView *_isBingCardAlertView;
    UITextField *_passwordTextField;/**
                                     *密码框
                                     */
   // UMSPay_QMJF_KaBase64 *_base64;
                                    /**
                                     *全民付base64加密
                                     **/
    NSURLAuthenticationChallenge * _challenge;
    NSString            * _filePath;
    NSOutputStream      * _fileStream;
    NSURLConnection     * _connection;
    
    NSDictionary        * _paypayDic;
    //UMSPay_QMJF_iPhone  *umspayQMJFVc;

}
@property(nonatomic, strong)UIViewController *viewControllr;
@end

@implementation SharedHandle
static SharedHandle *sharedHandle = nil;
+ (instancetype)sharedHandle
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHandle = [[SharedHandle alloc] init];
    });
    return sharedHandle;
}
#pragma mark - 设置主页面的搜索框
+ (void)setNagetionBar:(id)target imageName:(NSString *)imageName action:(SEL)action
{
    UIViewController * viewController = (UIViewController *)target;
    [SharedHandle setNavigetionItemLeftBarButton:viewController action:nil imageName:imageName];
    [SharedHandle setNavigetionItemRightBarButton:viewController action:action];
    UITextField * searchBox = [SharedHandle textFieldWithFrame:CGRectMake(0, 0,  kScreenBounds.size.width - 120, 30) imageName:@"search.png" target:viewController];
    [viewController.navigationItem setTitleView:searchBox];
}
/**
 *进行UITextField的封装
 **/
+ (UITextField *)textFieldWithFrame:(CGRect)frame imageName:(NSString *)imageName target:(id)target
{
    UIImageView * imageView = [self imageViewWithFrame:CGRectMake(0, 5, 20, 20) imageName:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.returnKeyType = UIReturnKeySearch;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"搜索商品";
    textField.textColor = [UIColor lightGrayColor];
    [textField setDelegate:(id<UITextFieldDelegate>)target];
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}
+ (void)setNavigetionItemLeftBarButton:(UIViewController *)viewController action:(SEL)action imageName:(NSString *)imageName
{
    UIImageView * imageView = [SharedHandle imageViewWithFrame:CGRectMake(0, 0, 30, 30) imageName:imageName];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
}
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = frame;
       //imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}
+ (void)setNavigetionItemRightBarButton:(UIViewController *)viewController action:(SEL)action{
    //scan.png
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:nil action:nil];
}
#pragma mark - return UITableView 控件
+ (UITableView *)sharedWithTableViewFrame:(CGRect)frame target:(id)target
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [tableView setDelegate:(id<UITableViewDelegate>)target];
    [tableView setDataSource:(id<UITableViewDataSource>)target];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return tableView;
}
    //提示框
+ (BOOL)sharedPromptBox:(NSString *)title
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:appDelegate.window.rootViewController.view animated:YES];
    hud.labelText = title;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0;
    hud.labelFont = [UIFont systemFontOfSize:18.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
    return YES;
}
    //动态计算高度
+ (CGFloat)heightLabelWithFont:(UIFont *)font sendString:(NSString *)sendStr width:(CGFloat)width
{
    NSDictionary *textDic = @{font:NSFontAttributeName};
    CGRect textRect = [sendStr boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDic context:nil];
    return textRect.size.height;
}
+ (CGFloat)widthLabelWithFont:(UIFont *)font sendString:(NSString *)sendStr height:(CGFloat)height
{
    NSDictionary *textDic = @{font:NSFontAttributeName};
    CGRect textRect = [sendStr boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDic context:nil];
    return textRect.size.width;
}
+ (UITextField *)sharedWithTextFieldFrame:(CGRect)frame placeholder:(NSString *)placeholder title:(NSString *)title secureTextEntry:(BOOL)secureTextEntry target:(id)target
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    label.text = title;
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;
    textField.secureTextEntry = secureTextEntry;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setDelegate:target];
    return textField;
}
    //验证手机号码
//+ (BOOL)validateMobile:(NSString *)mobile
//{
//        //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}

#pragma mark - Choice of payment
/**
 *选择支付方式
 **/
+ (void)choiceOfPayment:(NSInteger)buttonIndex target:(id)target
{
    SharedHandle *sharedHandle = [SharedHandle sharedHandle];
        //    [sharedHandle redEnvelopeToPay];
    sharedHandle.viewControllr = (UIViewController *)target;
//    NSLog(@"target === %@", target);
//    NSLog(@"buttonIndex = %ld", (long)buttonIndex);
//    NSLog(@"sharedHandle.payDataDic = %@", sharedHandle.payDataDic);
    switch (buttonIndex) {
        case 1:
            [sharedHandle jointCardToPay];
            break;
        case 2:
            [sharedHandle thePayPay];
            break;
//        case 3:
//            [sharedHandle redEnvelopeToPay];
        default:
            break;
    }
}

#pragma mark - Joint card to pay 进行密码的确认
/**
 *会员卡-------支付-----
 **/
- (void)jointCardToPay
{
        //NSLog(@"----------卡支付");
    if ([[_payDataDic objectForKey:@"cardNo"] isEqualToString:@""]) {
        _isBingCardAlertView = [[UIAlertView alloc] initWithTitle:@"您还没有绑卡\n是否绑卡" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [_isBingCardAlertView show];
    }else{
        _alertView = [[UIAlertView alloc] initWithTitle:@"会员卡密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        _passwordTextField = [_alertView textFieldAtIndex:0];
        _passwordTextField.placeholder = @"请输入卡密码";
        [_alertView show];
    }
}
#pragma mark UIAlertViewDelegate
/**
 *弹出密码输入框
 **/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alertView) {
        if (buttonIndex == 1) {
            [self isPasswordCorrect];
        }
    }else if (alertView == _isBingCardAlertView){
        if (buttonIndex == 1) {
            [_viewControllr.navigationController pushViewController:[[BingCardViewController alloc] init] animated:YES];
        }
    }
}
#pragma mark - 对会员卡密码进行base64加密
- (NSString *) base64:(NSString *)password
{
    NSData * data = [password dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}
/**
 *确认密码是否正确
 **/
- (void)isPasswordCorrect
{
    NSString *passwordbase64 = [self base64:_passwordTextField.text];
   // NSString * strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.wscard.pay.bytzx&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701& shopNo=1000&posNo=01&workNo=1004&memberId=%@&cardNo=%@&orderSn=%@&passwd=%@&type=0", kGetData(@"memberId"), [_payDataDic objectForKey:@"cardNo"], [_payDataDic objectForKey:@"order"], passwordbase64];
    NSString * strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.wscard.pay.bytzx&v=1.0&format=json&locale=zh_CN&client=iPhone&uniqueCode=35701&memberId=%@&cardNo=%@&orderSn=%@&passwd=%@&type=0", kGetData(@"memberId"), [_payDataDic objectForKey:@"cardNo"], [_payDataDic objectForKey:@"order"], passwordbase64];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isPasswordCorrectEnd:) name:cardPay object:nil];
    [NetWorking netWorkingWithUrl:strUrl identification:cardPay];
        //NSLog(@"strUrl == %@", strUrl);
}
    //卡支付结果
- (void)isPasswordCorrectEnd:(id)sender
{
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cardPay object:nil];
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        [[[UIAlertView alloc] initWithTitle:[dic objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        if (resultCode == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(updateMyOrder)]) {
                [_delegate updateMyOrder];
            }
        }
    }
}

#pragma mark - The pay pay 银联卡支付
/**
 *银联卡-------支付-----
 **/
    //首先进行网络接口的拼接 然后再进行封装
- (void)thePayPay
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPayPayEnd:) name:PayData object:nil];
    //等待后台提供全渠道的支付接口
    NSString *strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.pay.byunionpay&v=1.0&format=json&locale=zh_CN&client=iPhone&orderSn=%@", [_payDataDic objectForKey:@"order"]];
        //NSLog(@"strUrl ==== %@", strUrl);
    [NetWorking netWorkingWithUrl:strUrl identification:PayData];
   }
- (void)requestPayPayEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PayData object:nil];
        //NSLog(@"====================获取%@" ,[NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        _paypayDic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
       
     
        if (_paypayDic.count != 0) {
            
            [UPPayPlugin startPay:[_paypayDic objectForKey:@"transId"] mode:kMode_Development viewController:_viewControllr delegate:self];
         
     
           
        }
    }
}
/**
 *开始调用银联卡接口
 **/

#pragma mark Delegate
- (void)UPPayPluginResult:(NSString *)result{
    //success、fail、cancel,分别代表:支付成功、支付失败、用户取消支付
    if ([result isEqualToString:@"success"]) {
        [self noticeTheBackground];
        [[[UIAlertView alloc] initWithTitle:@"交易成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
        
    }else if ([result isEqualToString:@"fail"]){
    [[[UIAlertView alloc] initWithTitle:@"交易失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    
    }else{
        [[[UIAlertView alloc] initWithTitle:@"交易取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
/**
 *交易成功通知后台
 **/
- (void)noticeTheBackground
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeTheBackgroundEnd:) name:noticvieBack object:nil];
    NSString *strUrl = [NSString stringWithFormat: @"appKey=00001&method=wop.product.order.paylog.modity&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@&orderSn=%@&uniqueCode=35701&", kGetData(@"memberId"), [_paypayDic objectForKey:@"orderSn"]];
    [NetWorking netWorkingWithUrl:strUrl identification:noticvieBack];
}
- (void)noticeTheBackgroundEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noticvieBack object:nil];
    
}
/*************
 - (void)stitchingInterface:(NSString *)systime
 {
 //    NSLog(@"%@", _payDataDic);
 //    NSString * keyValues = [NSString stringWithFormat: @"appKey=00001&method=wop.pay.bychinaums&v=1.0&format=json&locale=zh_CN&timestamp=%@&client=iPhone&orderSn=%@", systime, [_payDataDic objectForKey:@"order"]];
 //   NSString *sign = [NetWorking submitGenerate:keyValues];
 //    NSLog(@"%@", sign);
 //     NSString * strUrl = [NSString stringWithFormat:@"%@?%@&sign=%@", HTTP,keyValues, sign];
 //    NSLog(@"%@", strUrl);
 //    NSURL *url = [NSURL URLWithString:strUrl];
 //    _challenge = nil;
 //    _filePath = [self pathForTemporaryFileWithPrefix:@"Get"];
 //    _fileStream = [[NSOutputStream alloc] initToFileAtPath:_filePath append:NO];
 //    assert(_fileStream != nil);
 //    [_fileStream open];
 //    NSString *strHead = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
 //    NSData *data = [strHead dataUsingEncoding:NSUTF8StringEncoding];
 //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 //    [request setHTTPMethod:@"POST"];
 //    [request setHTTPBody:data];
 //    [request setTimeoutInterval:60];
 //    [request setValue:@"text/xml" forKey:@"Content-type"];
 //    [request setValue:@"" forKey:@"sessionId"];
 //    assert(request != nil);
 //    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
 
 }
 - (void)_stopReceiveWithStatus:(NSString *)statusString
 {
 if (_connection != nil) {
 [_connection cancel];
 _connection = nil;
 }
 if (_fileStream != nil) {
 [_fileStream close];
 _fileStream = nil;
 }
 if (_challenge !=nil) {
 
 }
 
 [self _receiveDidStopWithStatus:statusString];
 _filePath = nil;
 }
 - (void)_receiveDidStopWithStatus:(NSString *)statusString
 {
 if (statusString == nil) {
 BOOL b=[[NSFileManager defaultManager]fileExistsAtPath:_filePath];
 if (b) {
 NSString *strRespost = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
 NSLog(@"strRespost:%@",strRespost);
 if(![strRespost isEqualToString:@""]&&strRespost!=nil){
 if([strRespost rangeOfString:@"|"].length>0){
 NSArray *array = [strRespost componentsSeparatedByString:@"|"];
 if([array count]==4)
 {
 NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];
 for(int i=0;i<[array count];i++){
 if(i==0){
 [mdict setValue:[array objectAtIndex:0] forKey:@"cerSign"];
 }
 if(i==1){
 [mdict setValue:[array objectAtIndex:1] forKey:@"chrCode"];
 }
 if(i==2){
 [mdict setValue:[array objectAtIndex:2] forKey:@"transId"];
 }
 if(i==3){
 [mdict setValue:[array objectAtIndex:3] forKey:@"merchantId"];
 }
 }
 NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mdict];
 NSLog(@"%@", dic);
 //[self nextPageWithDicOrderInfo:dic];
 //[mdict release];
 }
 }
 }else{
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络或服务器错误！请重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alertView show];
 }
 }
 statusString= @"Get succeeded";
 }
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 }
 
 #pragma mark private function
 - (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
 {
 NSString *  result;
 CFUUIDRef   uuid;
 CFStringRef uuidStr;
 
 assert(prefix != nil);
 
 uuid = CFUUIDCreate(NULL);
 assert(uuid != NULL);
 
 uuidStr = CFUUIDCreateString(NULL, uuid);
 assert(uuidStr != NULL);
 
 result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
 assert(result != nil);
 
 CFRelease(uuidStr);
 CFRelease(uuid);
 
 return result;
 }
 
 #pragma mark - NSURLConnectionDelegate
 - (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
 {
 NSLog(@"=================1");
 return [protectionSpace.authenticationMethod isEqualToString:
 NSURLAuthenticationMethodServerTrust];
 }
 
 - (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 {
 NSLog(@"=================2");
 _challenge= challenge;
 
 NSURLCredential *   credential;
 
 NSURLProtectionSpace *  protectionSpace;
 SecTrustRef             trust;
 NSString *              host;
 SecCertificateRef       serverCert;
 assert(_challenge !=nil);
 protectionSpace = [_challenge protectionSpace];
 assert(protectionSpace != nil);
 
 trust = [protectionSpace serverTrust];
 assert(trust != NULL);
 
 credential = [NSURLCredential credentialForTrust:trust];
 assert(credential != nil);
 host = [[_challenge protectionSpace] host];
 if (SecTrustGetCertificateCount(trust) > 0) {
 serverCert = SecTrustGetCertificateAtIndex(trust, 0);
 } else {
 serverCert = NULL;
 }
 [[_challenge sender] useCredential:credential forAuthenticationChallenge:_challenge];
 
 }
 
 - (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
 {
 NSLog(@"=================3");
 NSHTTPURLResponse * httpResponse;
 
 httpResponse = (NSHTTPURLResponse *) response;
 assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
 
 if ((httpResponse.statusCode / 100) != 2) {
 [self _stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
 } else {
 //        NSLog(@"status: Response OK.");
 }
 }
 
 - (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
 {
 #pragma unused(conn)
 NSLog(@"=================4");
 NSInteger       dataLength;
 const uint8_t * dataBytes;
 NSInteger       bytesWritten;
 NSInteger       bytesWrittenSoFar;
 
 
 dataLength = [data length];
 dataBytes  = [data bytes];
 
 bytesWrittenSoFar = 0;
 do {
 bytesWritten = [_fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
 assert(bytesWritten != 0);
 if (bytesWritten == -1) {
 [self _stopReceiveWithStatus:@"File write error"];
 break;
 } else {
 bytesWrittenSoFar += bytesWritten;
 }
 } while (bytesWrittenSoFar != dataLength);
 }
 
 - (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
 {
 //    NSLog(@"didFailWithError %@", error);
 NSLog(@"=================5");
 [self _stopReceiveWithStatus:@"Connection failed"];
 }
 - (void)connectionDidFinishLoading:(NSURLConnection *)conn
 {
 #pragma unused(conn)
 
 //    NSLog(@"connectionDidFinishLoading");
 NSLog(@"=================6");
 [self _stopReceiveWithStatus:nil];
 }
 *****************/
@end
