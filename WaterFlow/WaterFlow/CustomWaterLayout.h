//
//  CustomWaterLayout.h
//  WaterFlow
//
//  Created by 廖挺 on 2016/12/12.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomWaterLayoutDelegate <NSObject>
@required
- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)customColumnCount;
- (CGFloat)customColumnPadding;
- (CGFloat)customRowPadding;
- (UIEdgeInsets)customSectionInset;

@end

@interface CustomWaterLayout : UICollectionViewLayout
@property (weak, nonatomic) id <CustomWaterLayoutDelegate> delegate;
@end
