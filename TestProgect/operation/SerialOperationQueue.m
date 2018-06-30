//
//  SerialOperationQueue.m
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/30.
//  Copyright © 2018年 尧德仁. All rights reserved.
//

#import "SerialOperationQueue.h"

@interface SerialOperationQueue()

@property (nonatomic,copy) NSString *queueName;

@end

static NSMapTable * __globalMap__;

@implementation SerialOperationQueue

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    if (maxConcurrentOperationCount != 1) {
        NSLog(@"这是个串行队列 maxConcurrentOperationCount 为 1");
    }
    [super setMaxConcurrentOperationCount:1];
}

+ (instancetype)createQueueWithName:(NSString *)name
{
    if (!__globalMap__) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __globalMap__ = [NSMapTable weakToWeakObjectsMapTable];
        });
    }
    SerialOperationQueue *queue = [SerialOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
    queue.queueName = name;
    queue.name = name;
    [__globalMap__ setObject:queue forKey:name];
    return queue;
}

+ (instancetype)serialQueueWithName:(NSString *)name
{
    if (__globalMap__) {
        return [__globalMap__ objectForKey:name];
    }
    return nil;
}

@end
