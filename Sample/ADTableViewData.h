//
//  ADTableViewData.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADTableViewData : NSObject

@property (nonatomic, copy,readonly) NSString *title;
@property (nonatomic, strong,readonly) NSString *selector;

+ (instancetype)dataWithTitle:(NSString *)title selector:(NSString *)selector;

@end

NS_ASSUME_NONNULL_END
