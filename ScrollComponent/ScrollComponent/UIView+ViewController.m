//
//  UIView+ViewController.m
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/12.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
