//
//  ViewController.m
//  MarqueeShow
//
//  Created by 廖挺 on 16/11/21.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"

static const CGFloat padding = 15;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *textArray = @[@"跑马灯测试跑动1",@"跑马灯测试跑动2跑马灯测试跑动2",@"跑马灯测试跑动3跑马灯测试跑动3跑马灯测试跑动3",@"跑马灯测试跑动4跑马灯测试跑动4跑马灯测试跑动4跑马灯测试跑动4",@"跑马灯测试跑动5",@"跑马灯"];
    
    CGFloat width = 0;
    for (NSString *text in textArray) {
        UILabel *label = [];
        
        
        
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(240, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:30]} context:nil];
        width += rect.size.width;
        width += padding;
    }
    
}

@end
