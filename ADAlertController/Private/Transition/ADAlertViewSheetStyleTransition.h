//
//  ADAlertViewSheetStyleTransition.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAlertControllerConst.h"

NS_ASSUME_NONNULL_BEGIN

/**
 actionsheet 类型的转场动画代理
 */
@interface ADAlertViewSheetStyleTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) ADAlertControllerTransitionStyle transitionStyle;

@end

NS_ASSUME_NONNULL_END


