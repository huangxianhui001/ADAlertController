//
//  ADAlertController+Private.m
//  ADAlertController
//
//  Created by Alan on 2020/2/7.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController+Private.h"
#import "UIViewController+ADAlertControllerTopVisible.h"

@implementation ADAlertController (Private)

- (BOOL)canShow
{
    UIViewController *topVisibleVC = [UIViewController ad_topVisibleViewController];
    if (self.targetViewController) {
        return topVisibleVC == self.targetViewController;
    }
    return YES;
}

- (BOOL)isShow
{
    return !!self.presentingViewController;
}

@end
