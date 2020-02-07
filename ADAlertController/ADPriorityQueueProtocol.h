//
//  ADPriorityQueueProtocol.h
//  ADAlertController
//
//  Created by Alan on 2020/2/6.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADAlertController;

typedef NS_ENUM(NSUInteger, ADAlertPriority) {
    ///默认层级
    ADAlertPriorityDefault = 10,
    ///高优先级
    ADAlertPriorityHight = 100,
    ///最高优先级
    ADAlertPriorityRequire = 1000,
};

/// AlertController 基本所需方法,包含显示和隐藏
@protocol ADAlertControllerBaseProtocol <NSObject>

- (void)show;

- (void)hiden;

@end

/// AlertController 实现优先级队列须遵循的协议,继承自ADAlertControllerBaseProtocol
@protocol ADAlertControllerPriorityQueueProtocol <ADAlertControllerBaseProtocol>

/// 优先级属性,可以设置任意从 0 到 NSUIntegerMax之间的任意数,不仅限于ADAlertPriority枚举内的三个数,
/// 但是需要自己把握优先级数,在队列中是比较此属性的值来排列优先级,值越大,越优先显示
@property (assign, nonatomic) ADAlertPriority alertPriority;
 
///当插入一个同优先级的 alertController 时,当前 alertController是否自动隐藏,
///一般配合deleteWhenHiden使用,使当前 自动隐藏的alertController后面还有机会显示,默认 NO
@property (nonatomic, assign) BOOL autoHidenWhenInsertSamePriority;

///当前alertController是否仅在targetViewController为最顶部的控制器时才显示,
///若有值,则仅当 targetViewController 为最顶层控制器,且当前 alertController 是队列中的最高优先级时才会显示,
///默认nil,表示在任意页面都可显示
@property (weak, nonatomic,nullable) UIViewController *targetViewController;

/// 当targetViewController有值,且 alertController已经显示了,若targetViewController即将消失了,当前 alertController 是否要自动隐藏,默认 YES
@property (assign, nonatomic) BOOL autoHidenWhenTargetViewControllerDisappear;


/// 入优先级队列去等待显示
- (void)enqueue;

/// 清空优先级队列中的所有对象
+ (void)cleanQueueAllObject;
@end


NS_ASSUME_NONNULL_END
