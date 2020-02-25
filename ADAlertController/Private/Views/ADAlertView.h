//
//  ADAlertView.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAlertControllerViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertView : UIView<ADAlertControllerViewProtocol>

/**
 用于手势拖动 alertview 时,改变约束,实现动画
 */
@property (nonatomic, readonly) NSLayoutConstraint *backgroundViewVerticalCenteringConstraint;


@end

NS_ASSUME_NONNULL_END
