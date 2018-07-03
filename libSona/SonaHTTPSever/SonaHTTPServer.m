//
//  SonaHTTPServer.m
//  libSona
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "SonaHTTPServer.h"
#import <CocoaHTTPServer/CocoaHTTPServer-umbrella.h>
#import "SonaConnection.h"

@interface SonaHTTPServer()<NSCopying,NSMutableCopying>
{
    NSUInteger _port;
    NSString *_defaultFilePath;
    NSString *_filePath;
}
@property(nonatomic,strong)HTTPServer *server;
@end

@implementation SonaHTTPServer
static id SharedHTTPServer = nil;

+ (instancetype)sharedHTTPServer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (SharedHTTPServer == nil) {
            SharedHTTPServer = [[SonaHTTPServer alloc] initHTTPServer];
        }
    });
    return SharedHTTPServer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedHTTPServer = [super allocWithZone:zone];
    });
    return SharedHTTPServer;
}

- (id)copyWithZone:(NSZone *)zone {
    return [SonaHTTPServer sharedHTTPServer];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [SonaHTTPServer sharedHTTPServer];
}

- (instancetype)initHTTPServer {
    if (self = [super init]) {
        _port = 1423;
        [self configHTTPServer];
    }
    return self;
}
- (NSString *)defaultFilePath {
    if (!_defaultFilePath) {
        NSBundle *libBundle = [NSBundle bundleForClass:[self class]];
        NSBundle *currentbundle = [NSBundle bundleWithPath:[libBundle pathForResource:@"SonaSource" ofType:@"bundle"]] ;
        NSString *directoryPath = [[currentbundle bundlePath] stringByAppendingPathComponent:@"web"];
        _defaultFilePath = directoryPath;
    }
    return _defaultFilePath;
}
- (NSString *)webPath {
    NSString *webPath = [NSString stringWithFormat:@"http://127.0.0.1:%lu",(unsigned long)_port];
    return webPath;
}
- (NSString *)filePath {
    if (_filePath) {
        return _filePath;
    }
    // 
    return self.defaultFilePath;
}
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    [self.server setDocumentRoot:_filePath];
}
- (void)configHTTPServer {
    self.server = [[HTTPServer alloc] init];
    [self.server setPort:_port];
    [self.server setType:@"_http._tcp."];
    [self.server setDocumentRoot:self.defaultFilePath];
    
    [self.server setConnectionClass:[SonaConnection class]];
}
- (void)setConnectionClass:(Class)Class {
    [self.server setConnectionClass:Class];
}

- (void)start {

    if (_filePath) {
        [self.server setDocumentRoot:self.defaultFilePath];
    }
    
    NSError *error;
    [self.server start:&error];
    if (!error) {
        NSLog(@"启动成功");
    }
}

- (void)stop {
    [self.server stop];
}

- (void)applicationWillResignActive {
    
}

- (void)applicationDidEnterBackground {
    
}
@end
