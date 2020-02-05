//
//  ADAdvertView.h
//  ADAlertController
//
//  Created by Alan on 2020/2/3.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCustomAlertContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class ADAdvertView;

@protocol ADAdvertViewDelegate <NSObject>

- (void)advertView:(ADAdvertView *)view didSelectItemAtIndex:(NSUInteger)index;

@end

@interface ADAdvertView : UIView<ADCustomAlertContentViewProtocol>

@property (weak, nonatomic,readonly) id<ADAdvertViewDelegate> delegate;
@property (nonatomic, strong,readonly) NSArray *advertDataList;

+ (instancetype)advertViewWithDelegate:(id<ADAdvertViewDelegate>)delegate dataArray:(NSArray *)dataArray;

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end


NS_ASSUME_NONNULL_END
