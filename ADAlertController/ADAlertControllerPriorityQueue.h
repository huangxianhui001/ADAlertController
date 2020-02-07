//
//  ADAlertControllerPriorityQueue.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADPriorityQueueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/// 用最大堆来实现优先级队列,存储逻辑是使用一个可变数组来保存所有节点,当插入一个节点元素时,进行上滤,使之保持结构完整性
/// 删除时,从最顶部删除最大的那个节点,然后从队列末尾处取出放到最顶部,并进行下滤,保持最大堆的完整性
@interface ADAlertControllerPriorityQueue : NSObject

@end

@interface ADAlertControllerPriorityQueue (HeapBehaviour)

+ (void)inset:(id<ADAlertControllerPriorityQueueProtocol>)element;

+ (id<ADAlertControllerPriorityQueueProtocol>)getMax;

+ (id<ADAlertControllerPriorityQueueProtocol>)deleteMax;

+ (id<ADAlertControllerPriorityQueueProtocol>)deleteAtIndex:(NSUInteger)deleteIndex;

@end

@interface ADAlertControllerPriorityQueue (ADExtention)
+ (void)cleanQueueAllObject;

@end
NS_ASSUME_NONNULL_END


