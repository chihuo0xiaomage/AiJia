//
//  NetWorking.h
//  LaiFuBao
//
//  Created by 宝源科技 on 14-12-4.
//  Copyright (c) 2014年 lipengjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^Success)(NSData *data, NSString *json);
typedef void(^Failure)(NSError *error);
@interface NetWorking : NSObject

    //GET
+ (void)netWorkingWithUrl:(NSString *)urlStr identification:(NSString *)identification;
    //POST
+ (void)netWorkingWithUrl:(NSString *)baseUrl body:(NSString *)body identification:(NSString *)identification;
/**
 * 获取签名
 **/
+ (NSString*)submitGenerate:(NSString *)urlStr;

    //+ (void)
//+ (NSString *)generate:(NSString *)url;
//+ (NSString *)md5HexDigest:(NSString*)password;

#pragma mark - Get请求 第一个参数传入签名参数
+ (void)netGetWithURL:(NSString *)urlStr success:(Success)success failure:(Failure)failure;
#pragma mark - Post请求
+ (void)netPostWithBaseURl:(NSString *)baseUrl body:(NSString *)body success:(Success)success failure:(Failure)failure;

/**
 * 获取签名后完整的URL
 **/
+ (NSString *)generate:(NSString *)url;

+ (NSDictionary *)getJsonDictionaryWithPOSTMethodWithURL:(NSString *)canshu;
@end
