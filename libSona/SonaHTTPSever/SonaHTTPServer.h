//
//  SonaHTTPServer.h
//  libSona
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonaHTTPServer : NSObject

@property(nonatomic,strong,readonly)NSString *webPath;

// 
@property(nonatomic,strong)NSString *filePath;

// 默认的webroot path
@property(nonatomic,strong,readonly)NSString *defaultFilePath;

+ (instancetype)sharedHTTPServer;

- (void)start;

- (void)stop;

- (void)applicationWillResignActive;

- (void)applicationDidEnterBackground;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copy NS_UNAVAILABLE;
- (instancetype)mutableCopy NS_UNAVAILABLE;

@end
