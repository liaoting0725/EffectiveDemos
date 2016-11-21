//
//  MarqueeView.h
//  MarqueeShow
//
//  Created by 廖挺 on 16/11/21.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ScrollDirectionType) {
    ScrollDirectionLeft,
    ScrollDirectionRight
};

@interface MarqueeView : UIView
@property (assign, nonatomic) BOOL isStop;

- (void)setTextArray:(NSArray *)textArray scrollDirectionType:(ScrollDirectionType)scrollDirectionType;
- (void)start;
- (void)stop;
- (void)resume;
@end
