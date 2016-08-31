//
//  RootViewController.m
//  ScollToTop
//
//  Created by 廖挺 on 16/8/31.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "RootViewController.h"
#import <BlocksKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface RootViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *tableViews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraintWidth.constant = SCREENWIDTH *4;
    self.scrollView.scrollsToTop = NO;
    [self.scrollView bk_addObserverForKeyPath:@"contentOffset" task:^(id target) {
        self.scrollView.scrollsToTop = NO;
        CGFloat x = self.scrollView.contentOffset.x;
        if (x <0)
            x =0;
        if (x >SCREENWIDTH *3) {
            x = SCREENWIDTH;
        }
        NSInteger index = x/SCREENWIDTH;
        [self.tableViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UITableView *tableView = (UITableView *)obj;
            if (index == idx)
                tableView.scrollsToTop = YES;
            else
                tableView.scrollsToTop = NO;
        }];
    }];
}

- (void)dealloc {
    [self.scrollView bk_removeAllBlockObservers];
}

#pragma - mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %ld",[self.tableViews indexOfObject:tableView],indexPath.row];
    return cell;
}




@end
