//
//  ViewController.m
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/9.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
}

- (IBAction)enter:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DemoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Demo"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
