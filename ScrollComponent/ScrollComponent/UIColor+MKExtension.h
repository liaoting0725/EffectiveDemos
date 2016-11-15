//
//  UIColor+MKExtension.h
//  MKBaseLib
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MKExtension)

+ (UIColor*)colorWithHex:(NSUInteger)hex;

+ (UIColor *) colorWithHexString: (NSString *) hexString;
@end
