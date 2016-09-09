//
//  ViewController.m
//  ViewControllerTransition
//
//  Created by 廖挺 on 16/9/3.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import <Masonry.h>
#import "NavigationTransition.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NavigationTransition *transition;

@end

@implementation ViewController

- (NavigationTransition *)transition {
    if (!_transition) {
        _transition = [NavigationTransition new];
    }
    return _transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"viewController";
    [self tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor redColor];
        headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
        self.imageViewHeader = [UIImageView new];
        self.imageViewHeader.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);//设置frame
        self.imageViewHeader.clipsToBounds = YES;
        self.imageViewHeader.image = [UIImage imageNamed:@"BGimage.jpg"];
        self.imageViewHeader.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push:)];
        [self.imageViewHeader addGestureRecognizer:tap];
        [headerView addSubview:self.imageViewHeader];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = headerView;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.edges;
        }];
    }
    return _tableView;
}

- (void)push:(UIGestureRecognizer *)ges {
    self.transition.sourceView = ges.view;
    FirstViewController *vc = [FirstViewController new];
    vc.image = [(UIImageView *)ges.view image];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.transition.duration = 0.5;
    if (operation == UINavigationControllerOperationPop) {
        self.transition.duration = 0.25;
    }
    self.transition.operation = operation;
    return self.transition;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"BGimage.jpg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstViewController *vc = [FirstViewController new];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.image = cell.imageView.image;
    self.transition.sourceView = cell.imageView;
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
