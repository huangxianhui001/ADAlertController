//
//  ADAlertViewSheetStyleTransition.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertViewSheetStyleTransition.h"
#import "ADAlertControllerTransitionConst.h"
#import "ADAlertControllerViewProtocol.h"

@implementation ADAlertViewSheetStyleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    switch (self.transitionStyle) {
        case ADAlertControllerTransitionStylePresenting:{
            UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [[transitionContext containerView] addSubview:toViewController.view];
            
            UIView<ADAlertControllerViewProtocol> *view = (UIView<ADAlertControllerViewProtocol> *)toViewController.view;
            
            CGFloat contentHeight = [view.backgroundContainerView systemLayoutSizeFittingSize:CGSizeZero
                                                                withHorizontalFittingPriority:UILayoutPriorityDefaultHigh
                                                                      verticalFittingPriority:UILayoutPriorityDefaultHigh].height;
            
            toViewController.view.transform = CGAffineTransformMakeTranslation(0, contentHeight);
//            toViewController.view.alpha = 0.0f;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 toViewController.view.transform = CGAffineTransformIdentity;
//                                 toViewController.view.alpha = 1.0f;
                             }
                             completion:^(BOOL finished) {
                                 [transitionContext completeTransition:YES];
                             }];
        }break;
        case ADAlertControllerTransitionStyleDismissing:{
            UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            fromViewController.view.transform = CGAffineTransformIdentity;
//            fromViewController.view.alpha = 1;
            UIView<ADAlertControllerViewProtocol> *view = (UIView<ADAlertControllerViewProtocol> *)fromViewController.view;
            
            CGFloat contentHeight = [view.backgroundContainerView systemLayoutSizeFittingSize:CGSizeZero
                                                                withHorizontalFittingPriority:UILayoutPriorityDefaultHigh
                                                                      verticalFittingPriority:UILayoutPriorityDefaultHigh].height;

            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                fromViewController.view.transform = CGAffineTransformMakeTranslation(0, contentHeight);
//                fromViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                [fromViewController.view removeFromSuperview];
                fromViewController.view.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:YES];
            }];
            
        }break;
    }
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kADAlertControllerTransitionDuration;
}
@end
