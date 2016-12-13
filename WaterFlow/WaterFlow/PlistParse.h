//
//  PlistParse.h
//  WaterFlow
//
//  Created by 廖挺 on 2016/12/13.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistParse : NSObject
+ (NSArray *)parseWithPlistName:(NSString *)plistName;
@end
