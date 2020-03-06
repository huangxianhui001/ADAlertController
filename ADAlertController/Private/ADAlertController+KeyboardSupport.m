//
//  ADAlertController+KeyboardSupport.m
//  ADAlertController
//
//  Created by huangxh on 2020/3/6.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertController+KeyboardSupport.h"
#import "ADAlertView.h"
#import <objc/runtime.h>

static CGFloat const kTextFieldKeyboardMinDistance = 10;

@implementation ADAlertController (KeyboardSupport)

#pragma mark - public
- (void)addObserverKeyboardNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.textFields.count > 0) {
            self.alertViewBackgroundViewVerticalCenteringConstraint = ((ADAlertView *)self.view).backgroundViewVerticalCenteringConstraint;
            [self addTextFieldEditNotification];
            [self removeObserverKeyboardNotification];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHiden:)
                                                         name:UIKeyboardWillHideNotification object:nil];
        }
        
    });
}

- (void)addTextFieldEditNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification object:nil];
    
}

- (void)removeObserverKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)textFieldDidBeginEditing:(NSNotification *)note
{
    self.currentActiveTextField = note.object;
}

- (void)updateLayoutConstraint:(CGFloat )constant withAnimate:(BOOL)animate
{
    [self.view.layer removeAllAnimations];
    self.translationY = constant;
    self.alertViewBackgroundViewVerticalCenteringConstraint.constant = constant;
    if (animate) {
        [UIView animateWithDuration:self.animateDuration
                              delay:0
                            options:self.animteOption
                         animations:^{
            [self.view layoutIfNeeded];
            
        } completion:nil];
    }
}

#pragma mark - keyboardNotification
- (void)keyboardWillShow:(NSNotification *)note
{
    self.animteOption = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
    self.animateDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!CGRectIsEmpty(endFrame)) {
        [self updateKeyboardFrame:endFrame];
    }
}

- (void)keyboardWillHiden:(NSNotification *)note
{
    self.animteOption = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
    self.animateDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self updateLayoutConstraint:0 withAnimate:YES];
}

- (void)updateKeyboardFrame:(CGRect )keyboardFrame
{
    if (self.currentActiveTextField) {
        CGRect currentTextFieldFrame = [self.currentActiveTextField convertRect:self.currentActiveTextField.frame toView:self.textEffectsWindow];
        //我们要计算的是在不做偏移的情况下 textfield本来的frame,所以这里需要将目前偏移的值纠正回来
        currentTextFieldFrame = CGRectOffset(currentTextFieldFrame, 0, -self.translationY);
        CGFloat textFieldBottom = CGRectGetMaxY(currentTextFieldFrame);
        CGFloat textFieldTop = CGRectGetMinY(currentTextFieldFrame);
        CGFloat keyboardTop = CGRectGetMinY(keyboardFrame);
        CGFloat moveDistance = 0;
        if (textFieldBottom < keyboardTop) {
            if (textFieldBottom + kTextFieldKeyboardMinDistance > keyboardTop) {
                moveDistance = kTextFieldKeyboardMinDistance;
            }
        }
        else {
            moveDistance = -fabs(textFieldTop - keyboardTop) - kTextFieldKeyboardMinDistance;
        }
        
        [self updateLayoutConstraint:moveDistance withAnimate:YES];
    }
}

- (UIWindow *)textEffectsWindow
{
    UIWindow *textEffectsWindow = objc_getAssociatedObject(self, _cmd);
    if (!textEffectsWindow) {
        Class textEffectsWindowClass = NSClassFromString(@"UITextEffectsWindow");
        if (textEffectsWindowClass) {
            for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
                if (window.class == textEffectsWindowClass) {
                    objc_setAssociatedObject(self, _cmd, window, OBJC_ASSOCIATION_ASSIGN);
                    textEffectsWindow = window;
                    break;
                }
            }
        }
    }
    return textEffectsWindow;
}
@end
