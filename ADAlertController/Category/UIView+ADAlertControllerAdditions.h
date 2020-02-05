//
//  UIView+ADAlertControllerAdditions.h
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ADAlertControllerAdditions)

- (void)ad_pinEdgesToSuperviewEdges;
- (void)ad_pinEdgesToSuperviewMargins;

@end

NS_ASSUME_NONNULL_END
