//
//  ADPickerView.h
//  ADAlertController
//
//  Created by Alan on 2020/2/5.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCustomAlertContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ADPickerViewDatasource;
@protocol ADPickerViewDelegate;

/// 自定义选择器视图,可支持最多选择三列
@interface ADPickerView : UIView<ADCustomAlertContentViewProtocol>
///第一列选中下标,
@property (assign, nonatomic) NSInteger firstColSelectRowIndex;
///第二列选中下标
@property (assign, nonatomic) NSInteger secondColSelectRowIndex;
///第三列选中下标
@property (assign, nonatomic) NSInteger thirdColSelectRowIndex;

@property (nonatomic, assign) BOOL needAutoScrollToPreviouSelectIndex;

@property (weak, nonatomic) id<ADPickerViewDatasource> pickerViewDatasource;

@property (weak, nonatomic) id<ADPickerViewDelegate> delegate;

@property (copy, nonatomic) void(^onSureCallback)(NSUInteger firstColSelectRowIndex, NSUInteger secondColSelectRowIndex, NSUInteger thirdColSelectRowIndex);

+ (instancetype) pickerViewWithTitle:(NSString *)title
                          datasource:(id<ADPickerViewDatasource>)datasource;

- (NSInteger)selectedRowInComponent:(NSInteger)component;

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

@protocol ADPickerViewDatasource <NSObject>
@required

- (NSInteger)numberOfComponentsInPickerView:(ADPickerView *)pickerView;

- (NSInteger)pickerView:(ADPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(ADPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@protocol ADPickerViewDelegate <NSObject>

- (void)pickerView:(ADPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


NS_ASSUME_NONNULL_END
