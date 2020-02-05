//
//  ADAlertControllerConfiguration.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertControllerConfiguration.h"

@interface ADAlertControllerConfiguration ()
@property (assign, nonatomic,readwrite) ADAlertControllerStyle preferredStyle;
@end

@implementation ADAlertControllerConfiguration

- (instancetype)initWithPreferredStyle:(ADAlertControllerStyle)preferredStyle
{
    self = [super init];
    if (self) {
        self.preferredStyle = preferredStyle;
    }return self;
}

+ (instancetype)defaultConfigurationWithPreferredStyle:(ADAlertControllerStyle)preferredStyle
{
    ADAlertControllerConfiguration *config = [[ADAlertControllerConfiguration alloc] initWithPreferredStyle:preferredStyle];
    config.alertContainerViewBackgroundColor = [UIColor whiteColor];
    config.alertMaskViewBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    if (preferredStyle != ADAlertControllerStyleSheet) {
        config.alertViewCornerRadius = 4;
        
    }
    
    config.separatorColor = [UIColor lightGrayColor];
    config.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    config.messageFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    config.backgroundViewBlurEffects = YES;
    return config;
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAlertControllerConfiguration *config = [[[self class] allocWithZone:zone] init];
    config.preferredStyle = self.preferredStyle;
    config.hidenWhenTapBackground = self.hidenWhenTapBackground;
    config.swipeDismissalGestureEnabled = self.swipeDismissalGestureEnabled;
    config.alwaysArrangesActionButtonsVertically = self.alwaysArrangesActionButtonsVertically;
    config.alertContainerViewBackgroundColor = self.alertContainerViewBackgroundColor;
    config.alertMaskViewBackgroundColor = self.alertMaskViewBackgroundColor;
    config.alertViewCornerRadius = self.alertViewCornerRadius;
    config.titleTextColor = self.titleTextColor;
    config.messageTextColor = self.messageTextColor;
    config.showsSeparators = self.showsSeparators;
    config.separatorColor = self.separatorColor;
    config.contentViewInset = self.contentViewInset;
    config.messageTextInset = self.messageTextInset;
    config.titleFont = self.titleFont;
    config.messageFont = self.messageFont;
    config.backgroundViewBlurEffects = self.backgroundViewBlurEffects;
    return config;
}
@end
