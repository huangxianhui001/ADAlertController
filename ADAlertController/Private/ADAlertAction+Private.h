//
//  ADAlertAction+Private.h
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertAction ()
@property (nonatomic, weak, readwrite, nullable) UIViewController *viewController;
@property (nonatomic, copy, readwrite, nullable) void (^handler)(__kindof ADAlertAction * _Nonnull action);

@end

NS_ASSUME_NONNULL_END
