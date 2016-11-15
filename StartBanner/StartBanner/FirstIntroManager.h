//
//  FirstIntroManager.h
//  StartBanner
//
//  Created by 廖挺 on 16/9/10.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstIntroManager : NSObject
+ (instancetype)shareManager;
- (BOOL)firstIntroShowed;
- (void)successFirstIntro;
@end
