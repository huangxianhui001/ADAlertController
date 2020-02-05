//
//  ADAlertGroupAction.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

/// 可将多个 AlertAction 当做一个AlertAction 来处理, TODO
@interface ADAlertGroupAction : ADAlertAction

@property (nonatomic, strong, readonly) NSArray<ADAlertAction *> *actions;

+ (nullable instancetype) groupActionWithActions:(NSArray<ADAlertAction *> *)actions;

@end

NS_ASSUME_NONNULL_END
