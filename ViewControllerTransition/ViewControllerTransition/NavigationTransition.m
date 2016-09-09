//
//  NavigationTransition.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/8.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "NavigationTransition.h"
#import "ViewController.h"
#import "FirstViewController.h"

@interface NavigationTransition ()


@end

@implementation NavigationTransition

//固定的transition可以写成类方法
+ (instancetype)transitonWithAnimationControllerForOperation:(UINavigationControllerOperation)operation duration:(NSTimeInterval)duration {
    NavigationTransition *transition = [NavigationTransition new];
    transition.duration = duration;
    transition.operation = operation;
    return transition;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.operation;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.operation) {
        case UINavigationControllerOperationNone: {
            break;
        }
        case UINavigationControllerOperationPush: {
            [self pushWithTransitionContext:transitionContext];
            break;
        }
        case UINavigationControllerOperationPop: {
            [self popWithTransitionContext:transitionContext];
            break;
        }
    }
}

- (void)pushWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    //获取到from和to vc
    FirstViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    //讲fromvc上面的图片截图
    UIView *fromImageView = self.sourceView;
    UIView *tempView = [fromImageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [fromImageView convertRect:fromImageView.bounds toView:containView];
    
    UIView *toImageView = toVC.imgView;
    
    fromImageView.hidden = YES;
    toVC.view.alpha = 0;
    toImageView.hidden = YES;
    
    [containView addSubview:toVC.view];
    [containView addSubview:tempView];
    //设置动画
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1/ 0.55 options:0 animations:^{
        toVC.view.alpha = 1.0;
        tempView.frame = [toImageView convertRect:toImageView.bounds toView:containView];
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toImageView.hidden = NO;
        [transitionContext completeTransition:YES];
        }];
}

- (void)popWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    FirstViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    UIView *toImageView = self.sourceView;
    UIView *tempView = containView.subviews.lastObject;
    tempView.hidden = NO;
    [containView insertSubview:toVC.view atIndex:0];
    
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1/ 0.55 options:0 animations:^{
        fromVC.view.alpha = 0.0;
        tempView.frame = [toImageView convertRect:toImageView.bounds toView:containView];
    } completion:^(BOOL finished) {
        toImageView.hidden = NO;
        tempView.hidden = YES;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}
@end
