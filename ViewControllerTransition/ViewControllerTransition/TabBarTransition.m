//
//  TabBarTransition.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/9.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "TabBarTransition.h"

@implementation TabBarTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return  self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *fromNav = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toNav = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    [containView addSubview:toNav.view];
    toNav.view.frame = CGRectMake((_sufIndex>_preIndex?1:-1) * CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    [UIView animateWithDuration:self.duration animations:^{
       fromNav.view.transform = CGAffineTransformTranslate(fromNav.view.transform, (_sufIndex>_preIndex?-1:1) *[UIScreen mainScreen].bounds.size.width, 0);
        toNav.view.transform = CGAffineTransformTranslate(toNav.view.transform, (_sufIndex>_preIndex?-1:1) *[UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
