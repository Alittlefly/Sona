//
//  ViewController.m
//  Sona-Oc
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "ViewController.h"
#import <libSona/SonaHTTPServer.h>
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate>
@property(nonatomic,strong)WKWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2.0 - 110, 520, 100, 40)];
    [addButton setBackgroundColor:[UIColor blueColor]];
    [addButton setTitle:@"默认" forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(loadHtml) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addButton];
    
    UIButton *addOtherButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2.0 + 10, 520, 100, 40)];
    [addOtherButton setBackgroundColor:[UIColor blueColor]];
    [addOtherButton setTitle:@"自定义" forState:(UIControlStateNormal)];
    [addOtherButton addTarget:self action:@selector(loadSelfDefinePath) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addOtherButton];
}
- (void)createWebView {
    _webview = [[WKWebView alloc] init];
    [_webview setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 500)];
    [_webview setOpaque:NO];
    [_webview setAutoresizesSubviews:YES];
    //    [_webview setUIDelegate:self];
    [_webview setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_webview];
}
- (void)loadHtml {
    if (_webview) {
        [_webview removeFromSuperview];
        [_webview setUIDelegate:nil];
         _webview = nil;
    }
    
    [self createWebView];
    
    NSString *filePath = [SonaHTTPServer sharedHTTPServer].defaultFilePath;
    NSString *webPath = [SonaHTTPServer sharedHTTPServer].webPath;
    
    [[SonaHTTPServer sharedHTTPServer] setFilePath:filePath];

    
    NSString *requestUrl = [webPath stringByAppendingPathComponent:@"index.html"];
    [self loadRequest:requestUrl];
}
- (void)loadRequest:(NSString *)requestUrl {
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [_webview loadRequest:request];
}

- (void)loadSelfDefinePath {
    
    if (_webview) {
        [_webview removeFromSuperview];
        [_webview setUIDelegate:nil];
        _webview = nil;
    }
    
    [self createWebView];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *rootPath = [[self documentPath] stringByAppendingPathComponent:@"web"];
    if (![defaultManager fileExistsAtPath:rootPath]) {
       BOOL success = [defaultManager createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (success) {
            NSLog(@"文件夹创建成功 %@",rootPath);
        }
    }
    
    [[SonaHTTPServer sharedHTTPServer] setFilePath:rootPath];
    NSString *webPath = [SonaHTTPServer sharedHTTPServer].webPath;

    NSString *errorPage = @"error.html";
    NSString *errorPagePath = [rootPath stringByAppendingPathComponent:errorPage];
    
    NSString *localWebPath = [webPath stringByAppendingPathComponent:errorPage];
    
    if ([defaultManager fileExistsAtPath:errorPagePath]) {
        [self loadRequest:localWebPath];
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.7nujoom.com/error.html"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger code = httpResponse.statusCode;
        if (code == 200) {
            // 将页面写入到文件;
            BOOL success = [defaultManager createFileAtPath:errorPagePath contents:nil attributes:nil];
            if (success) {
                NSFileHandle *writer = [NSFileHandle fileHandleForWritingAtPath:errorPagePath];
                [writer writeData:data];
                // 文件写入成
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadRequest:localWebPath];
                });
            }
        }
    }];
    
    [task resume];
}

- (NSString *)documentPath {
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO) firstObject];
    return documentPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
