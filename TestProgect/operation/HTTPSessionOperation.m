//
//  HTTPSessionOperation.m
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/19.
//  Copyright © 2018年 尧德仁. All rights reserved.
//


#import "HTTPSessionOperation.h"
#import "AFNetworking.h"

@interface AFHTTPSessionManager (DataTask)

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end

@interface HTTPSessionOperation ()

@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) NSMutableArray<NSURLSessionTask *> *requestArray;
@property (strong, nonatomic) NSURLSessionTask *currentTask;

@end


@implementation HTTPSessionOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
    }
    return self;
}
- (void)addExecutionGetRequestWithManager:(AFHTTPSessionManager *)manager
                                URLString:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self addExecutionRequestWithManager:manager HTTPMethod:@"GET" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];
}

- (void)addExecutionPostRequestWithManager:(AFHTTPSessionManager *)manager
                                 URLString:(NSString *)URLString
                                parameters:(nullable id)parameters
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self addExecutionRequestWithManager:manager HTTPMethod:@"POST" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];
}

- (void)addExecutionRequestWithManager:(AFHTTPSessionManager *)manager
                            HTTPMethod:(NSString *)method
                             URLString:(NSString *)URLString
                            parameters:(id)parameters
                        uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                      downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(void (^)(NSURLSessionDataTask *, id))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSURLSessionTask *task = [manager dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:^(NSURLSessionDataTask *task, id responseObject){
        if (success) {
            success(task, responseObject);
        }
        if (![self startNextRequest]) {
            [self completeOperation];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
        if (![self startNextRequest]) {
            [self completeOperation];
        }
    }];
    [_requestArray addObject:task];
}

- (BOOL)startNextRequest
{
    if (_nextRequestIndex < [_requestArray count]) {
        NSURLSessionTask *task = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        _currentTask = task;
        [task resume];
        return YES;
    } else {
        return NO;
    }
}

- (void)main
{
    [self startNextRequest];
}

- (void)completeOperation
{
    [_requestArray removeAllObjects];
    _requestArray = nil;
    [super completeOperation];
}

- (void)cancel
{
    [_currentTask cancel];
    [_requestArray removeAllObjects];
    _requestArray = nil;
    [super cancel];
}

- (void)dealloc
{
    NSLog(@"====> HTTPSessionOperation dealloc <====");
}

@end

