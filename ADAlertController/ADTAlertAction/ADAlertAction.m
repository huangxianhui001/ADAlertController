//
//  ADAlertAction.m
//  ADAlertController
//
//  Created by Alan on 2020/2/1.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertAction.h"
#import "ADAlertAction+Private.h"
#import "ADAlertButton.h"

@interface ADAlertAction ()

@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, readwrite, nullable) UIImage *image;
@property (nonatomic, readwrite) ADActionStyle style;
@property (nonatomic, readwrite, nullable) ADAlertActionConfiguration *configuration;

@property (nonatomic, readwrite) UIView *view;

@property (nonatomic, strong) UIButton *button;
@end

@implementation ADAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ADActionStyle)style handler:(ADAlertActionHandler)handler{
    return [[self class] actionWithTitle:title image:nil style:style handler:handler configuration:nil];
}

+ (instancetype)actionWithTitle:(NSString *)title style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    return [[self class] actionWithTitle:title image:nil style:style handler:handler configuration:configuration];
}

+ (instancetype)actionWithImage:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler {
    
     return [[self class] actionWithTitle:nil image:image style:style handler:handler configuration:nil];
}

+ (instancetype)actionWithImage:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    return [[self class] actionWithTitle:nil image:image style:style handler:handler configuration:configuration];
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler{
     return [[self class] actionWithTitle:title image:image style:style handler:handler configuration:nil];
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    ADAlertAction *action = [[[self class] alloc] init];
    action.title = title;
    action.image = image;
    action.style = style;
    [action setHandler:^(ADAlertAction *actionInBlock) {
        if (handler) {
            handler(actionInBlock);
        }
        [actionInBlock.viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    action.configuration = [configuration copy]?:[ADAlertActionConfiguration defaultConfigurationWithActionStyle:style];

    return action;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = YES;
    }

    return self;
}

#pragma mark - View
- (UIView *)view {
    if(!_view) {
        _view = [self loadView];
        _view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _view;
}

- (UIView *)loadView {
    
    ADAlertButton *actionButton = [ADAlertButton buttonWithType:UIButtonTypeCustom];
    [actionButton addTarget:self action:@selector(actionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setBackgroundImage:[self imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0]] forState:UIControlStateNormal];
    
    [actionButton setBackgroundImage:[self imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
    
    if(self.title) {
        [actionButton setTitle:self.title forState:UIControlStateNormal];
    } else if(self.image) {
        [actionButton setImage:self.image forState:UIControlStateNormal];
    }
    
    [actionButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton(>=minHeight)]" options:0 metrics:@{@"minHeight": @(44)} views:NSDictionaryOfVariableBindings(actionButton)]];
    
    ADAlertActionConfiguration *buttonConfiguration = self.configuration;
    
    [actionButton setTitleColor:buttonConfiguration.disabledTitleColor forState:UIControlStateDisabled];
    [actionButton setTitleColor:buttonConfiguration.titleColor forState:UIControlStateNormal];
    [actionButton setTitleColor:buttonConfiguration.titleColor forState:UIControlStateHighlighted];
    if (buttonConfiguration.titleFont) {
        actionButton.titleLabel.font = buttonConfiguration.titleFont;
    }
    
    self.button = actionButton;
    return actionButton;
}

- (void)actionTapped:(id)sender {
    self.handler(self);
}

#pragma mark - Other Helper
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - get and set
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.button.enabled = enabled;
    });
}

@end

@implementation ADAlertAction (UpdateTitle)

#pragma mark - ADActionUpdateTitleProtocol
- (void)updateActionTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.button setTitle:title forState:UIControlStateNormal];
        
    });
}
@end
