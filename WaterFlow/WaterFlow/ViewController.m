//
//  ViewController.m
//  WaterFlow
//
//  Created by 廖挺 on 16/11/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "CustomWaterLayout.h"
#import <Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "PlistParse.h"
#import "CustomWaterCell.h"
#import "CustomWaterObject.h"
static NSString * const cellId = @"CustomWaterCell";
@interface ViewController () <UICollectionViewDataSource, CustomWaterLayoutDelegate, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation ViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CustomWaterLayout *layout = [[CustomWaterLayout  alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"CustomWaterCell" bundle:nil] forCellWithReuseIdentifier:cellId];
        _collectionView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self.dataArray removeAllObjects];
            [self parsePlist];
        }];
        _collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            [self parsePlist];
        }];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.edges;
        }];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self collectionView];
    [self parsePlist];
}

- (void )parsePlist {
    NSArray *array = [PlistParse parseWithPlistName:@"readData"];
    CGFloat collectionViewWidth = self.view.frame.size.width;
    NSInteger columnCount = [self customColumnCount];
    UIEdgeInsets sectionInset = [self customSectionInset];
    CGFloat columnPadding = [self customColumnPadding];
    CGFloat itemWidth = (collectionViewWidth - sectionInset.left - sectionInset.right - (columnCount - 1) * columnPadding) / columnCount;
    for (CustomWaterObject *object in array) {
        object.cellHeight = [object.textStr boundingRectWithSize:CGSizeMake(itemWidth - 2 *5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size.height + 3 *5;
        [self.dataArray addObject:object];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.collectionView reloadData];
    });
}


#pragma - collectionview
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomWaterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    CustomWaterObject *object = self.dataArray[indexPath.item];
    cell.showLabel.text = object.textStr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomWaterObject *object = self.dataArray[indexPath.item];
    NSLog(@"object.text = %@",object.textStr);
}

#pragma - CustomWaterLayoutDelegate
- (NSInteger)customColumnCount {
    return 3;
}
- (CGFloat)customColumnPadding {
    return 15;
}
- (CGFloat)customRowPadding {
    return 10;
}
- (UIEdgeInsets)customSectionInset {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath {
    CustomWaterObject *object = self.dataArray[indexPath.item];
    return object.cellHeight;
}

@end
