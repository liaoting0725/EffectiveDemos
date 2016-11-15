//
//  SecondLevelView.m
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/11.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "SecondLevelView.h"
#import <Masonry.h>
#import "SecondLevelCell.h"
#import "SecondLevelTextCell.h"
#import "CALayer+DescAdd.h"
#import "UIColor+MKExtension.h"
#import "UIView+ViewController.h"
#import "OptionObject.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define lightGrayColor [UIColor lightGrayColor]
#define selectColor [UIColor colorWithHex:0xffaa00]
#define whiteColor [UIColor whiteColor]
#define blackColor [UIColor blackColor]
#define maxRows 5
static const CGFloat animationTime = .3f;

@interface SecondLevelView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    BOOL _show;
    NSIndexPath *_curIndexPath;
}
@property (strong, nonatomic) NSMutableArray *originArray;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *collectionView1;
@property (strong, nonatomic) NSMutableDictionary *selectDict;
@property (strong, nonatomic) UIView *transView;
@property (strong, nonatomic) UIButton *progressBtn;
@end

@implementation SecondLevelView

- (instancetype)init:(NSArray *)originArray {
    if (self = [super init]) {
        self.originArray = [originArray mutableCopy];
        self.selectDict = [NSMutableDictionary dictionary];
        [self collectionView];
        [self collectionView1];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(65, 44);
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"SecondLevelCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.edges;
        }];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = lightGrayColor;
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.left.right.bottom;
            make.height.mas_equalTo(1);
        }];
        
        UIView *transView = [UIView new];
        transView.backgroundColor = whiteColor;
        [bottomView addSubview:transView];
        transView.frame = CGRectMake(-65, 0, 65, 1);
        self.transView = transView;
        
        
    }
    return _collectionView;
}

- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(screenWidth/2, 40);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.backgroundColor = whiteColor;
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.showsVerticalScrollIndicator = NO;
        [_collectionView1 registerNib:[UINib nibWithNibName:@"SecondLevelTextCell" bundle:nil] forCellWithReuseIdentifier:@"TextCell"];
    }
    return _collectionView1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _collectionView) {
        return _originArray.count;
    } else {
        if (!_curIndexPath)
            return 0;
        OptionObject *OptionObject = _originArray[_curIndexPath.item];
        return [OptionObject.itemList count];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        SecondLevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        OptionObject *OptionObject = _originArray[indexPath.item];
        cell.label.text = OptionObject.cName;
        NSString *eName = OptionObject.eName;
        //普通状态，
        if (self.selectDict.count && [self.selectDict.allKeys containsObject:eName] ) {//选中
            cell.label.text = [self.selectDict objectForKey:eName];
            cell.label.backgroundColor = whiteColor;
            cell.label.textColor = selectColor;
            [CALayer makeBorderForView:cell.label redius:5 borderWidth:1 borderColor:selectColor];
            [CALayer makeBorderForView:cell.cornerView redius:5 borderWidth:1 borderColor:[UIColor clearColor]];
        } else { //未选中
            if (_curIndexPath == indexPath) { //已点击
                cell.label.backgroundColor = whiteColor;
                cell.label.textColor = selectColor;
                [CALayer makeBorderForView:cell.label redius:5 borderWidth:1 borderColor:[UIColor clearColor]];
                [CALayer makeBorderForView:cell.cornerView redius:5 borderWidth:1 borderColor:lightGrayColor];
                CGFloat tx = cell.frame.origin.x - collectionView.contentOffset.x;
                self.transView.transform = CGAffineTransformMakeTranslation(tx + 65, 0);
            } else {
                cell.label.backgroundColor = lightGrayColor;
                cell.label.textColor = blackColor;
                [CALayer makeBorderForView:cell.label redius:5 borderWidth:1 borderColor:[UIColor clearColor]];
                [CALayer makeBorderForView:cell.cornerView redius:5 borderWidth:1 borderColor:[UIColor clearColor]];
            }
        }
        return cell;
    } else {
        SecondLevelTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextCell" forIndexPath:indexPath];
        OptionObject *OptionObject = _originArray[_curIndexPath.item];
        NSArray *array = OptionObject.itemList;
        cell.label.text = array[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        OptionObject *object = _originArray[indexPath.item];
        NSString *eName = object.eName;
        if (self.selectDict.count && [self.selectDict.allKeys containsObject:eName]) {
            [self.selectDict removeObjectForKey:eName];
            object.select = NO;
            [self sortArray];
            if (_show)
                [self hideProgress:self.progressBtn];
            else
                [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } else {
            //普通未选中状态
            if (_show) { //下拉已经显示
                NSMutableArray *indexPathArray = [NSMutableArray array];
                [indexPathArray addObject:[_curIndexPath copy]];
                if (indexPath == _curIndexPath) {
                    [self hideProgress:self.progressBtn];
                } else {
                    _curIndexPath = indexPath;
                    [indexPathArray addObject:[_curIndexPath copy]];
                    [collectionView reloadItemsAtIndexPaths:indexPathArray];
                    [self animateShow:NO];
                }

            } else { //下拉未显示
                NSMutableArray *indexPathArray = [NSMutableArray array];
                if (_curIndexPath) {
                    [indexPathArray addObject:[_curIndexPath copy]];
                }
                _curIndexPath = indexPath;
                [indexPathArray addObject:[_curIndexPath copy]];
                [collectionView reloadItemsAtIndexPaths:indexPathArray];
                [self animateShow:YES];
            }
        }
    } else {
        OptionObject *object = _originArray[_curIndexPath.item];
        NSString *eName = object.eName;
        NSArray *array = object.itemList;
        [self.selectDict setObject:array[indexPath.item] forKey:eName];
        object.select = YES;
        [self sortArray];
        [self hideProgress:self.progressBtn];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (void)animateShow:(BOOL)show {
    UIViewController *controller = [self viewController];
    if (show) {
        _show = YES;
        if (!self.progressBtn) {
            UIButton *progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [progressBtn addTarget:self action:@selector(hideProgress:) forControlEvents:UIControlEventTouchUpInside];
            progressBtn.backgroundColor = [[UIColor colorWithHex:0x000000] colorWithAlphaComponent:0.3];
            [controller.view addSubview:progressBtn];
            self.progressBtn = progressBtn;
            [self.progressBtn addSubview:_collectionView1];
        }
        CGRect rect = [self convertRect:self.frame toView:controller.view];
        self.progressBtn.frame = CGRectMake(0, CGRectGetMaxY(rect), screenWidth, screenHeight);
        //items个数
        OptionObject *object = _originArray[_curIndexPath.item];
        NSArray *array = object.itemList;
        NSInteger rows = array.count/2 + array.count%2;
        CGFloat height = 40 *(rows >=maxRows? maxRows:rows);
        _collectionView1.frame = CGRectMake(0, 0, screenWidth, 0);
        [UIView animateWithDuration:animationTime animations:^{
            _collectionView1.frame = CGRectMake(0, 0, screenWidth, height);
        }];
    } else {
        OptionObject *object = _originArray[_curIndexPath.item];
        NSArray *array = object.itemList;
        NSInteger rows = array.count/2 + array.count%2;
        CGFloat height = 40 *(rows >=5? 5:rows);
        [UIView animateWithDuration:animationTime animations:^{
            _collectionView1.frame = CGRectMake(0, 0, screenWidth, height);
        }];
    }
    [_collectionView1 reloadData];
}

- (void)hideProgress:(UIButton *)sender {
    _show = NO;
    _curIndexPath = nil;
    [self.collectionView reloadData];
    self.transView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:animationTime animations:^{
        _collectionView1.frame = CGRectMake(0, 0, screenWidth, 0);
        sender.alpha = 0;
    } completion:^(BOOL finished) {
        sender.frame = CGRectMake(0, 0, screenWidth, 0);
        sender.alpha = 1;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        if (_show) {
            [self hideProgress:self.progressBtn];
        }
    }
}

- (void)sortArray {
    NSSortDescriptor *sortDescriporPrimary = [NSSortDescriptor sortDescriptorWithKey:@"select" ascending:NO];
    NSSortDescriptor *sortDescriporSecondary = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [_originArray sortUsingDescriptors:@[sortDescriporPrimary,sortDescriporSecondary]];
}

@end
