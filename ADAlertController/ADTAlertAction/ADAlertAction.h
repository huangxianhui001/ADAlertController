//
//  ADAlertAction.h
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAlertActionConfiguration.h"
#import "ADAlertControllerConst.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ADActionUpdateTitleProtocol <NSObject>

- (void)updateActionTitle:(NSString *)title;

@end

@class ADAlertAction;

typedef void(^ADAlertActionHandler)(__kindof ADAlertAction * action);

/**
 alertController 按钮动作配置,会在内部生成按钮;
 标题图片二选一显示,若同时配置了标题和图片,则忽略图片仅显示标题;
 若需要自定义按钮布局或者同时显示标题图片,可继承此类,并重写-loadView方法;
 具体写法可参考可使用子类 ADAlertImageAction
 */
@interface ADAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler;

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler
                  configuration:(nullable ADAlertActionConfiguration *)configuration;

+ (instancetype)actionWithImage:(nullable UIImage *)image
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler;

+ (instancetype)actionWithImage:(nullable UIImage *)image
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler
                  configuration:(nullable ADAlertActionConfiguration *)configuration;

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          image:(nullable UIImage *)image
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler;

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          image:(nullable UIImage *)image
                          style:(ADActionStyle)style
                        handler:(nullable ADAlertActionHandler)handler
                  configuration:(nullable ADAlertActionConfiguration *)configuration;


@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, readonly, nullable) UIImage *image;
@property (nonatomic, readonly) ADActionStyle style;
@property (nonatomic, copy, readonly, nullable) void (^handler)(__kindof ADAlertAction * _Nonnull action);
@property (nonatomic, readonly, nullable) ADAlertActionConfiguration *configuration;
///按钮是否可用,一般用在包含 textfield 时,禁用某个按钮等
@property (nonatomic) BOOL enabled;
///用于在点击按钮后,主动 dismiss 用
@property (nonatomic, weak, readonly, nullable) UIViewController *viewController;

@property (nonatomic, readonly) UIView *view;

/**
 *  第一次访问 view 属性时会加载该方法,不应该外部手动调用该方法,可于子类中重写此方法,来实现自定义 view
 */
- (UIView *)loadView;

/**
 *   当要触发handler回调时,可以调用此方法,一般用于子类中手动调用,你不应该手动调用此方法
 */
- (void)actionTapped:(nullable id)sender;

@end

/// 实现更新标题协议,可以在显示时动态更改标题
@interface ADAlertAction (UpdateTitle)<ADActionUpdateTitleProtocol>

@end

NS_ASSUME_NONNULL_END
    
