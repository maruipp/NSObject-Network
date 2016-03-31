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
* 使用便捷，无需进行实例化即可调用。