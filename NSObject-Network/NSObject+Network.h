//
//  NSObject+Network.h
//  paobuba
//
//  Created by 马 瑞鹏 on 14-5-9.
//  Copyright (c) 2014年 爱叽歪工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const int kNetworkTimeOutInterval;

typedef void (^XTNetworkSuccessCallback) (id data,id operation);
typedef void (^XTNetworkFailureCallback) (id error,id operation);

@interface NSObject (Network)

#pragma mark - Config Methods
///=============================================================================
/// @name Config Methods
///=============================================================================

+ (void)setBaseURL:(NSURL *)baseUrl;

+ (void)enableCacheGetRequest;

#pragma mark - Request Methods
///=============================================================================
/// @name Request Methods
///=============================================================================
#pragma mark ============================== POST
/**
 通用POST请求.
 */
- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success  failure:(XTNetworkFailureCallback) fail;

/**
 可添加额外header信息的POST请求.
 */
- (void)postWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

/**
 这个POST请求用于上传图片.
 */
- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para image:(UIImage *)uploadimage success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

/**
 POST 上传文件.
 */
- (void)postWithUrl:(NSString*)urlStr para:(NSDictionary*)para fileDic:(NSDictionary*)fileDic success:(XTNetworkSuccessCallback)success failure:(XTNetworkFailureCallback)fail;

#pragma mark ============================== GET
/**
 通用GET请求.
 */
- (void)getWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

/**
 可添加额外header信息的GET请求.
 */
- (void)getWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

#pragma mark ============================== PUT
/**
 通用PUT请求.
 */
- (void)putWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

/**
 可添加额外header信息的PUT请求.
 */
- (void)putWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

#pragma mark ============================== DELETE
/**
 通用DELETE请求.
 */
- (void)deleteWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

/**
 可添加额外header信息的DELETE请求.
 */
- (void)deleteWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail;

@end
