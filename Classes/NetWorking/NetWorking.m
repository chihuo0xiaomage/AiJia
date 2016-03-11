//
//  NetWorking.m
//  LaiFuBao
//
//  Created by 宝源科技 on 14-12-4.
//  Copyright (c) 2014年 lipengjun. All rights reserved.
//

#import "NetWorking.h"
#import <CommonCrypto/CommonCrypto.h>

@interface NetWorking ()

{
    NSURLConnection * _connection;
    NSMutableData   * _receiveData;
    NSMutableData *_netData;
    NSString        * _identification;
    __block NSString * _systemTime;
  
}
@property(copy)Success success;
@property(copy)Failure failure;

@end

@implementation NetWorking
/**
 *在网络开始之前进行取消
 **/
- (void)cancelLoadData
{
    [_connection cancel];
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/**
 *get请求
 **/
+ (void)netWorkingWithUrl:(NSString *)urlStr identification:(NSString *)identification
{
    NetWorking * netWorking = [[NetWorking alloc] init];
    [netWorking timeIntervalWithRequestType:@"GET" urlStr:urlStr identfier:identification];
}
/**
 *post请求
 **/
+ (void)netWorkingWithUrl:(NSString *)baseUrl body:(NSString *)body identification:(NSString *)identification
{
    NetWorking * netWorking = [[NetWorking alloc] init];
    NSArray * urlArray = @[baseUrl, body];
//    [netWorking startNetWorkingRequest:@"POST" url:urlArray identification:identification];
    [netWorking timeIntervalWithRequestType:@"POST" urlStr:urlArray identfier:identification];
}

/**
 *开始网络数据
 **/
- (void)startNetWorkingRequest:(NSString *)requestType url:(id)urlStr identification:(NSString *)identification
{
    _identification = identification;
    [self cancelLoadData];
    if ([requestType isEqualToString:@"GET"]) {
        NSString * urlEncodeStr = [self generate:urlStr] ;
            //NSLog(@"urlEncodeStr = %@", urlEncodeStr);
        NSURL * url = [NSURL URLWithString:[urlEncodeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest * getRequest = [NSURLRequest requestWithURL:url];
        _connection = [NSURLConnection connectionWithRequest:getRequest delegate:self];
    }else if ([requestType isEqualToString:@"POST"]){
            //NSLog(@"%@", [self generate:[urlStr lastObject]]);
        NSArray *array = [[self generate:[urlStr lastObject]] componentsSeparatedByString:@"?"];
            //NSLog(@"%@", array);
        NSURL *url = [NSURL URLWithString:[array firstObject]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSData *paramsData = [[array lastObject] dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:paramsData];
//        NSString * urlEncodeStr = [[NetWorking submitGenerate:[urlStr lastObject]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *body = [NSString stringWithFormat:@"%@&sign=%@", [urlStr lastObject], urlEncodeStr];
//        NSLog(@"body = %@", body);
//        NSURL * url = [NSURL URLWithString:[urlStr firstObject]];
//        NSMutableURLRequest * postRequest = [NSMutableURLRequest requestWithURL:url];
//        [postRequest setHTTPMethod:requestType];
//        NSData * paramsData = [body dataUsingEncoding:NSUTF8StringEncoding];
//        [postRequest setHTTPBody:paramsData];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
#pragma mark  UIConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receiveData = [NSMutableData dataWithCapacity:1];
    
     _netData = [NSMutableData dataWithCapacity:1];
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
    
     [_netData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
        //NSLog(@"-----%@", [NSJSONSerialization JSONObjectWithData:_receiveData options:0 error:nil]);
    [[NSNotificationCenter defaultCenter] postNotificationName:_identification object:_receiveData];
    
    if (_success && _netData != NULL) {
        NSString *json = [NSJSONSerialization JSONObjectWithData:_netData options:0 error:nil];
        _success(_netData, json);
    }

}
    //请求错误调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:_identification object:@"服务器未响应"];
    
     _failure(error);
}

/**
 *获取系统时间 开始网络请求
 **/
- (void)timeIntervalWithRequestType:(NSString *)requestType urlStr:(id)urlStr identfier:(NSString *)identfier
{
    /**
     *获取服务器系统时间
     **/
    NSString * systemUrlStr = @"http://www.ajtzx.com/mall//systemdate.jsp?r='+Math.random()";
    NSURL * url = [NSURL URLWithString:systemUrlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
                //NSLog(@"%@", error);
                //NSLog(@"%@", identfier);
            [[NSNotificationCenter defaultCenter] postNotificationName:identfier object:@"网络连接错误"];
//            [[[UIAlertView alloc] initWithTitle:@"网络状态不稳定, 请您稍等" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
        if (response && [(NSHTTPURLResponse *)response statusCode] == 200) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            _systemTime = [[NSString alloc] initWithData:data encoding:enc];
            _systemTime = [_systemTime substringFromIndex:2];
            if (![_systemTime isEqualToString:@""] && _systemTime != nil) {
                /**
                 *开始网络请求
                 **/
                [self startNetWorkingRequest:requestType url:urlStr identification:identfier];
            }
        }
    }];
}
/**
 * MD5加密
 **/
+ (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        {
        [hash appendFormat:@"%02X", result[i]];
        }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}
/**
 *签名同时进行网络url的拼接
 **/
- (NSString *)generate:(NSString *)url
{
    if (url.length == 0) {
        return nil;
    }
    url = [NSString stringWithFormat:@"%@&timestamp=%@", url, _systemTime];
    NSString *keyValuesStr = @"";
    NSArray * keyValuesArray = [url componentsSeparatedByString:@"&"];
    keyValuesArray = [keyValuesArray sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * str in keyValuesArray) {
        NSArray * array = [str componentsSeparatedByString:@"="];
        
        for (NSString * str1 in array) {
         keyValuesStr = [NSString stringWithFormat:@"%@%@", keyValuesStr, str1];
        }
    }
    NSString * straa = [NSString stringWithFormat: @"abcdeabcdeabcdeabcdeabcde%@abcdeabcdeabcdeabcdeabcde", keyValuesStr];

    const char *cstr = [straa cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:straa.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    NSString * sign = [output uppercaseString];
    return [NSString stringWithFormat:@"%@?%@&sign=%@", HTTP, url, sign];
}
+ (NSString*)submitGenerate:(NSString *)urlStr
{
    if (urlStr.length == 0) {
        return nil;
    }
    NSString * keyValuesStr = @"";
    NSArray * keyValuesArray = [urlStr componentsSeparatedByString:@"&"];
    keyValuesArray = [keyValuesArray sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * str in keyValuesArray) {
        NSArray * array = [str componentsSeparatedByString:@"="];
        for (NSString * str1 in array) {
            keyValuesStr = [NSString stringWithFormat:@"%@%@", keyValuesStr, str1];
            
        }
    }
    NSString * straa = [NSString stringWithFormat: @"abcdeabcdeabcdeabcdeabcde%@abcdeabcdeabcdeabcdeabcde", keyValuesStr];
    
    const char *cstr = [straa cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:straa.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output uppercaseString];
}
#pragma mark - Get请求 第一个参数传入签名参数
+ (void)netGetWithURL:(NSString *)urlStr success:(Success)success failure:(Failure)failure{
    NetWorking *networking = [[NetWorking alloc] init];
    networking.success = success;
    networking.failure = failure;
    //    NSLog(@"%@", [self generate:urlStr]);
    NSURL *url = [NSURL URLWithString:[[self generate:urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:networking];

}
#pragma mark - Post请求
+ (void)netPostWithBaseURl:(NSString *)baseUrl body:(NSString *)body success:(Success)success failure:(Failure)failure{
    NetWorking *networking = [[NetWorking alloc] init];
    NSLog(@"%@", [self generate:body]);
    
    networking.success = success;
    networking.failure = failure;
    NSArray *array = [[self generate:body] componentsSeparatedByString:@"?"];
    NSURL *url = [NSURL URLWithString:[array firstObject]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[array lastObject] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:networking];

}

/**
 * 获取时间戳
 **/
+ (CGFloat)timeInterval
{
    NSDate * nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSince1970];
    return time * 1000;
}


/**
 * 获取签名后完整的URL
 **/
+ (NSString *)generate:(NSString *)url{
    if (url.length == 0) {
        return nil;
    }
    url = [NSString stringWithFormat:@"%@&timestamp=%.0f", url, [self timeInterval]];
    NSString *keyValuesStr = @"";
    NSArray * keyValuesArray = [url componentsSeparatedByString:@"&"];
    keyValuesArray = [keyValuesArray sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * str in keyValuesArray) {
        NSArray * array = [str componentsSeparatedByString:@"="];
        
        for (NSString * str1 in array) {
            keyValuesStr = [NSString stringWithFormat:@"%@%@", keyValuesStr, str1];
        }
    }
    NSString * straa = [NSString stringWithFormat: @"abcdeabcdeabcdeabcdeabcde%@abcdeabcdeabcdeabcdeabcde", keyValuesStr];
    
    const char *cstr = [straa cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:straa.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    NSString * sign = [output uppercaseString];
    return [NSString stringWithFormat:@"%@?%@&sign=%@", HTTP, url, sign];


}

+ (NSDictionary *)getJsonDictionaryWithPOSTMethodWithURL:(NSString *)canshu{
    NSString * uuu = [NetWorking generate:canshu];
    NSArray * uuuARR = [uuu componentsSeparatedByString:@"?"];
    NSURL * url = [NSURL URLWithString:HTTP];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[[uuuARR objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSURLResponse * response;
    __autoreleasing NSError * error;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    return jsonDic;


}

@end
