//
//  CALayer+DescAdd.h
//  YangDongXi
//
//  Created by 廖挺 on 16/6/4.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (DescAdd)

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius borderWidth:(CGFloat)borderWidth borderColorHex:(NSUInteger)borderColorHex;

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius;

+ (void)makeBorderForView:(UIView *)view  borderWidth:(CGFloat)borderWidth borderColorHex:(NSUInteger)borderColorHex;

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (void)makeBorderForView:(UIView *)view  borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


@end
