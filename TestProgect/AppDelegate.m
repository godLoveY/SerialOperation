//
//  AppDelegate.m
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/19.
//  Copyright © 2018年 尧德仁. All rights reserved.
//
#import "AppDelegate.h"
#import "HTTPSessionOperation.h"
#import "AFNetworking.h"
#import "SerialOperationQueue.h"

@interface AppDelegate ()

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@property (nonatomic,strong) SerialOperationQueue *queue;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SerialOperationQueue createQueueWithName:@"bbbb"];
    _queue = [SerialOperationQueue createQueueWithName:@"aaaaaa"];
    [_queue addOperation:self.operation1];//SerialOperationQueue 添加的operation 是串行执行的
    [_queue addOperation:self.operation2];
//    [operation1 addDependency:operation2];//支持设置 依赖
    
    NSLog(@"有没有阻塞");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //用于验证 SerialOperationQueue 不会导致内存泄露
        NSLog(@"不为空就正常----%@,",[SerialOperationQueue serialQueueWithName:@"aaaaaa"]);
        NSLog(@"为空就正常----%@,",[SerialOperationQueue serialQueueWithName:@"bbbb"]);
    });
    
    NSLog(@"输出结果顺序为: \noperation1 success 1 \noperation1 success 2 \noperation1 success 3 \noperation2 success 1 \n才正常\n");
    
    return YES;
}





#pragma mark 测试用的 NSOperation, addExecutionRequestWithManager方式添加的请求任务也是串行执行的
- (NSOperation*)operation1
{
    NSString *url = @"http://mobile.weather.com.cn/data/forecast/101010100.html?_=1381891660081";
    NSString *url2 = @"http://mobile.weather.com.cn/data/sk/101010100.html?_=1381891661455";
    
    HTTPSessionOperation *operation1 = [HTTPSessionOperation new];
    __weak HTTPSessionOperation *weakOpa = operation1;
    [operation1 addExecutionGetRequestWithManager:self.manager URLString:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"operation1 success 1");
        //返回值作为 第二次请求的参数时
        [weakOpa addExecutionGetRequestWithManager:_manager URLString:url2 parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"operation1 success 3");
        } failure:nil];
    } failure:nil];
    
    [operation1 addExecutionGetRequestWithManager:_manager URLString:url2 parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"operation1 success 2");
    } failure:nil];
    return operation1;
}

- (NSOperation*)operation2
{
//    NSString *url = @"http://mobile.weather.com.cn/data/forecast/101010100.html?_=1381891660081";
    NSString *url2 = @"http://mobile.weather.com.cn/data/sk/101010100.html?_=1381891661455";
    
    HTTPSessionOperation *operation2 = [HTTPSessionOperation new];
    [operation2 addExecutionGetRequestWithManager:_manager URLString:url2 parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"operation2 success 1");
    } failure:nil];
    return operation2;
}

#pragma mark 测试用的AF库 manager
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 20;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    }
    return _manager;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
