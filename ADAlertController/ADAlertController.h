//
//  ADAlertController.h
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAlertAction.h"
#import "ADAlertImageAction.h"
#import "ADAlertGroupAction.h"
#import "ADScrollableGroupAction.h"
#import "ADAlertControllerConst.h"
#import "ADAlertControllerConfiguration.h"
#import "ADPriorityQueueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertController : UIViewController<ADAlertControllerPriorityQueueProtocol>

/// 指定构造器,根据配置,标题,内容,按钮数组等初始化警告框对象
/// @param configuration 配置对象,可为 nil,默认是[ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert]
/// @param title 标题
/// @param message 消息内容
/// @param actions 按钮数组,需为 ADAlertAction 类型
- (instancetype)initWithOptions:(nullable ADAlertControllerConfiguration *)configuration
                          title:(nullable NSString *)title
                        message:(nullable NSString *)message
                        actions:(nullable NSArray<ADAlertAction *> *)actions NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 初始化警告控制器的配置信息,默认是 alert 类型
 */
@property (nonatomic, readonly) ADAlertControllerConfiguration *configuration;

/**
 是否正在显示,仅在页面完全显示时才会为 YES,其余情况为 NO
 */
@property (readonly, nonatomic) BOOL isShow;

/**
 显示在 titlelabel 下面的详细文本信息
 */
@property (nonatomic, nullable) NSString *message;

/**
 自定义内容视图,默认是nil,在 alert 类型时,是显示在 titlelab 上面,actionsheet 类型时,显示在 message 下面,外部需指定高度约束,
 默认写法:[contentView.heightAnchor constraintEqualToConstant:100].active = YES;宽度不得超过maximumWidth
 */
@property (nonatomic, nullable) UIView *alertViewContentView;

/**
 允许显示的背景内容最大宽度
 */
@property (nonatomic) CGFloat maximumWidth;

/**
 包含初始化时传入的所有ADAlertAction元素的数组, actionsheet 时,不包含最底下的取消按钮cancelAction
 @see addActionSheetCancelAction:
 */
@property (nonatomic, readonly,nullable) NSArray<ADAlertAction *> *actions;

/**
 通过addTextFieldWithConfigurationHandler添加的 textfield 数组,
 @see addTextFieldWithConfigurationHandler:
 */
@property (nonatomic, readonly,nullable) NSArray<UITextField *> *textFields;

/**
 给 alertview 类型添加 textfield,
 ⚠️目前暂未适配键盘遮挡问题!!!
 @param configurationHandler 用于配置textfield的block。该block将textfield对象作为参数，并且可以在显示之前修改textfield的属性。
 */
- (void)addTextFieldWithConfigurationHandler:(void (^_Nullable)(UITextField * _Nullable textField))configurationHandler;

/**
 添加 actionsheet 类型的取消按钮,用于显示在最底下的那个按钮

 @param cancelAction 取消按钮动作类型
 */
- (void)addActionSheetCancelAction:(ADAlertAction *_Nullable)cancelAction;

@end

NS_ASSUME_NONNULL_END
