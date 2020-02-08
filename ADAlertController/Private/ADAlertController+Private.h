//
//  ADAlertController+Private.h
//  ADAlertController
//
//  Created by Alan on 2020/2/7.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController.h"

NS_ASSUME_NONNULL_BEGIN

/// 优先级队列需要用到的,但是又不便公开的属性,放到此私有文件中
@interface ADAlertController (Private)

/// 在 alertController执行完 dismiss 之后调用的 block,用于通知优先级队列准备去显示下一个队列中的内容
@property (copy, nonatomic,nullable) void(^didDismissBlock)(ADAlertController * _Nonnull alertController);

///当 alertController 隐藏时是否从优先级队列中移除,默认 YES,仅在显示时被其他高优先级覆盖时才置为 NO
@property (nonatomic, assign) BOOL deleteWhenHiden;

///判断是否能显示,若设置了targetViewController并且当前最顶层控制器不为targetViewController时,返回  NO,否则默认返回 YES
@property (nonatomic, readonly) BOOL canShow;

/**
 是否正在显示,仅在页面完全显示时才会为 YES,其余情况为 NO
 */
@property (readonly, nonatomic) BOOL isShow;

/**
 是否不显示,因为在显示时是有个异步的过程,如果在还没显示时,后面又进来了一个更高优先级的警告框,那么需要将这个置为 YES,后面就不会再弹出当前警告框了,并会执行didDismissBlock
 */
@property (assign, nonatomic) BOOL donotShow;

@end

NS_ASSUME_NONNULL_END
