//
//  OptionControl.m
//  DropDownMenu
//
//  Created by 廖挺 on 16/11/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "OptionControl.h"

static NSString *const cellID = @"cell";
#define normalColor [UIColor blackColor]
#define selectColor [UIColor redColor]
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface OptionControl () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    NSInteger _selectIndex;
    BOOL _show;
}
@property (strong, nonatomic) UITableView *optionTableView;
@property (strong, nonatomic) UIButton *titleBtn;
@property (copy, nonatomic) NSArray *dataArray;

@end

@implementation OptionControl

- (void)setupWithViewController:(UIViewController *)viewController dataArray:(NSArray *)dataArray {
    if (!dataArray.count || !dataArray)
        return;
    if (!viewController.navigationController)
        return;
    self.dataArray = [dataArray copy];
    _selectIndex = 0;
    _show = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0) style:UITableViewStylePlain];
    tableView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTableView)];
    [tableView addGestureRecognizer:tap];
    tap.delegate = self;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [viewController.view addSubview:tableView];
    self.optionTableView = tableView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:dataArray[_selectIndex] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showOrHide:) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.titleView = button;
    self.titleBtn = button;
}

- (void)hideTableView {
    [self showOrHide:self.titleBtn];
}

- (void)showOrHide:(UIButton *)sender {
    if (_show) {
        sender.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.optionTableView.frame = CGRectMake(0, 0, screenWidth, 0);
        } completion:^(BOOL finished) {
            sender.enabled = YES;
            _show = NO;
        }];
    } else {
        sender.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.optionTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64);
        } completion:^(BOOL finished) {
            sender.enabled = YES;
            _show = YES;
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger row = indexPath.row;
    cell.textLabel.text = _dataArray[row];
    if (row == _selectIndex)
        cell.textLabel.textColor = selectColor;
    else
        cell.textLabel.textColor = normalColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    [tableView reloadData];
    [self hideTableView];
    if (self.selectBlock) {
        self.selectBlock(_selectIndex);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *touchView = touch.view;
    if ([touchView isMemberOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

@end
