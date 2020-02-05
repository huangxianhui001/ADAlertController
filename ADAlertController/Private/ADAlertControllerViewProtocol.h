//
//  ADAlertControllerViewProtocol.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADAlertControllerConfiguration;

///alertController 的自定义 view 遵循的协议
@protocol ADAlertControllerViewProtocol <NSObject>
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;

///最大宽度
@property (nonatomic) CGFloat maximumWidth;

///所有UI 元素的容器视图
@property (strong, nonatomic,readonly) UIView *backgroundContainerView;

///自定义 contentview,可自定义,需指定高度约束,宽度不指定,会自动与maximumWidth保持一致
@property (nonatomic) UIView *contentView;

///包含按钮的所有数组,actionsheet类型时不包含取消按钮,要通过-addCancelButton:添加
@property (nonatomic) NSArray<UIButton *> *actionButtons;

///textfield 数组, 仅限在ADAlertControllerStyleAlert中有效
@property (nonatomic) NSArray<UITextField *> *textFields;

- (instancetype)initWithConfiguration:(ADAlertControllerConfiguration *)configuration ;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)addCancelView:(UIView *)cancelView;
@end
