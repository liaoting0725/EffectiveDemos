//
//  ViewController.m
//  TableHeaderView
//
//  Created by 廖挺 on 16/8/31.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import <BlocksKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSArray *array = @[@"1",@"2",@"3"];
    [array bk_each:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
