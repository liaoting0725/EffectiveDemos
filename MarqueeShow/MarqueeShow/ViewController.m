//
//  ViewController.m
//  MarqueeShow
//
//  Created by 廖挺 on 16/11/21.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "MarqueeView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (strong, nonatomic) MarqueeView *marquee;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.endBtn.enabled = NO;
    self.resumeBtn.enabled = NO;
    NSArray *textArray = @[@"跑马灯测试跑动1跑马灯测试跑动1",@"跑马灯测试跑动1跑马灯测试跑动1跑马灯测试跑动1跑马灯测试跑动1",@"跑马灯测试"];
    MarqueeView *queeview = [[MarqueeView alloc] initWithFrame:self.containView.bounds];
    [queeview setTextArray:textArray scrollDirectionType:ScrollDirectionLeft];
    [self.containView addSubview:queeview];
    self.marquee = queeview;
}

- (IBAction)start:(id)sender {
    self.startBtn.enabled = NO;
    self.endBtn.enabled = YES;
    self.resumeBtn.enabled = NO;
    [self.marquee start];
}

- (IBAction)stop:(id)sender {
    self.startBtn.enabled = NO;
    self.endBtn.enabled = NO;
    self.resumeBtn.enabled = YES;
    [self.marquee stop];
}

- (IBAction)resume:(id)sender {
    self.startBtn.enabled = NO;
    self.endBtn.enabled = YES;
    self.resumeBtn.enabled = NO;
    [self.marquee resume];
}

@end
