//
//  ADAlertTitleLabel.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertTitleLabel.h"

@implementation ADAlertTitleLabel

- (CGSize)intrinsicContentSize
{
    if (self.text.length > 0) {
        CGSize size = [super intrinsicContentSize];
        size.width +=(self.textInset.left + self.textInset.right);
        size.height += (self.textInset.top + self.textInset.bottom);
        return size;
    }return [super intrinsicContentSize];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsUpdateConstraints];
}

@end
