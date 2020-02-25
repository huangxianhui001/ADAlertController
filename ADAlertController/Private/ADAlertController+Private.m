//
//  ADAlertController+Private.m
//  ADAlertController
//
//  Created by Alan on 2020/2/7.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController+Private.h"
#import "UIViewController+ADAlertControllerTopVisible.h"
#import <objc/runtime.h>


@implementation ADAlertController (Private)

- (void)setDidDismissBlock:(void (^)(ADAlertController * _Nonnull))didDismissBlock
{
    objc_setAssociatedObject(self, @selector(didDismissBlock), didDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(ADAlertController * _Nonnull))didDismissBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDeleteWhenHiden:(BOOL)deleteWhenHiden
{
    objc_setAssociatedObject(self, @selector(deleteWhenHiden), @(deleteWhenHiden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)deleteWhenHiden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

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

- (void)setDonotShow:(BOOL)donotShow
{
    objc_setAssociatedObject(self, @selector(donotShow), @(donotShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)donotShow
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
