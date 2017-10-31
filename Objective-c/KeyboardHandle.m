//
//  KeyboardHandle.m
//  keyboardHandle - Objc
//
//  Created by EVERTRUST on 2017/10/31.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

#import "KeyboardHandle.h"
#import "UIResponder+UIResponder_Categroy.h"
#import <UIKit/UIKit.h>

#define SPACE 20.0
@implementation KeyboardHandle
{
    BOOL _enable;
}

-(instancetype)init {
    _enable = true;
    return self;
}

-(void)setIsEnable:(BOOL)isEnable {
    _enable = isEnable;
    if (isEnable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void) keyboardWillShow: (NSNotification*) notification {
    NSValue* keyboardFrame = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    UIViewController* topVC = [self topVC:UIApplication.sharedApplication.keyWindow.rootViewController];
    int animationOption = [(NSNumber*)[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue];
    double duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"%f", duration);
    UIViewAnimationOptions options = animationOption<<16;
    UIView* first = (UIView*)[UIResponder firstResponder];
    if (first) {
        float rect = [first convertPoint:CGPointMake(0, first.frame.size.height) toView:topVC.view].y;
        float offsetX = rect + keyboardFrame.CGRectValue.size.height - topVC.view.frame.size.height + SPACE;
        if (offsetX > 0) {
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                topVC.view.frame = CGRectMake(0, -offsetX, topVC.view.frame.size.width, topVC.view.frame.size.height);
            } completion:nil];
        } else {
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                topVC.view.frame = CGRectMake(0, 0, topVC.view.frame.size.width, topVC.view.frame.size.height);
            } completion:nil];
            
        }
    }
}

-(void) keyboardWillhide: (NSNotification*) notification {
    UIViewController* topVC = [self topVC:UIApplication.sharedApplication.keyWindow.rootViewController];
    int animationOption = [(NSNumber*)[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue];
    UIViewAnimationOptions options = animationOption<<16;
    [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
        topVC.view.frame = CGRectMake(0, 0, topVC.view.frame.size.width, topVC.view.frame.size.height);
    } completion:nil];

}


-(UIViewController*) topVC: (nullable UIViewController*) viewController {
    viewController = UIApplication.sharedApplication.keyWindow.rootViewController;

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navCtrl = (UINavigationController*) viewController;
        return [self topVC:navCtrl.visibleViewController];
    }
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabCtrl = (UITabBarController*) viewController;
        return [self topVC:tabCtrl.selectedViewController];
    }
    if ([viewController presentedViewController]) {
        return [self topVC:[viewController presentedViewController]];
    }
    return viewController;
}

@end
