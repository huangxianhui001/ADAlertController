//
//  ADAlertGroupAction.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertGroupAction.h"
#import "ADAlertAction+Private.h"
#import "ADAlertGroupAction+Private.h"

@interface ADAlertGroupAction ()
@property (nonatomic, strong, readwrite) NSArray<ADAlertAction *> *actions;

@end

@implementation ADAlertGroupAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ADActionStyle)style handler:(ADAlertActionHandler)handler{
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (instancetype)actionWithTitle:(NSString *)title style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (instancetype)actionWithImage:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler {
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (instancetype)actionWithImage:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler{
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(ADActionStyle)style handler:(ADAlertActionHandler)handler configuration:(ADAlertActionConfiguration *)configuration
{
    [NSException raise:@"ADAlertGroupActionCallException" format:@"Tried to initialize a grouped action with +[%@ %@]. Please use +[%@ %@] instead.", NSStringFromClass(self), NSStringFromSelector(_cmd), NSStringFromClass(self), NSStringFromSelector(@selector(groupActionWithActions:))];
    return nil;
}

+ (nullable instancetype)groupActionWithActions:(NSArray<ADAlertAction *> *)actions
{
    NSAssert([actions count] > 0, @"Tried to initialize ADAlertGroupAction with less than one action.");
    NSAssert([actions count] > 1, @"Tried to initialize ADAlertGroupAction with one action. Use ADAlertAction in this case.");
    
    [actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[ADAlertAction class]], @"Tried to initialize ADAlertGroupAction with objects of types other than ADAlertAction.");
    }];
    
    ADAlertGroupAction *groupedAction = [[[self class] alloc] init];
    groupedAction.actions = actions;
    
    [groupedAction setHandler:^(ADAlertAction *controller) {
        [NSException raise:@"ADInconsistencyException" format:@"The handler of a grouped action has been called."];
    }];
    
    return groupedAction;
}

- (void)setViewController:(UIViewController *)viewController
{
    for (ADAlertAction *action in self.actions) {
        action.viewController = viewController;
    }
}

#pragma mark - View
- (UIView *)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor clearColor];
    
    NSDictionary *metrics = @{@"seperatorHeight": @(1.f / [[UIScreen mainScreen] scale])};
    if (!self.showsSeparators) {
        metrics = @{@"seperatorHeight": @(0.0f / [[UIScreen mainScreen] scale])};
    }
    
    __block UIView *currentLeft = nil;
    [self.actions enumerateObjectsUsingBlock:^(ADAlertAction *action, NSUInteger index, BOOL *stop) {
        [action.view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [view addSubview:action.view];
        
        if(index == 0) {
            NSDictionary *bindings = @{@"actionView": action.view};
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[actionView]-(0)-|" options:0 metrics:nil views:bindings]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[actionView]" options:0 metrics:nil views:bindings]];
        } else {
            UIView *seperatorView = [self seperatorView];
            [view addSubview:seperatorView];
            
            NSDictionary *bindings = @{@"actionView": action.view, @"seperator": seperatorView, @"currentLeft": currentLeft};
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[actionView]-(0)-|" options:0 metrics:nil views:bindings]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[seperator]-(0)-|" options:0 metrics:nil views:bindings]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[currentLeft(==actionView)]-(0)-[seperator(seperatorHeight)]-(0)-[actionView(==currentLeft)]" options:0 metrics:metrics views:bindings]];
        }
        
        currentLeft = action.view;
    }];
    
    NSDictionary *bindings = @{@"currentLeft": currentLeft};
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[currentLeft]-(0)-|" options:0 metrics:nil views:bindings]];
    
    return view;
}

- (UIView *)seperatorView {
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectZero];
    seperatorView.backgroundColor = self.separatorColor;
    seperatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return seperatorView;
}

@end
