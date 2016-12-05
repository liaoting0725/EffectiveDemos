//
//  RootTableViewController.m
//  PhoneAddress
//
//  Created by 廖挺 on 2016/12/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "RootTableViewController.h"
#import "PhoneListTableViewController.h"
#import <BlocksKit+UIKit.h>
#import "PhoneAddressBook.h"

#define TitleArray @[@"自定义界面点击查看"]
@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = TitleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhoneListTableViewController *vc = [PhoneListTableViewController new];
    vc.backBlock = ^(PhoneAddressBook *book, NSString *selectPhoneNum) {
        [[UIAlertView bk_showAlertViewWithTitle:[NSString stringWithFormat:@"您已选中%@%@", book.name, selectPhoneNum] message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil] show];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
