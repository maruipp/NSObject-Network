//
//  NSObject+Network.m
//  paobuba
//
//  Created by 马 瑞鹏 on 14-5-9.
//  Copyright (c) 2014年 爱叽歪工作室. All rights reserved.
//

#import "NSObject+Network.h"
#import "AFNetworking.h"
#import "AFHTTPRequestSerializer+HttpHeader.h"
#import <objc/runtime.h>
#import <YYCache/YYCache.h>

//baseurl associate key
NSString * const kBaseUrlKey = @"BaseUrlKeyStorage";
//enable cache associate key
NSString * const kEnableCacheGetRequestKey = @"EnableCacheGetRequestKey";
//cache name
NSString * const kCacheName = @"NSObjectNetworkCache";
const int kNetworkTimeOutInterval = 60;

static YYCache *g_cache;

@implementation NSObject (Network)

+ (void)setBaseURL:(NSURL *)baseUrl
{
    objc_setAssociatedObject(self,&kBaseUrlKey,baseUrl,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSURL *)baseUrl
{
    return objc_getAssociatedObject(self, &kBaseUrlKey);
}

+ (void)enableCacheGetRequest
{
    objc_setAssociatedObject(self, &kEnableCacheGetRequestKey, @YES, OBJC_ASSOCIATION_ASSIGN);
}

+ (BOOL)cacheGetRequest
{
    return [objc_getAssociatedObject(self, &kEnableCacheGetRequestKey) boolValue];
}

#pragma mark -
+ (void)load
{
    g_cache = [[YYCache alloc] initWithName:kCacheName];
}
#pragma mark ============================== POST
#pragma mark - 通用POST
- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success  failure:(XTNetworkFailureCallback) fail
{
    [self postWithExtraHeader:nil url:urlStr para:para success:^(id data, id operation) {
        if (success) {
            success(data,operation);
        }
    } failure:^(id error, id operation) {
        if (fail) {
            fail(error,operation);
        }
    }];
}

#pragma mark - 可添加额外header信息的POST请求.
- (void)postWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    //添加额外header
    [extraHeaderDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [manager POST:urlStr parameters:para success:^(AFHTTPRequestOperation* operation, id responseObject) {
        @try {
            [self checkUnusual:responseObject];
            success(responseObject,operation);
        }
        @catch (NSException *exception) {

        }
        @finally {
            //do nothing
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        fail(error,operation);
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 上传图片的POST
- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para image:(UIImage *)uploadimage success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    [manager POST:urlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (uploadimage) {
            NSData *imageData = UIImageJPEGRepresentation(uploadimage, 1);
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"%@",responseObject);
        @try {
            [self checkUnusual:responseObject];
            success(responseObject,operation);
        }
        @catch (NSException *exception) {

        }
        @finally {
            //do nothing
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        fail(error,operation);
    }];
}

#pragma mark - 传文件POST
- (void)postWithUrl:(NSString*)urlStr para:(NSDictionary*)para fileDic:(NSDictionary*)fileDic success:(XTNetworkSuccessCallback)success failure:(XTNetworkFailureCallback)fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    
    [manager POST:urlStr
       parameters:para
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [fileDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *filePath = obj;
                NSString *keyStr = key;
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:keyStr error:nil];
            }];
            
        }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
          success(responseObject,operation);
          NSLog(@"Success: %@", responseObject);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
          fail(error,operation);
          NSLog(@"Error: %@", error);
        }
     ];
}


#pragma mark ============================== GET请求
#pragma mark - 通用GET
- (void)getWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    [self getWithExtraHeader:nil url:urlStr para:para success:^(id data, id operation) {
        success(data,operation);
    } failure:^(id error, id operation) {
        fail(error,operation);
    }];
}
#pragma mark - 可添加自定义header信息的GET
- (void)getWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    //添加额外header
    [extraHeaderDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    AFHTTPRequestOperation* operation = [manager GET:urlStr parameters:para success:^(AFHTTPRequestOperation* operation, id responseObject) {
        @try {
            [self checkUnusual:responseObject];
            success(responseObject,operation);
            
            //cache response
            if ([NSObject cacheGetRequest]) {
                NSString *key = [NSString stringWithFormat:@"%@",operation.request.URL.absoluteString];
                [g_cache setObject:responseObject forKey:key];
            }
        }
        @catch (NSException *exception) {

        }
        @finally {
            //do nothing
        }

    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Error: %@", error);
        fail(error,operation);
    }];
    
    //read cached response
    if ([NSObject cacheGetRequest]) {
        NSString *key = [NSString stringWithFormat:@"%@",operation.request.URL.absoluteString];
        id responseObj = [g_cache objectForKey:key];
        if (responseObj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObj,operation);
            });
        }
    }
    
}

#pragma mark ============================== PUT
/**
 通用PUT请求.
 */
- (void)putWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    [self putWithExtraHeader:nil url:urlStr para:para success:^(id data, id operation) {
        success(data,operation);
    } failure:^(id error, id operation) {
        fail(error,operation);
    }];
}

/**
 可添加额外header信息的PUT请求.
 */
- (void)putWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    //添加额外header
    [extraHeaderDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [manager PUT:urlStr parameters:para success:^(AFHTTPRequestOperation* operation, id responseObject) {
        @try {
            [self checkUnusual:responseObject];
            success(responseObject,operation);
        }
        @catch (NSException *exception) {

        }
        @finally {
            //do nothing
        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Error: %@", error);
        fail(error,operation);
    }];
}


/**
 通用DELETE请求.
 */
- (void)deleteWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    [self deleteWithExtraHeader:nil url:urlStr para:para success:^(id data, id operation) {
        success(data,operation);
    } failure:^(id error, id operation) {
        fail(error,operation);
    }];
}

/**
 可添加额外header信息的DELETE请求.
 */
- (void)deleteWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success failure:(XTNetworkFailureCallback) fail
{
    NSURL *baseUrl = [NSObject baseUrl];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = kNetworkTimeOutInterval;
    [manager.requestSerializer customHeader];
    //添加额外header
    [extraHeaderDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [manager DELETE:urlStr parameters:para success:^(AFHTTPRequestOperation* operation, id responseObject) {

        @try {
            [self checkUnusual:responseObject];
            success(responseObject,operation);
        }
        @catch (NSException *exception) {

        }
        @finally {

        }
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Error: %@", error);
        fail(error,operation);
    }];
}

#pragma mark ============================== 检查返回数据格式是否正确
- (void)checkUnusual:(NSDictionary*)dic
{
    //do something to check status return code in common

    //    NSString *retcode = [dic objectForKey:@"retcode"];
    //    NSString *info = [[dic objectForKey:@"return"] objectForKey:@"val"];
    //    if (1001 != [retcode intValue]) {
    //        info = [ACTION_FEEDBACK_DICTIONARY objectForKey:retcode];
    //        [ToastManager makeToast:info];
    //    }
}

@end
