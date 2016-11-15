//
//  CALayer+DescAdd.m
//  YangDongXi
//
//  Created by 廖挺 on 16/6/4.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "CALayer+DescAdd.h"
#import "UIColor+MKExtension.h"

@implementation CALayer (DescAdd)

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius borderWidth:(CGFloat)borderWidth borderColorHex:(NSUInteger)borderColorHex
{
    [view.layer setMasksToBounds:YES];
    if (redius) {
        view.layer.cornerRadius = redius;
    }
    if (borderWidth !=0) {
        view.layer.borderWidth = borderWidth;
    }
    if (borderColorHex) {
        view.layer.borderColor = [[UIColor colorWithHex:borderColorHex] CGColor];
    }
}

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius
{
    [view.layer setMasksToBounds:YES];
    if (redius)
        view.layer.cornerRadius = redius;
}

+ (void)makeBorderForView:(UIView *)view  borderWidth:(CGFloat)borderWidth borderColorHex:(NSUInteger)borderColorHex
{
    [view.layer setMasksToBounds:YES];
    if (borderWidth !=0) {
        view.layer.borderWidth = borderWidth;
    }
    if (borderColorHex) {
        view.layer.borderColor = [[UIColor colorWithHex:borderColorHex] CGColor];
    }
}

+ (void)makeBorderForView:(UIView *)view redius:(CGFloat)redius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [view.layer setMasksToBounds:YES];
    if (redius) {
        view.layer.cornerRadius = redius;
    }
    if (borderWidth !=0) {
        view.layer.borderWidth = borderWidth;
    }
    if (borderColor) {
        view.layer.borderColor = [borderColor CGColor];
    }
}

+ (void)makeBorderForView:(UIView *)view  borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [view.layer setMasksToBounds:YES];
    if (borderWidth !=0) {
        view.layer.borderWidth = borderWidth;
    }
    if (borderColor) {
        view.layer.borderColor = [borderColor CGColor];
    }
}
@end
