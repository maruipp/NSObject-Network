//
//  NSObject+Network.m
//  paobuba
//
//  Created by 马 瑞鹏 on 14-5-9.
//  Copyright (c) 2014年 爱叽歪工作室. All rights reserved.
//

#import "NSObject+Network.h"
#import "AFHTTPRequestOperationManager+HttpHeader.h"
#import "AppDelegate.h"
static const int kTimeOutInterval = 60;
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
@implementation NSObject (Network)
#pragma mark
#pragma mark - network

- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(void (^)(id)) success  failure:(void (^)(id)) fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager addYoucheRequestHeader];
    [manager POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        @try {
            [self checkUnusual:responseObject];
            success(responseObject);
        }
        @catch (NSException *exception) {
//            [ToastManager makeDebugToast:[NSString stringWithFormat:@"%@",exception]];
        }
        @finally {
            //do nothing
        }
        //        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
        fail(error);
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark
#pragma mark - 上传图片
- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para image:(UIImage *)uploadimage success:(void (^)(id)) success failure:(void(^)(id)) fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager addYoucheRequestHeader];
    [manager POST:urlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(uploadimage, 1);
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        @try {
            [self checkUnusual:responseObject];
            success(responseObject);
        }
        @catch (NSException *exception) {
//            [ToastManager makeDebugToast:[NSString stringWithFormat:@"%@",exception]];
        }
        @finally {
            //do nothing
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark
#pragma mark - GET

- (void)getWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(void (^)(id)) success failure:(void (^)(id)) fail{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager addYoucheRequestHeader];
    [manager GET:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        @try {
            [self checkUnusual:responseObject];
            success(responseObject);
        }
        @catch (NSException *exception) {
            //[ToastManager makeDebugToast:[NSString stringWithFormat:@"%@",exception]];
        }
        @finally {
            //do nothing
        }
//        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        fail(error);
        //        [ToastManager makeDebugToast:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)checkUnusual:(NSDictionary *)dic
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
