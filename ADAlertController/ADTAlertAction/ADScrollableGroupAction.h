//
//  ADScrollableGroupAction.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertGroupAction.h"

NS_ASSUME_NONNULL_BEGIN

/// 可滑动的 GroupAction
@interface ADScrollableGroupAction : ADAlertGroupAction

+ (instancetype) scrollableGroupActionWithActions:(NSArray<ADAlertAction *> *)actions;

+ (instancetype) scrollableGroupActionWithActionWidth:(CGFloat )actionWidth actions:(NSArray<ADAlertAction *> *)actions;

@end

NS_ASSUME_NONNULL_END
