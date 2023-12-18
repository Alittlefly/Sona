#libSona.framework
--
简介

libSona 一个创建iphone手机端 local服务器的工具.

https://publish-niumama.oss-cn-hangzhou.aliyuncs.com/gc_jsb-default.zip

## 依赖库
	pod 'CocoaHTTPServer'
	
## 关于DDLog报错

invalid ‘xxxxx’ in C99 的错误 
<br>请在 <code>Pods -> targets -> CocoaHTTPServer -> BuildSetting ->
Preprocessor Macros </code> 
配置：<br>
<code>
DD_LEGACY_MACROS = 1
</code>

## 示例

初始化<br>
Appdelegate.m 
<pre>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SonaHTTPServer sharedHTTPServer] start];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [[SonaHTTPServer sharedHTTPServer] applicationWillResignActive];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[SonaHTTPServer sharedHTTPServer] applicationDidEnterBackground];
}
</pre>

配置
<pre>
- (void)createWebPath {
	 NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *rootPath = [[self documentPath] stringByAppendingPathComponent:@"web"];
    if (![defaultManager fileExistsAtPath:rootPath]) {
       BOOL success = [defaultManager createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (success) {
            NSLog(@"文件夹创建成功 %@",rootPath);
        }
    } 
    [[SonaHTTPServer sharedHTTPServer] setFilePath:rootPath];
}
</pre>

访问
<pre>
    NSString *webPath = [SonaHTTPServer sharedHTTPServer].webPath;
    NSString *errorPage = @"test.html";
    NSString *errorPagePath = [rootPath stringByAppendingPathComponent:errorPage];
    NSString *localWebPath = [webPath stringByAppendingPathComponent:errorPage];
    if ([defaultManager fileExistsAtPath:errorPagePath]) {
        [self loadRequest:localWebPath];
        return;
    }
</pre>

