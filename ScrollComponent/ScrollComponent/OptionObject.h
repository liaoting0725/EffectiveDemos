//
//  OptionObject.h
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/15.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionObject : NSObject
@property (copy, nonatomic) NSString *cName;
@property (copy, nonatomic) NSString *eName;
@property (strong, nonatomic) NSArray *itemList;
@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL select;
+ (instancetype)optionObjectWithDict:(NSDictionary *)dict;
@end
