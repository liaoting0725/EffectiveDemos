//
//  SecondLevelCell.h
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/11.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondLevelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@end
