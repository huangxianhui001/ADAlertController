//
//  ADAlertTextView.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertTextView.h"

@interface ADAlertTextView ()

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation ADAlertTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];

    if (self) {
        self.heightConstraint = [self.heightAnchor constraintEqualToConstant:0.0f];
        self.heightConstraint.priority = UILayoutPriorityDefaultHigh;
        self.heightConstraint.active = YES;

        self.textContainerInset = UIEdgeInsetsZero;
    }

    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];

    [self updateHeightConstraint];
}

- (void)updateHeightConstraint {
    if (self.text.length > 0) {
        self.heightConstraint.constant = [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height;
    }else{
        self.heightConstraint.constant = 0;
        self.textContainerInset = UIEdgeInsetsZero;
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;

    [super setBounds:bounds];

    if (!CGSizeEqualToSize(oldBounds.size, bounds.size)) {
        [self updateHeightConstraint];
    }
}

@end
