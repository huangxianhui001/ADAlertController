//
//  ADCustomAlertContentViewProtocol.h
//  ADAlertController
//
//  Created by Alan on 2020/2/3.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ADAlertController;

@protocol ADCustomAlertContentViewProtocol <NSObject>

@property (assign, nonatomic,readonly) CGFloat contentViewHeight;

@property (weak, nonatomic) ADAlertController *alertController;

- (void)show;

- (void)hiden;

@end


NS_ASSUME_NONNULL_END
