//
//  ADAlertView.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertView.h"
#import "ADAlertTitleLabel.h"
#import "ADAlertTextView.h"
#import "UIView+ADAlertControllerAdditions.h"
#import "ADAlertControllerConfiguration.h"

@interface ADAlertView ()
///标题 label
@property (nonatomic) ADAlertTitleLabel *titleLabel;
///内容 textview
@property (nonatomic) UITextView *messageTextView;
@property (nonatomic) UIView *contentViewContainerView;
@property (nonatomic) UIView *textFieldContainerView;
@property (nonatomic) UIView *actionButtonContainerView;
@property (nonatomic) UIStackView *actionButtonStackView;
///分割线,无按钮时隐藏
@property (weak, nonatomic) UIView *separatorView;

@property (nonatomic,readwrite) UIView *backgroundContainerView;

@property (nonatomic) NSLayoutConstraint *alertBackgroundWidthConstraint;

@property (nonatomic) ADAlertControllerConfiguration *configuration;
@end

@implementation ADAlertView
@dynamic title;
@dynamic message;
@synthesize contentView = _contentView;
@synthesize actionButtons = _actionButtons;
@synthesize maximumWidth = _maximumWidth;
@synthesize textFields = _textFields;

- (instancetype)initWithConfiguration:(ADAlertControllerConfiguration *)configuration {
    self = [super init];
    
    if (self) {
        _configuration = configuration;
        self.maximumWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) * 0.77;
        
        _backgroundContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundContainerView.clipsToBounds = YES;
        self.backgroundContainerView.layer.cornerRadius = configuration.alertViewCornerRadius;
        self.backgroundContainerView.backgroundColor = configuration.alertContainerViewBackgroundColor;
        self.backgroundContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundContainerView];
        
        //title
        _titleLabel = [[ADAlertTitleLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textInset = UIEdgeInsetsMake(20, 0, 10, 0);
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.titleLabel.numberOfLines = 2;
        if (configuration.titleFont) {
            self.titleLabel.font = configuration.titleFont;
        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = configuration.titleTextColor;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:self.titleLabel];
        
        //messageTextView
        _messageTextView = [[ADAlertTextView alloc] initWithFrame:CGRectZero];
        [self.messageTextView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        [self.messageTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        self.messageTextView.backgroundColor = [UIColor clearColor];
        self.messageTextView.editable = NO;
        self.messageTextView.selectable = NO;
        self.messageTextView.textAlignment = NSTextAlignmentCenter;
        self.messageTextView.textColor = configuration.messageTextColor;
        if (configuration.messageFont) {
            self.messageTextView.font = configuration.messageFont;
        }
        self.messageTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:self.messageTextView];
        
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:self.contentViewContainerView];
        
        _textFieldContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.textFieldContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.textFieldContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:self.textFieldContainerView];
        
        _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.actionButtonContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.actionButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:self.actionButtonContainerView];
        
        _actionButtonStackView = [[UIStackView alloc] init];
        [self.actionButtonStackView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.actionButtonContainerView addSubview:self.actionButtonStackView];
        [self.actionButtonStackView ad_pinEdgesToSuperviewEdges];
        
        if (self.configuration.showsSeparators) {
            UIView *separatorView = [[UIView alloc] init];
            separatorView.backgroundColor = self.configuration.separatorColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.backgroundContainerView addSubview:separatorView];
            [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            [separatorView.leadingAnchor constraintEqualToAnchor:separatorView.superview.leadingAnchor].active = YES;
            [separatorView.trailingAnchor constraintEqualToAnchor:separatorView.superview.trailingAnchor].active = YES;
            [separatorView.bottomAnchor constraintEqualToAnchor:self.actionButtonStackView.topAnchor].active = YES;
            self.separatorView = separatorView;
        }
        
        //添加约束
        //backgroundContainerView.CenterX
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        //backgroundContainerView.width
        _alertBackgroundWidthConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0f
                                                                        constant:self.maximumWidth];
        
        [self addConstraint:self.alertBackgroundWidthConstraint];
        //backgroundContainerView.centerY
        _backgroundViewVerticalCenteringConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeCenterY
                                                                                 multiplier:1.0f
                                                                                   constant:0.0f];
        
        [self addConstraint:self.backgroundViewVerticalCenteringConstraint];
        
        //backgroundContainerView.height<= self.height*0.9
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.9f
                                                          constant:0.0f]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_messageTextView]-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_messageTextView)]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentViewContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_contentViewContainerView)]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textFieldContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_textFieldContainerView)]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_actionButtonContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_actionButtonContainerView)]];
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentViewContainerView(0@250)]-0-[_titleLabel]-0-[_messageTextView]-0-[_textFieldContainerView(0@250)]-0-[_actionButtonContainerView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                                _messageTextView,
                                                                                                                                _contentViewContainerView,
                                                                                                                                _textFieldContainerView,
                                                                                                                                _actionButtonContainerView)]];
    }
    
    return self;
}


// Pass through touches outside the backgroundView for the presentation controller to handle dismissal
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - ADTAlertControllerViewProtocol

- (void)setMaximumWidth:(CGFloat)maximumWidth {
    _maximumWidth = maximumWidth;
    self.alertBackgroundWidthConstraint.constant = maximumWidth;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setMessage:(NSString *)message
{
    self.messageTextView.textContainerInset = self.configuration.messageTextInset;
    self.messageTextView.text = message;
}

- (NSString *)message{
    return self.messageTextView.text;
}

- (void)setContentView:(UIView *)contentView {
    [self.contentView removeFromSuperview];
    
    _contentView = contentView;
    
    if (contentView) {
        self.contentViewContainerView.layoutMargins = self.configuration.contentViewInset;
        [self.contentViewContainerView addSubview:self.contentView];
        [self.contentView ad_pinEdgesToSuperviewMargins];
    }
}

- (void)setTextFields:(NSArray *)textFields {
    for (UITextField *textField in self.textFields) {
        [textField removeFromSuperview];
    }

    _textFields = textFields;

    for (int i = 0; i < [textFields count]; i++) {
        UITextField *textField = textFields[i];
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.textFieldContainerView addSubview:textField];

        [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(textField)]];

        // Pin the first text field to the top of the text field container view
        if (i == 0) {
            [textField.topAnchor constraintEqualToAnchor:self.textFieldContainerView.layoutMarginsGuide.topAnchor].active = YES;
        } else {
            UITextField *previousTextField = textFields[i - 1];

            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousTextField]-[textField]"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:NSDictionaryOfVariableBindings(previousTextField, textField)]];
        }

        // Pin the final text field to the bottom of the text field container view
        if (i == ([textFields count] - 1)) {
            [self.textFieldContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField]-8-|"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:NSDictionaryOfVariableBindings(textField)]];
        }
    }
}

- (void)setActionButtons:(NSArray *)actionButtons {
    for (UIView *view  in self.actionButtonStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }

    _actionButtons = actionButtons;
    
    if (actionButtons.count == 0) {
        self.separatorView.hidden = YES;
        return;
    }
    self.separatorView.hidden = NO;
    // If there are 2 actions, display the buttons next to each other. Otherwise, stack the buttons vertically at full width
    if (actionButtons.count == 2 && !self.configuration.alwaysArrangesActionButtonsVertically) {
        self.actionButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        self.actionButtonStackView.axis = UILayoutConstraintAxisVertical;
    }

    [actionButtons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.configuration.showsSeparators && idx > 0) {
            // Add separator view
            UIView *separatorView = [[UIView alloc] init];
            separatorView.backgroundColor = self.configuration.separatorColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;

            if (self.actionButtonStackView.axis == UILayoutConstraintAxisVertical) {
                [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            } else {
                [separatorView.widthAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            }

            [self.actionButtonStackView addArrangedSubview:separatorView];
        }

        [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.actionButtonStackView addArrangedSubview:button];

        if (idx > 0) {
            UIButton *previousButton = actionButtons[idx - 1];
            [button.widthAnchor constraintEqualToAnchor:previousButton.widthAnchor multiplier:1.0f].active = YES;
            [button.heightAnchor constraintEqualToAnchor:previousButton.heightAnchor multiplier:1.0f].active = YES;
        }
    }];
}

- (void)addCancelView:(UIView *)cancelView
{
    
}
@end
