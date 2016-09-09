//
//  FirstViewController.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/3.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "FirstViewController.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "PresentedViewController.h"
#import "PresentTransition.h"

@interface FirstViewController () <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) PresentTransition *transition;
@end

@implementation FirstViewController

- (PresentTransition *)transition {
    if (!_transition) {
        _transition = [PresentTransition new];
    }
    return _transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FirstViewController";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 400);
    self.imgView = imageView;
    imageView.userInteractionEnabled = YES;
    [imageView bk_whenTapped:^{
        PresentedViewController *vc = [PresentedViewController new];
        vc.imageBottom = self.image;
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transition.presentType = PresentTypePresent;
    self.transition.duration = 2;
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.presentType = presentTypeDismiss;
    self.transition.duration = 2;
    return self.transition;
}

@end
