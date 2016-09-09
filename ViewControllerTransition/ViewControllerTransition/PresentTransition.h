//
//  PresentTransition.h
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/8.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PresentType) {
    PresentTypePresent,
    presentTypeDismiss
};

@interface PresentTransition : NSObject  <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) PresentType presentType;
@end
