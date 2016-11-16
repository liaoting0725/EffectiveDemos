//
//  DemoViewController.m
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/9.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "DemoViewController.h"
#import "SecondLevelView.h"
#import <Masonry.h>
#import "DemoViewController.h"
#import "OptionObject.h"

@interface DemoViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _hidden;//nav是否隐藏
}

@property (weak, nonatomic) IBOutlet UIView *topOne;
@property (weak, nonatomic) IBOutlet UIView *topTwo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor redColor];
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"右item";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"right item" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = item;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.topOne.frame = CGRectMake(0, 0, screenWidth, 40);
    self.topTwo.frame = CGRectMake(0, 40, screenWidth, 44);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.topTwo.frame), screenWidth, screenHeight -40 -44 -64);
    NSMutableArray *originArray = [NSMutableArray array];
    for (int i =0; i <9; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"中文%d",i] forKey:@"cName"];
        [dict setObject:[NSString stringWithFormat:@"english%d",i] forKey:@"eName"];
        NSMutableArray *subArray = [NSMutableArray array];
        for (int j=1; j <i+2; j++) {
            NSString *subString = [NSString stringWithFormat:@"%d %d", i,j];
            [subArray addObject:subString];
        }
        [dict setObject:subArray forKey:@"itemList"];
        [dict setObject:@(i) forKey:@"index"];
        [dict setObject:@(NO) forKey:@"select"];
        OptionObject *object = [OptionObject optionObjectWithDict:dict];
        [originArray addObject:object];
    }
    SecondLevelView *levelView = [[SecondLevelView alloc] init:originArray];
    [self.topTwo addSubview:levelView];
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.edges;
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

//隐藏头部nav判断
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (velocity.y > 0.0) {
        //向上滑动隐藏导航栏
        [UIView animateWithDuration:0.2 animations:^{
            [self.navigationController setNavigationBarHidden:YES];
            self.topOne.transform = CGAffineTransformMakeTranslation(0, -20);
            self.topTwo.transform = CGAffineTransformMakeTranslation(0, -20);
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -20);
            CGRect rect = self.tableView.frame;
            self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, screenHeight -40 -20);
        } completion:^(BOOL finished) {
            _hidden = YES;
        }];
    }else {
        //向下滑动显示导航栏
        [UIView animateWithDuration:0.2 animations:^{
            [self.navigationController setNavigationBarHidden:NO];
            self.topOne.transform = CGAffineTransformIdentity;
            self.topTwo.transform = CGAffineTransformIdentity;
            self.tableView.transform = CGAffineTransformIdentity;
            CGRect rect = self.tableView.frame;
            self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, screenHeight - 40 -44 - 64);
        } completion:^(BOOL finished) {
            _hidden = NO;
        }];
    }
}

@end
