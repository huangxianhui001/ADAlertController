//
//  ADAlertController+KeyboardSupport.h
//  ADAlertController
//
//  Created by huangxh on 2020/3/6.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertController ()

@property (weak, nonatomic) NSLayoutConstraint *alertViewBackgroundViewVerticalCenteringConstraint;

@property (weak, nonatomic) UITextField *currentActiveTextField;

@property (nonatomic, assign) CGFloat translationY;

@property (nonatomic, assign) CGFloat animateDuration;

@property (nonatomic, assign) UIViewAnimationOptions animteOption;
@end

@interface ADAlertController (KeyboardSupport)

@property (weak, nonatomic,readonly) UIWindow *textEffectsWindow;

- (void)addObserverKeyboardNotification;

- (void)removeObserverKeyboardNotification;
@end

NS_ASSUME_NONNULL_END
