//
//  AppDelegate.m
//  StartBanner
//
//  Created by 廖挺 on 16/9/10.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstIntroManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    FirstIntroManager *manager = [FirstIntroManager new];
    BOOL showIngro = [manager firstIntroShowed];
    if (showIngro) {
        
    } else {
        
    }
    
    return YES;
}

@end
