//
//  ADAlertActionConfiguration.h
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAlertControllerConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAlertActionConfiguration : NSObject<NSCopying>

/**
 alertAction 显示的标题字体,默认为[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
  alertAction 显示的标题颜色,默认为[UIColor darkGrayColor],若为ADActionStyleDestructive,默认为[UIColor redColor]
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
  alertAction 不可用时的标题颜色,默认为[UIColor grayColor]的 0.6 透明度颜色,若为ADActionStyleDestructive,默认为[UIColor redColor]
 */
@property (strong, nonatomic) UIColor *disabledTitleColor;

+ (ADAlertActionConfiguration *)defaultConfigurationWithActionStyle:(ADActionStyle)style;
@end

NS_ASSUME_NONNULL_END
