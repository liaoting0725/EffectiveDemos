//
//  FirstIntroManager.m
//  StartBanner
//
//  Created by 廖挺 on 16/9/10.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "FirstIntroManager.h"

@implementation FirstIntroManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [super allocWithZone:zone];
    });
    return obj;
}

+ (instancetype)shareManager {
    return [[FirstIntroManager alloc] init];
}

- (BOOL)firstIntroShowed {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    if (object == nil || [object boolValue] == NO)
        return YES;
    else
        return NO;
}

- (void)successFirstIntro {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
