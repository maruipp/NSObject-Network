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
    [NSObject setBaseURL:[NSURL URLWithString:@"http://ip.taobao.com"]];
    [NSObject enableCacheGetRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonTapped:(id)sender {
    
    
    NSString *urlStr = @"service/getIpInfo.php";
    NSDictionary *paraDic = @{@"ip":@"202.108.22.103"};
    [self getWithUrl:urlStr para:paraDic success:^(id data, id operation) {
        
    } failure:^(id error, id operation) {
        
    }];
    
}

@end
