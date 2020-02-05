//
//  ADAlertWindow.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertWindow.h"

NSUInteger const ADTAlertWindowLevel = 10;

@interface ADAlertWindowRootViewController : UIViewController

@end

@implementation ADAlertWindowRootViewController

- (void)dealloc
{
//    NSLog(@"%@ delloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

@end

@interface ADAlertWindow ()
@property (strong, nonatomic,class,readonly) NSMapTable *windowAlertViewControllerMapTable;
@end

@implementation ADAlertWindow

- (void)dealloc
{
//    NSLog(@"%@ delloc",NSStringFromClass(self.class));
}

+ (instancetype)window
{
    ADAlertWindow *window = [[ADAlertWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = ADTAlertWindowLevel;
    ADAlertWindowRootViewController *rootVc = [[ADAlertWindowRootViewController alloc] init];
    window.rootViewController = rootVc;
    return window;
}

- (void)presentViewController:(UIViewController *)viewController completion:(void (^__nullable)(void))completion
{
    if (!viewController) {
        return;
    }
    if (![ADAlertWindow.windowAlertViewControllerMapTable objectForKey:viewController]) {
        self.hidden = NO;
        [self makeKeyWindow];
        
        [self.rootViewController presentViewController:viewController animated:YES completion:completion];
        [ADAlertWindow.windowAlertViewControllerMapTable setObject:self forKey:viewController];
        
    }
}

- (void)cleanUpWithViewController:(UIViewController *)viewController
{
    [ADAlertWindow.windowAlertViewControllerMapTable removeObjectForKey:viewController];
}

#pragma mark - get

+ (NSMapTable *)windowAlertViewControllerMapTable
{
    static NSMapTable *__windowAlertViewControllerMapTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __windowAlertViewControllerMapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return __windowAlertViewControllerMapTable;
}

@end
