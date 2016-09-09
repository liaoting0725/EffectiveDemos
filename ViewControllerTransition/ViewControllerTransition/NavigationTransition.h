//
//  NavigationTransition.h
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/8.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) UINavigationControllerOperation operation;
@property (strong, nonatomic) UIView *sourceView;

@end
