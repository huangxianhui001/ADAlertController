//
//  ADAlertWindow.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSUInteger const ADAlertWindowLevel;

@interface ADAlertWindow : UIWindow

+ (instancetype)window;

- (void)presentViewController:(UIViewController *)viewController completion:(void(^__nullable)(void))completion;

- (void)cleanUpWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
