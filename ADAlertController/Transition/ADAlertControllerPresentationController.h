//
//  ADAlertControllerPresentationController.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertControllerPresentationController : UIPresentationController
@property (nonatomic) BOOL hidenWhenTapBackground;
@property UIColor *backgroundColor;
@property (nonatomic, readonly) UIView *backgroundView;
///背景是否毛玻璃,暂未实现
@property BOOL  backgroundViewBlurEffects;
@end

NS_ASSUME_NONNULL_END
