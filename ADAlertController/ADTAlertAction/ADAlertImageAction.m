//
//  ADAlertImageAction.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertImageAction.h"

@interface ADAlertImageAction ()
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ADAlertImageAction

#pragma mark - View
- (UIView *)loadView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    imageView.userInteractionEnabled = NO;
    imageView.image = self.image;
    self.imageView = imageView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.userInteractionEnabled = NO;
    titleLabel.text = self.title;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = self.configuration.titleColor;
    titleLabel.font = self.configuration.titleFont;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(actionTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [view addSubview:button];
    [view addSubview:imageView];
    [view addSubview:titleLabel];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view, button, imageView, titleLabel);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[imageView]-(10)-[titleLabel]-(10)-|" options:0 metrics:nil views:bindings]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=10)-[imageView]-(>=10)-|" options:0 metrics:nil views:bindings]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=10)-[titleLabel]-(>=10)-|" options:0 metrics:nil views:bindings]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[button]-(0)-|" options:0 metrics:nil views:bindings]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[button]-(0)-|" options:0 metrics:nil views:bindings]];
    
    self.label = titleLabel;
    
    self.label.textColor = self.enabled ? self.configuration.titleColor : self.configuration.disabledTitleColor;
    self.imageView.image = self.enabled ? self.image : [self disableImage];
    
    return view;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.label.textColor = enabled ? self.configuration.titleColor : self.configuration.disabledTitleColor;
    self.imageView.image = enabled ? self.image : [self disableImage];
    
}

- (UIImage *)disableImage
{
    return self.image;
    return [self image:self.image byTintColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
}

#pragma mark - ADTActionUpdateTitleProtocol
- (void)updateActionTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = title;
        
    });
}

- (UIImage *)image:(UIImage *)image byTintColor:(UIColor *)tinColor {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [tinColor set];
    UIRectFill(rect);
    [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
