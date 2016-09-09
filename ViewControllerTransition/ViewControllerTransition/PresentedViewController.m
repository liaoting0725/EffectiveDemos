//
//  PresentedViewController.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/8.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "PresentedViewController.h"
#import <BlocksKit+UIKit.h>
#import <Masonry.h>
#import "CustomTabBarViewController.h"

@interface PresentedViewController ()

@end

@implementation PresentedViewController

- (void)loadView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view = view;
    view.backgroundColor = [UIColor blueColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backBtn.bounds = CGRectMake(0, 0, 50, 40);
    backBtn.center = self.view.center;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageBottom];
    [bottomView addSubview:imageView];
    imageView.frame = CGRectMake(15, 10, 40, 40);
    imageView.userInteractionEnabled = YES;
    [imageView bk_whenTapped:^{
        CustomTabBarViewController *tabbarVC = [CustomTabBarViewController new];
        [self presentViewController:tabbarVC animated:YES completion:nil];
    }];
    self.imageViewBottom = imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
