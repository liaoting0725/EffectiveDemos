//
//  TabBarTransition.h
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/9.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TabBarTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSInteger preIndex;
@property (assign, nonatomic) NSInteger sufIndex;
@end
