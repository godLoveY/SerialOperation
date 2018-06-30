//
//  BaseOperation.m
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/19.
//  Copyright © 2018年 尧德仁. All rights reserved.
//


#import "BaseOperation.h"

@interface BaseOperation ()

@property (nonatomic, getter = isFinished, readwrite)  BOOL finished;
@property (nonatomic, getter = isExecuting, readwrite) BOOL executing;

@end

@implementation BaseOperation

@synthesize finished  = _finished;
@synthesize executing = _executing;

- (id)init
{
    self = [super init];
    if (self) {
        _finished  = NO;
        _executing = NO;
    }
    return self;
}

- (void)start
{
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self main];
    });
}

- (void)main
{
    NSAssert(![self isMemberOfClass:[BaseOperation class]], @"BaseOperation is abstract class that must be subclassed");
    NSAssert(false, @"BaseOperation subclasses must override `main`.");
}

- (void)completeOperation
{
    self.executing = NO;
    self.finished  = YES;
}

#pragma mark - NSOperation methods

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL) isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
//    @synchronized(self) {
        return _executing;
//    }
}

- (BOOL)isFinished
{
//    @synchronized(self) {
        return _finished;
//    }
}

- (void)setExecuting:(BOOL)executing
{
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
//        @synchronized(self) {
            _executing = executing;
//        }
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
//    @synchronized(self) {
            _finished = finished;
//    }
    [self didChangeValueForKey:@"isFinished"];
}

@end

