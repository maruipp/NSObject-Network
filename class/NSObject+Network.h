//
//  NSObject+Network.h
//  paobuba
//
//  Created by 马 瑞鹏 on 14-5-9.
//  Copyright (c) 2014年 爱叽歪工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (Network)

- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(void (^)(id)) success  failure:(void (^)(id)) fail;

- (void)postWithUrl:(NSString *)urlStr para:(NSDictionary *)para image:(UIImage *)uploadimage success:(void (^)(id)) success failure:(void(^)(id)) fail;

- (void)getWithUrl:(NSString *)urlStr para:(NSDictionary *)para success:(void (^)(id)) success failure:(void (^)(id)) fail;
@end
