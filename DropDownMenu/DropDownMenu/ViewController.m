//
//  ViewController.m
//  DropDownMenu
//
//  Created by 廖挺 on 16/9/10.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "OptionControl.h"

#define optionArray @[@"全部",@"选择1",@"选择2",@"选择3",@"选择4",@"选择5",@"选择6",@"选择7"]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) OptionControl *control;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.showLabel.text = optionArray[0];
    OptionControl *control = [OptionControl new];
    [control setupWithViewController:self dataArray:optionArray];
    control.selectBlock = ^(NSInteger selectIndex) {
        self.showLabel.text = optionArray[selectIndex];
    };
    self.control = control;
}








@end
