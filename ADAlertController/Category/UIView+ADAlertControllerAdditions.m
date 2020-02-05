//
//  UIView+ADAlertControllerAdditions.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "UIView+ADAlertControllerAdditions.h"


@implementation UIView (ADAlertControllerAdditions)

- (void)ad_pinEdgesToSuperviewEdges {
    NSAssert(self.superview, @"Superview must be nonnull");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
}

- (void)ad_pinEdgesToSuperviewMargins {
    NSAssert(self.superview, @"Superview must be nonnull");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.bottomAnchor].active = YES;
}
@end
