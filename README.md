# NSObject+Network
本项目是基于AFNetworking的扩展。通过分类的方式对NSObject类进行扩展，使得网络请求调用更便捷。
## Installation：
在Podfile文件中添加：

> pod "NSObject-Network", :git => 'git@github.com:maruipp/NSObject-Network.git', :branch => 'master'

## 调用方式
本项目对常用的restful网络请求方式都进行了扩展。
### GET请求
``` objc
	[self getWithUrl:urlStr para:paraDic success:^(id data, id operation) {
	        
	} failure:^(id error, id operation) {
	    
	}];
```
### 可自定义请求头的GET请求
```
- (void)getWithExtraHeader:(NSDictionary *)extraHeaderDict url:(NSString *)urlStr 
								para:(NSDictionary *)para success:(XTNetworkSuccessCallback) success 
								failure:(XTNetworkFailureCallback) fail;
```

> POST,PATCH,DELETE等请求与GET请求类似，调用相应方法即可。

## 优势
* 基于NSObject分类，使用便捷。使用self，传必要参数即可调用。
* 一键生效对GET请求的缓存。
* 可统一添加网络请求header，亦可针对单独接口设置个性化网络请求头。

## TODO
* 完善demo，加入网络请求提醒及缓存获取数据提醒
* 补全文档，增加POST,PATCH,DELETE请求示例
* 补全文档，增加baseUrl设置方法
* 补全文档，增加使针对GET请求的缓存生效的设置方法
* 通过delegate实现网络请求头的定义，避免耦合