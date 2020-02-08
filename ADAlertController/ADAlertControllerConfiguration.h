//
//  ADAlertControllerConfiguration.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAlertActionConfiguration.h"
#import "ADAlertControllerConst.h"

NS_ASSUME_NONNULL_BEGIN

/// 警告框的 UI 配置
@interface ADAlertControllerConfiguration : NSObject<NSCopying>

/**
 alertController 类型,默认 alert类型
 */
@property (assign, nonatomic,readonly) ADAlertControllerStyle preferredStyle;

/**
 点击背景是否关闭警告框视图,默认 NO
 */
@property (nonatomic) BOOL hidenWhenTapBackground;

/**
 针对 alert 类型视图,是否允许手势滑动关闭警告框视图,默认 NO
 */
@property (nonatomic) BOOL swipeDismissalGestureEnabled;

/**
  针对alert 类型视图,若只有两个按钮时,是否总是垂直排列,默认 NO
 */
@property (nonatomic) BOOL alwaysArrangesActionButtonsVertically;

/**
 覆盖在最底下的蒙版 view 的背景色,默认0.5透明度的黑色
 */
@property (strong, nonatomic) UIColor *alertMaskViewBackgroundColor;

/**
 内容容器视图背景色,默认白色
 */
@property (nonatomic) UIColor *alertContainerViewBackgroundColor;

/**
 内容容器视图圆角,默认4
 */
@property (nonatomic) CGFloat alertViewCornerRadius;

/**
 标题文本颜色,默认系统颜色
 */
@property (nonatomic) UIColor *titleTextColor;

/**
 详细消息文本颜色,默认系统颜色
 */
@property (nonatomic) UIColor *messageTextColor;

/**
 在按钮周围是否显示分割线,默认 NO
 */
@property (nonatomic) BOOL showsSeparators;

/**
  分割线颜色,默认[UIColor lightGrayColor]
 */
@property (nonatomic) UIColor *separatorColor;

/**
内部自定义 view 四周边距
 */
@property (nonatomic) UIEdgeInsets contentViewInset;

/**
 messageText 四周边距
 */
@property (nonatomic) UIEdgeInsets messageTextInset;

/**
 标题文本字体,默认[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
 */
@property (nonatomic) UIFont *titleFont;

/**
 详细消息文本字体,默认是[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
 */
@property (nonatomic) UIFont *messageFont;

/**
 背景是否需要模糊效果,默认YES,未实现
 */
//@property (assign, nonatomic) BOOL backgroundViewBlurEffects;

/**
 根据alertview 类型,生成不同配置对象

 @param preferredStyle alertview类型
 @return 默认配置对象
 */
+ (instancetype)defaultConfigurationWithPreferredStyle:(ADAlertControllerStyle )preferredStyle;

- (instancetype)initWithPreferredStyle:(ADAlertControllerStyle)preferredStyle;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
