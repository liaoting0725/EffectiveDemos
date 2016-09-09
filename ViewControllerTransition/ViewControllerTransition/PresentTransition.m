//
//  PresentTransition.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/8.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "PresentTransition.h"
#import "FirstViewController.h"
#import "PresentedViewController.h"

@interface PresentTransition ()
@property (strong, nonatomic) UIView *tempView;
@end

@implementation PresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.presentType) {
        case PresentTypePresent: {
            [self presentWithTransitionContext:transitionContext];
            break;
        }
        case presentTypeDismiss: {
            [self dismissWithTransitionContext:transitionContext];
            break;
        }
    }
}
- (void)presentWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *nav = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FirstViewController *fromVC = (FirstViewController *)nav.topViewController;
    PresentedViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    UIView *fromView = fromVC.imgView;
    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [fromView convertRect:fromView.bounds toView:containView];
    self.tempView = tempView;
    UIView *toView = toVC.view;
    [containView addSubview:toView];
    [containView addSubview:self.tempView];
    fromView.hidden = YES;
    toVC.imageViewBottom.hidden = YES;
    toView.alpha = 0;
    toView.transform = CGAffineTransformScale(toView.transform, 0, 0);
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:.9 options:0 animations:^{
        toView.alpha =1;
        tempView.frame =  CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 50, 40, 40);
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        toVC.imageViewBottom.hidden = NO;
        tempView.hidden = YES;
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *nav = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    FirstViewController *toVC = (FirstViewController *)nav.topViewController;
    PresentedViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containView = [transitionContext containerView];
    toVC.imgView.hidden = YES;
    self.tempView.hidden = NO;
    [containView insertSubview:nav.view atIndex:0];
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:.9 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.tempView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 400);
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.imgView.hidden = NO;
        self.tempView.hidden = YES;
        [transitionContext completeTransition:YES];
    }];
    
}


@end
