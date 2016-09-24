//
//  ColorSetViewController.h
//  QRCode
//
//  Created by 廖挺 on 16/9/24.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSetViewController : UIViewController
@property (copy, nonatomic) void (^callBack)(int red, int green, int blue);
@end
