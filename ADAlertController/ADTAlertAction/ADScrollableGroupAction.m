//
//  ADScrollableGroupAction.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADScrollableGroupAction.h"

@interface ADScrollableGroupAction ()

@property (nonatomic, assign) CGFloat actionWidth;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

@end

@implementation ADScrollableGroupAction

+ (nullable instancetype)groupActionWithActions:(NSArray<ADAlertAction *> *)actions
{
    [NSException raise:@"ADConstructionException" format:@"This method should not be called to initialize an ADScrollableGroupAction instance."];
    return nil;
}

+ (instancetype)scrollableGroupActionWithActions:(NSArray<ADAlertAction *> *)actions
{
    return [self scrollableGroupActionWithActionWidth:50 actions:actions];
}

+ (instancetype)scrollableGroupActionWithActionWidth:(CGFloat)actionWidth actions:(NSArray<ADAlertAction *> *)actions
{
    ADScrollableGroupAction *action = [super groupActionWithActions:actions];
    action.actionWidth = actionWidth;
    return action;
}

#pragma mark - View
- (UIView *)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    __block UIView *currentLeft = nil;
    [self.actions enumerateObjectsUsingBlock:^(ADAlertAction *action, NSUInteger index, BOOL *stop) {
        [scrollView addSubview:action.view];
        
        if(index == 0) {
            NSDictionary *bindings = @{@"actionView": action.view};
            
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[actionView]-(>=0)-|" options:0 metrics:nil views:bindings]];
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[actionView]" options:0 metrics:nil views:bindings]];
        } else {
            NSDictionary *bindings = @{@"actionView": action.view, @"currentLeft": currentLeft};
            NSDictionary *metrics = @{@"width": @(self.actionWidth)};
            
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[actionView]-(>=0)-|" options:0 metrics:nil views:bindings]];
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[currentLeft(width)]-(0)-[actionView(width)]" options:0 metrics:metrics views:bindings]];
        }
        
        currentLeft = action.view;
    }];
    
    NSDictionary *bindings = @{@"currentLeft": currentLeft, @"scrollView": scrollView};
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[currentLeft]-(0)-|" options:0 metrics:nil views:bindings]];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [scrollView addConstraint: self.heightConstraint];
    
    [self updateFont];
    return scrollView;
}

#pragma mark - Helper
- (void)updateFont {
    __block CGFloat maxHeight = 0;
    [self.actions enumerateObjectsUsingBlock:^(ADAlertAction *action, NSUInteger index, BOOL *stop) {
        maxHeight = MAX(maxHeight, [action.view systemLayoutSizeFittingSize:CGSizeMake(self.actionWidth, 999999) withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel].height);
    }];
    self.heightConstraint.constant = maxHeight;
}
@end
