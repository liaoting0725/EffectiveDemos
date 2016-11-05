//
//  OptionControl.h
//  DropDownMenu
//
//  Created by 廖挺 on 16/11/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OptionControl : NSObject
@property (copy, nonatomic) void (^selectBlock) (NSInteger selectIndex);
- (void)setupWithViewController:(UIViewController *)viewController dataArray:(NSArray *)dataArray;
@end
