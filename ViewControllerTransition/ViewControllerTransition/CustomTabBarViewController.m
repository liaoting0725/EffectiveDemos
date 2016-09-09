//
//  CustomTabBarViewController.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/9.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "TabBarTransition.h"

@interface CustomTabBarViewController () <UITabBarControllerDelegate>
@property (strong, nonatomic) TabBarTransition *transition;
@end

@implementation CustomTabBarViewController

- (TabBarTransition *)transition {
    if (!_transition) {
        _transition = [TabBarTransition new];
        _transition.duration = .5;
    }
    return  _transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];
    for (int i =0; i <4; i++) {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random() %255/255.0f green:arc4random() %255/255.0f blue:arc4random() %255/255.0f alpha:1];
        UILabel *centerLabel = [UILabel new];
        centerLabel.text = [NSString stringWithFormat:@"%d",i];
        centerLabel.textColor = [UIColor blackColor];
        centerLabel.font = [UIFont systemFontOfSize:30.0f];
        centerLabel.textAlignment = NSTextAlignmentCenter;
        [vc.view addSubview:centerLabel];
        centerLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        centerLabel.backgroundColor = [UIColor clearColor];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.barTintColor = vc.view.backgroundColor;
        nav.navigationBar.translucent = NO;
        
        nav.tabBarItem.title = centerLabel.text;
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateNormal];
         [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        [viewControllers addObject:nav];
        nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    }
    self.delegate = self;
    self.viewControllers = viewControllers;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (!self.selectedIndex)
        self.transition.preIndex = 0;
    else
        self.transition.preIndex = self.selectedIndex;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.selectedIndex  && self.transition.sufIndex== self.selectedIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    self.transition.sufIndex = self.selectedIndex;
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self.transition;
}

@end
