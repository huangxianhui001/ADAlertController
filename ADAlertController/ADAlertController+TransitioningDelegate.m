//
//  ADAlertController+TransitioningDelegate.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController+TransitioningDelegate.h"
#import "ADAlertViewAlertStyleTransition.h"
#import "ADAlertViewSheetStyleTransition.h"
#import "ADAlertControllerPresentationController.h"

@implementation ADAlertController (TransitioningDelegate)

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    ADAlertControllerPresentationController *presentationController = [[ADAlertControllerPresentationController alloc] initWithPresentedViewController:presented
                                                                                                                  presentingViewController:presenting];
    presentationController.hidenWhenTapBackground = self.configuration.hidenWhenTapBackground;
    presentationController.backgroundColor = self.configuration.alertMaskViewBackgroundColor;
    presentationController.backgroundViewBlurEffects = self.configuration.backgroundViewBlurEffects;
    return presentationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    switch (self.configuration.preferredStyle) {
        case ADAlertControllerStyleAlert:{
            ADAlertViewAlertStyleTransition *presentationAnimationController = [[ADAlertViewAlertStyleTransition alloc] init];
            presentationAnimationController.transitionStyle = ADAlertControllerTransitionStylePresenting;
            return presentationAnimationController;
            
        }break;
        case ADAlertControllerStyleActionSheet:
        case ADAlertControllerStyleSheet:{
            ADAlertViewSheetStyleTransition *presentationAnimationController = [[ADAlertViewSheetStyleTransition alloc] init];
            presentationAnimationController.transitionStyle = ADAlertControllerTransitionStylePresenting;
            return presentationAnimationController;
        }break;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    switch (self.configuration.preferredStyle) {
        case ADAlertControllerStyleAlert:{
            ADAlertViewAlertStyleTransition *presentationAnimationController = [[ADAlertViewAlertStyleTransition alloc] init];
            presentationAnimationController.transitionStyle = ADAlertControllerTransitionStyleDismissing;
            return presentationAnimationController;
            
        }break;
        case ADAlertControllerStyleActionSheet:
        case ADAlertControllerStyleSheet:{
            ADAlertViewSheetStyleTransition *presentationAnimationController = [[ADAlertViewSheetStyleTransition alloc] init];
            presentationAnimationController.transitionStyle = ADAlertControllerTransitionStyleDismissing;
            return presentationAnimationController;
        }break;
    }
}

@end
