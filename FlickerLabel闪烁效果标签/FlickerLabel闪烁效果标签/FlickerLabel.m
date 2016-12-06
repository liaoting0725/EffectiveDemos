//
//  FlickerLabel.m
//  FlickerLabel闪烁效果标签
//
//  Created by 廖挺 on 2016/12/6.
//  Copyright © 2016年 liaoting. All rights reserved.
//


#import "FlickerLabel.h"
static NSTimeInterval _animationDuration = 2;
static NSTimeInterval _animationReadyDuration = 0;
@interface FlickerLabel () <CAAnimationDelegate> {
    CAGradientLayer *_gradientLayer;
}
@end

@implementation FlickerLabel

- (void)setUpGradientLayer {
    _gradientLayer = [CAGradientLayer layer];
    // 设置梯度颜色
    _gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor,
                                  (__bridge id)[UIColor whiteColor].CGColor,
                                  (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0.5].CGColor];
    // 设置梯度颜色的位置
    _gradientLayer.locations = @[@(0), @(0.05), @(0.1)];
    // 这是颜色渐变的方向
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1, 0);
    
    // 设置为mask，iOS8之后，也可以设置self.maskView
    self.layer.mask = _gradientLayer;
}

- (void)didMoveToSuperview {
    CGRect bounds = self.superview.bounds;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animationReadyDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUpGradientLayer];
        _gradientLayer.frame = bounds;
        [self doAnimation];
    });
}

- (void)doAnimation {
    [_gradientLayer removeAnimationForKey:@"slide"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    // 设置开始值
    animation.fromValue = @[@(0), @(0.05), @(0.1)];
    // 这是结束值
    animation.toValue   = @[@(0.9), @(0.95), @(1)];
    animation.duration  = _animationDuration;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [_gradientLayer addAnimation:animation forKey:@"slide"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 重复动画
    if (flag) {
        [self doAnimation];
    }
}


@end
