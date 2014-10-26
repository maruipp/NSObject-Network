//
//  ViewController.m
//  AFNetworkNSObject
//
//  Created by 马 瑞鹏 on 14/10/26.
//  Copyright (c) 2014年 xuetangX. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Network.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr = @"http://ip.taobao.com/service/getIpInfo.php";
    NSDictionary *paraDic = @{@"ip":@"202.108.22.103"};
    [self getWithUrl:urlStr para:paraDic success:^(id responseObj) {
        
    } failure:^(id error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
