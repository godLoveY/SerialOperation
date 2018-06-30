//
//  SerialOperationQueue.h
//  TestProgect
//
//  Created by 尧德仁 on 2018/6/30.
//  Copyright © 2018年 尧德仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerialOperationQueue : NSOperationQueue

/**
 @brief 通过name来获取队列，没有则返回nil
 */
+ (instancetype)serialQueueWithName:(NSString*)name;

/**
 @brief 通过name来创建队列
 */
+ (instancetype)createQueueWithName:(NSString*)name;

@end
