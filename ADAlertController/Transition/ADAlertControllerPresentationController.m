//
//  ADAlertControllerPresentationController.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertControllerPresentationController.h"
#import "UIView+ADAlertControllerAdditions.h"

@interface ADAlertControllerPresentationController ()
@property (nonatomic, readwrite) UIView *backgroundView;

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation ADAlertControllerPresentationController

- (void)presentationTransitionWillBegin {
    
    self.backgroundView.alpha = 0.0f;
    [self.containerView addSubview:self.backgroundView];
    
    [self.backgroundView ad_pinEdgesToSuperviewEdges];
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 1;
    } completion:nil];
}

- (BOOL)shouldPresentInFullscreen {
    return NO;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    
    if (!completed) {
        [self.backgroundView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 0.0f;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    
    [self presentedView].frame = [self frameOfPresentedViewInContainerView];
    self.backgroundView.frame = self.containerView.bounds;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    
    if (completed) {
        [self.backgroundView removeFromSuperview];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.hidenWhenTapBackground) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - get

- (UIView *)backgroundView {
    if(!_backgroundView) {
//        if(self.backgroundViewBlurEffects) {
//            UIColor *color = self.backgroundColor;
//            UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.4];
//            UIImage *image = [UIImage imageWithColor:color size:[UIScreen mainScreen].bounds.size];
//            image = [image imageByBlurRadius:160 tintColor:tintColor tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
//            _backgroundView = [[UIImageView alloc] initWithImage:image];
//            _backgroundView.userInteractionEnabled = YES;
//        } else {
            _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            _backgroundView.backgroundColor = self.backgroundColor;
//        }

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        
    }
    
    return _backgroundView;
}
@end
