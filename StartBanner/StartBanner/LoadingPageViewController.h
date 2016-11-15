//
//  LoadingPageViewController.h
//  YangDongXi
//
//  Created by Ron on 14-1-2.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingPageViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong) UIImage *lanuchImage;

@end
