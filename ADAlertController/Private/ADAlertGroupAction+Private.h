//
//  ADAlertGroupAction+Private.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertGroupAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertGroupAction ()

/// 是否显示分割线
@property (nonatomic) BOOL showsSeparators;
/// 分割线颜色
@property (nonatomic,nullable) UIColor *separatorColor;
@end

NS_ASSUME_NONNULL_END
