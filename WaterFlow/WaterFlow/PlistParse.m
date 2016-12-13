//
//  PlistParse.m
//  WaterFlow
//
//  Created by 廖挺 on 2016/12/13.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "PlistParse.h"
#import "CustomWaterObject.h"
#import <UIKit/UIKit.h>

@implementation PlistParse

+ (NSArray *)parseWithPlistName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *str in array) {
        CustomWaterObject *object = [CustomWaterObject new];
        object.textStr = [str copy];
        [dataArray addObject:object];
    }
    return dataArray;
}
@end
