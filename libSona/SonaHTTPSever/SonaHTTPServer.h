//
//  SonaHTTPServer.h
//  libSona
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonaHTTPServer : NSObject

// 本地服务的地址 返回 http://127.0.0.1:port/
@property(nonatomic,strong,readonly)NSString *webPath;

// 自定义的filePath
@property(nonatomic,strong)NSString *filePath;

// 默认的 webroot path (仅用于测试)
@property(nonatomic,strong,readonly)NSString *defaultFilePath;

+ (instancetype)sharedHTTPServer;

// 启动
- (void)start;

// 停止
- (void)stop;

- (void)applicationWillResignActive;

- (void)applicationDidEnterBackground;
// 设置本地服务 Connection的处理类
- (void)setConnectionClass:(Class)Class;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copy NS_UNAVAILABLE;
- (instancetype)mutableCopy NS_UNAVAILABLE;

@end
