//
//  HTTPSessionOperation.h
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/19.
//  Copyright © 2018年 尧德仁. All rights reserved.
//

#import "BaseOperation.h"

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface HTTPSessionOperation : BaseOperation

/**
 @brief 可多次调用，任务是串行执行的。
 */
- (void)addExecutionGetRequestWithManager:(AFHTTPSessionManager *)manager
                             URLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)addExecutionPostRequestWithManager:(AFHTTPSessionManager *)manager
                             URLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)addExecutionRequestWithManager:(AFHTTPSessionManager *)manager
                            HTTPMethod:(NSString *)method
                             URLString:(NSString *)URLString
                            parameters:(nullable id)parameters
                        uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                      downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
