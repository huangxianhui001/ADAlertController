//
//  ADAlertActionConfiguration.m
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertActionConfiguration.h"

@implementation ADAlertActionConfiguration

+ (ADAlertActionConfiguration *)defaultConfigurationWithActionStyle:(ADActionStyle)style
{
    ADAlertActionConfiguration *config = [[ADAlertActionConfiguration alloc] init];
    switch (style) {
        case ADActionStyleDestructive:{
            config.titleColor = [UIColor redColor];
            config.disabledTitleColor = [UIColor redColor];
            }break;
        default:
            break;
    }return config;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _titleColor = [UIColor darkGrayColor];
        _disabledTitleColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAlertActionConfiguration *config = [[self class] allocWithZone:zone];
    config.titleFont = self.titleFont;
    config.titleColor = self.titleColor;
    config.disabledTitleColor = self.disabledTitleColor;
    return config;
}
@end
