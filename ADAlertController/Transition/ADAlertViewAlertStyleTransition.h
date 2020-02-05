//
//  ADAlertViewAlertStyleTransition.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ADAlertControllerConst.h"

NS_ASSUME_NONNULL_BEGIN

/// alert 类型的转场动画实现者
@interface ADAlertViewAlertStyleTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) ADAlertControllerTransitionStyle transitionStyle;
@end

NS_ASSUME_NONNULL_END
