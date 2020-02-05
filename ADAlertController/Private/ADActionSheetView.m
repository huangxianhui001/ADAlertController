//
//  ADActionSheetView.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADActionSheetView.h"
#import "ADAlertTitleLabel.h"
#import "ADAlertTextView.h"
#import "UIView+ADAlertControllerAdditions.h"
#import "ADAlertControllerConfiguration.h"


///actionsheet 风格的左右边距大小
static CGFloat const ADActionSheetStyleLeadingTrailingPad = 10;
///actionsheet 风格的底部边距
static CGFloat const ADActionSheetStyleBottomMargin = 20;
///actionsheet 风格的取消按钮与内容视图的边距
static CGFloat const ADActionSheetStyleCancelButtonTopMargin = 10;
///无具体指定边距时的各个父视图默认边距大小
static CGFloat const ADActionSheetDefaultPad = 8;

@interface ADActionSheetView()
///标题 label
@property (nonatomic) ADAlertTitleLabel *titleLabel;
///内容 textview
@property (nonatomic) UITextView *messageTextView;
@property (nonatomic) UIView *contentViewContainerView;
@property (nonatomic) UIView *actionButtonContainerView;
@property (nonatomic) UIStackView *actionButtonStackView;
///分割线
@property (weak, nonatomic) UIView *separatorView;

@property (strong, nonatomic,readwrite) UIView *backgroundContainerView;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIView *bottomView;

///放在 Bottomview 的按钮
@property (weak, nonatomic) UIView *cancelView;

@property (nonatomic) NSLayoutConstraint *alertBackgroundWidthConstraint;

@property (strong, nonatomic) NSArray<__kindof NSLayoutConstraint *> *bottomViewBottomSpaceConstraints;

@property (nonatomic) ADAlertControllerConfiguration *configuration;
@end

@implementation ADActionSheetView
@dynamic title;
@dynamic message;
@synthesize contentView = _contentView;
@synthesize actionButtons = _actionButtons;
@synthesize maximumWidth = _maximumWidth;
@dynamic textFields;

- (instancetype)initWithConfiguration:(ADAlertControllerConfiguration *)configuration {
    self = [super init];
    if(self){

        _configuration = configuration;
        ///默认最大宽度是屏幕宽度减去20
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
        if (configuration.preferredStyle == ADAlertControllerStyleActionSheet) {
            maxWidth -= (ADActionSheetStyleLeadingTrailingPad * 2);
        }
        self.maximumWidth = maxWidth;
        
        _backgroundContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundContainerView.clipsToBounds = YES;
        self.backgroundContainerView.layer.cornerRadius = configuration.alertViewCornerRadius;
        self.backgroundContainerView.backgroundColor = [UIColor clearColor];
        self.backgroundContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundContainerView];
        
        //顶部容器视图
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topView.clipsToBounds = YES;
        self.topView.layer.cornerRadius = configuration.alertViewCornerRadius;
        self.topView.backgroundColor = configuration.alertContainerViewBackgroundColor;
        self.topView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:_topView];
        
        //底部容器视图
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView.clipsToBounds = YES;
        self.bottomView.layer.cornerRadius = configuration.alertViewCornerRadius;
        self.bottomView.backgroundColor = configuration.alertContainerViewBackgroundColor;
        self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundContainerView addSubview:_bottomView];
        
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
        [self.topView addSubview:self.titleLabel];
        
        //messageTextView
        _messageTextView = [[ADAlertTextView alloc] initWithFrame:CGRectZero];
        [self.messageTextView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        [self.messageTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        self.messageTextView.backgroundColor = [UIColor clearColor];
        self.messageTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 8, 0);
        self.messageTextView.editable = NO;
        self.messageTextView.selectable = NO;
        self.messageTextView.textAlignment = NSTextAlignmentCenter;
        self.messageTextView.textColor = configuration.messageTextColor;
        if (configuration.messageFont) {
            self.messageTextView.font = configuration.messageFont;
        }
        self.messageTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topView addSubview:self.messageTextView];
        
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentViewContainerView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.topView addSubview:self.contentViewContainerView];
        
        _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.actionButtonContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.actionButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topView addSubview:self.actionButtonContainerView];
        
        _actionButtonStackView = [[UIStackView alloc] init];
        [self.actionButtonStackView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.actionButtonContainerView addSubview:self.actionButtonStackView];
        [self.actionButtonStackView ad_pinEdgesToSuperviewEdges];
        self.actionButtonStackView.axis = UILayoutConstraintAxisVertical;
        
        if (self.configuration.showsSeparators) {
            UIView *separatorView = [[UIView alloc] init];
            separatorView.backgroundColor = self.configuration.separatorColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.topView addSubview:separatorView];
            [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            [separatorView.leadingAnchor constraintEqualToAnchor:separatorView.superview.leadingAnchor].active = YES;
            [separatorView.trailingAnchor constraintEqualToAnchor:separatorView.superview.trailingAnchor].active = YES;
            [separatorView.bottomAnchor constraintEqualToAnchor:self.actionButtonStackView.topAnchor].active = YES;
            self.separatorView = separatorView;
        }
        
        //添加约束
        CGFloat alertBackgroundViewWidth = self.maximumWidth;
        //1. add backgroundContainerView constraint
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        _alertBackgroundWidthConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0f
                                                                        constant:alertBackgroundViewWidth];
        
        [self addConstraint:self.alertBackgroundWidthConstraint];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.backgroundContainerView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:0]];
 
        //backgroundContainerView.height<= self.height*0.9
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundContainerView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.9f
                                                          constant:0.0f]];
        
        
        //设置子视图与backgroundContainerView 等宽度
        CGFloat pad = 0;
        if (configuration.preferredStyle == ADAlertControllerStyleActionSheet) {
            pad = ADActionSheetDefaultPad;
        }
        NSDictionary *metrics = @{@"pad":@(pad)};
        
        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_topView]-pad-|"
                                                                                             options:0
                                                                                             metrics:metrics
                                                                                               views:NSDictionaryOfVariableBindings(_topView)]];

        [self.backgroundContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[_bottomView]-pad-|"
                                                                                             options:0
                                                                                             metrics:metrics
                                                                                               views:NSDictionaryOfVariableBindings(_bottomView)]];
        //添加 topview 和 bottomview 的约束
        NSDictionary *bottomSpaceMetrics = nil;
        NSString *bottomViewBottomSpaceConstraintVisualFormat = @"V:|-pad-[_topView]-pad-[_bottomView]-bottomPad-|";
        if (configuration.preferredStyle == ADAlertControllerStyleActionSheet) {
            bottomSpaceMetrics = @{@"pad":@(ADActionSheetDefaultPad),@"bottomPad":@(ADActionSheetStyleBottomMargin)};
        }else{
            bottomSpaceMetrics = @{@"pad":@(0),@"bottomPad":@(0)};
        }
        self.bottomViewBottomSpaceConstraints = [NSLayoutConstraint constraintsWithVisualFormat:bottomViewBottomSpaceConstraintVisualFormat
                                                                                       options:0
                                                                                       metrics:bottomSpaceMetrics
                                                                                         views:NSDictionaryOfVariableBindings(_topView,
                                                                                                                              _bottomView)];
        [self.backgroundContainerView addConstraints:self.bottomViewBottomSpaceConstraints];
        
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_messageTextView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_messageTextView)]];
        
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentViewContainerView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_contentViewContainerView)]];
        
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_actionButtonContainerView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_actionButtonContainerView)]];
        
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLabel]-0-[_messageTextView]-0-[_contentViewContainerView(0@250)]-0-[_actionButtonContainerView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                                    _messageTextView,
                                                                                                                                    _contentViewContainerView,
                                                                                                                                    _actionButtonContainerView)]];
    }
    return self;

}


#pragma mark - ADAlertControllerViewProtocol

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

- (void)setTextFields:(NSArray<UITextField *> *)textFields
{
    
}

- (void)setActionButtons:(NSArray<UIButton *> *)actionButtons {
    for (UIView *view  in self.actionButtonStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }

    _actionButtons = actionButtons;

    if (actionButtons.count == 0) {
        self.separatorView.hidden = YES;
        return;
    }
    self.separatorView.hidden = NO;
    
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
    [self.cancelView removeFromSuperview];
    _cancelView = cancelView;
    if (_cancelView) {
        [self.bottomView addSubview:self.cancelView];
        [self.cancelView ad_pinEdgesToSuperviewEdges];
    }
    [self.backgroundContainerView removeConstraints:self.bottomViewBottomSpaceConstraints];
    if (_cancelView) {
        NSString *visualFormat = @"V:|-pad-[_topView]-topBottomPad-[_bottomView]-bottomPad-|";
        NSDictionary *metrics = nil;
        if (self.configuration.preferredStyle == ADAlertControllerStyleActionSheet) {
            metrics = @{@"pad":@(ADActionSheetDefaultPad),
                        @"topBottomPad":@(ADActionSheetStyleCancelButtonTopMargin),
                        @"bottomPad":@(ADActionSheetStyleBottomMargin)};
        }else{
            metrics = @{@"pad":@(0),
                        @"topBottomPad":@(0),
                        @"bottomPad":@(0)};
        }
        self.bottomViewBottomSpaceConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:metrics
                                                                                          views:NSDictionaryOfVariableBindings(_topView,
                                                                                                                               _bottomView)];
        [self.backgroundContainerView addConstraints:self.bottomViewBottomSpaceConstraints];
    }else{
        NSString *visualFormat = @"V:|-pad-[_topView]-topBottomPad-[_bottomView]-bottomPad-|";
        NSDictionary *metrics = nil;
        if (self.configuration.preferredStyle == ADAlertControllerStyleActionSheet) {
            metrics = @{@"pad":@(ADActionSheetDefaultPad),
                        @"topBottomPad":@(0),
                        @"bottomPad":@(ADActionSheetStyleBottomMargin)};
        }else{
            metrics = @{@"pad":@(0),
                        @"topBottomPad":@(0),
                        @"bottomPad":@(0)};
        }
        self.bottomViewBottomSpaceConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:metrics
                                                                                          views:NSDictionaryOfVariableBindings(_topView,
                                                                                                                               _bottomView)];
        [self.backgroundContainerView addConstraints:self.bottomViewBottomSpaceConstraints];
    }
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
@end
