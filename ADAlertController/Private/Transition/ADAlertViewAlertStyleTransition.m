//
//  ADAlertViewAlertStyleTransition.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertViewAlertStyleTransition.h"
#import "ADAlertViewAlertStyleTransitionProtocol.h"
#import "ADAlertControllerTransitionConst.h"

@implementation ADAlertViewAlertStyleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    switch (self.transitionStyle) {
        case ADAlertControllerTransitionStylePresenting:{
            UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            [[transitionContext containerView] addSubview:toViewController.view];
            
            
            toViewController.view.layer.opacity = 0.5f;
            [UIView animateWithDuration:[self transitionDuration:transitionContext]
                             animations:^{
                                 toViewController.view.layer.opacity = 1.0f;
                             }];
            
            toViewController.view.layer.transform = CATransform3DIdentity;
            [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                           delay:0.0
                                         options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                      animations:^{
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.0
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            CGFloat scale = 1.13f;
                                                                            toViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale);
                                                                        }];
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.25
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            toViewController.view.layer.transform = CATransform3DIdentity;
                                                                        }];
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.5
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            CGFloat scale = 0.87;
                                                                            toViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale);
                                                                        }];
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.75
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            toViewController.view.layer.transform = CATransform3DIdentity;
                                                                        }];

                                      }
                                      completion:^(BOOL finished) {
                                          [transitionContext completeTransition:YES];
                                      }];
            
           
        }break;
        case ADAlertControllerTransitionStyleDismissing:{
                UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            if ([fromViewController conformsToProtocol:@protocol(ADAlertViewAlertStyleTransitionProtocol)]) {
                if (((id<ADAlertViewAlertStyleTransitionProtocol>)fromViewController).isMoveoutScreen) {
                    [fromViewController.view removeFromSuperview];
                    [transitionContext completeTransition:YES];
                    return;
                }
            }
            
            fromViewController.view.layer.transform = CATransform3DIdentity;
            [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                           delay:0.0
                                         options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                      animations:^{
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.0
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            CGFloat scale = 1.13f;
                                                                            fromViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale);
                                                                        }];
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.25
                                                                  relativeDuration:0.25
                                                                        animations:^{
                                                                            fromViewController.view.layer.transform = CATransform3DIdentity;
                                                                        }];
                                          
                                          [UIView addKeyframeWithRelativeStartTime:0.5
                                                                  relativeDuration:0.5
                                                                        animations:^{
                                                                            CGFloat scale = 0.01;
                                                                            fromViewController.view.layer.transform = CATransform3DMakeScale(scale, scale, scale);
                                                                            fromViewController.view.layer.opacity = 0.4f;
                                                                        }];
                                          
                                      }
                                      completion:^(BOOL finished) {
                                          [fromViewController.view removeFromSuperview];
                                          fromViewController.view.layer.transform = CATransform3DIdentity;
                                          fromViewController.view.layer.opacity = 1.0f;
                                          [transitionContext completeTransition:YES];
                                      }];

        }break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kADAlertControllerTransitionDuration;
}
@end
