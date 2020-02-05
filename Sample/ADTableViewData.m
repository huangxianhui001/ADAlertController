//
//  ADTableViewData.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADTableViewData.h"

@interface ADTableViewData()

@property (nonatomic, copy,readwrite) NSString *title;
@property (nonatomic, strong,readwrite) NSString *selector;
@end

@implementation ADTableViewData

+ (instancetype)dataWithTitle:(NSString *)title selector:(NSString *)selector
{
    ADTableViewData *data = [[ADTableViewData alloc] init];
    data.title = title;
    data.selector = selector;
    return data;
}
@end
