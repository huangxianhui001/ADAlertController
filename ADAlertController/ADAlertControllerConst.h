//
//  ADAlertControllerConst.h
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///转场动画类型
typedef NS_ENUM(NSInteger, ADAlertControllerTransitionStyle) {
    ///presenting 转场类型
    ADAlertControllerTransitionStylePresenting,
    ///dismiss 转场类型
    ADAlertControllerTransitionStyleDismissing,
};

///alertController 显示的 UI样式
typedef NS_ENUM(NSUInteger, ADAlertControllerStyle) {
    ///alertview 类型
    ADAlertControllerStyleAlert,
    ///与 UIKit 的 actionSheet 类型类似,保持底部,左右边距为 8
    ADAlertControllerStyleActionSheet,
    ///左,右,底部边距为 0 的 actionSheet 类型
    ADAlertControllerStyleSheet,
};

///动作按钮类型,用于警告框视图的按钮,包含三种样式,default 类型是默认的,destructive 用于显示破坏性的操作,cancel 用于显示取消,
typedef NS_ENUM(NSUInteger, ADActionStyle) {
    ADActionStyleDefault,
    ADActionStyleDestructive,
    ADActionStyleCancel,
};


NS_ASSUME_NONNULL_END
