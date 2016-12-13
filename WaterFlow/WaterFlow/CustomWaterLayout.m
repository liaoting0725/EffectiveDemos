//
//  CustomWaterLayout.m
//  WaterFlow
//
//  Created by 廖挺 on 2016/12/12.
//  Copyright © 2016年 liaoting. All rights reserved.
//

static const int staticColumnCount = 3;
static const float staticColumnPadding = 15;
static const float staticRowPadding = 15;
static const float staticItemHeight = 60;
#import "CustomWaterLayout.h"

@interface CustomWaterLayout () {
    NSInteger _columnCount;//列数
    CGFloat _columnPadding;//列间距
    CGFloat _rowPadding;//行间距
    UIEdgeInsets _sectionInset;//section到collectionView的边距
}
@property (strong, nonatomic) NSMutableArray *attributesArray;
@property (strong, nonatomic) NSMutableArray *maxYArray;


@end

@implementation CustomWaterLayout

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger columnCount = [self columnCount];
    self.maxYArray = [NSMutableArray arrayWithCapacity:columnCount];
    for (int i = 0; i < columnCount; i++) {
        [self.maxYArray addObject:@(0)];
    }
    self.attributesArray = [NSMutableArray array];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    __block NSInteger maxIndex = 0;
    [self.maxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat objFloat = [obj floatValue];
        if (objFloat > [self.maxYArray[maxIndex] floatValue]) {
            maxIndex = idx;
        }
    }];
    return CGSizeMake(0, [self.maxYArray[maxIndex] floatValue] + [self sectionInset].bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    NSInteger columnCount = [self columnCount];
    UIEdgeInsets sectionInset = [self sectionInset];
    CGFloat columnPadding = [self columnPadding];
    CGFloat itemWidth = (collectionViewWidth - sectionInset.left - sectionInset.right - (columnCount - 1) * columnPadding) / columnCount;
    __block NSInteger minIndex = 0;
    [self.maxYArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat objFloat = [obj floatValue];
        if (objFloat < [self.maxYArray[minIndex] floatValue]) {
            minIndex = idx;
        }
    }];
    CGFloat itemX = sectionInset.left + (columnPadding + itemWidth) * minIndex;
    CGFloat lastMaxY = [self.maxYArray[minIndex] floatValue];
    if (!lastMaxY) {
        lastMaxY += sectionInset.top;
    }
    CGFloat itemY = lastMaxY + [self rowPadding];
    CGFloat itemHeight = [self itemHeightWithIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    self.maxYArray[minIndex] = [NSNumber numberWithFloat:(itemY +itemHeight)];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

#pragma - getCustomData
- (NSInteger)columnCount {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customColumnCount)]) {
        return [self.delegate customColumnCount];
    }
    return staticColumnCount;
}

- (CGFloat)columnPadding {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customColumnPadding)]) {
        return [self.delegate customColumnPadding];
    }
    return staticColumnPadding;
}

- (CGFloat)rowPadding {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customRowPadding)]) {
        return [self.delegate customRowPadding];
    }
    return staticRowPadding;
}

- (UIEdgeInsets)sectionInset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSectionInset)]) {
        return [self.delegate customSectionInset];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemHeightWithIndexPath:)]) {
        return [self.delegate itemHeightWithIndexPath:indexPath];
    }
    return staticItemHeight;
}
@end
