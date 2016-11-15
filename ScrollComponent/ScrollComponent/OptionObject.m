//
//  OptionObject.m
//  ScrollComponent
//
//  Created by 廖挺 on 16/11/15.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "OptionObject.h"

@implementation OptionObject

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.eName = [dict objectForKey:@"eName"];
        self.cName = [dict objectForKey:@"cName"];
        self.itemList = [dict objectForKey:@"itemList"];
        self.index = [[dict objectForKey:@"index"] intValue];
        self.select = [[dict objectForKey:@"select"] boolValue];
    }
    return self;
}

+ (instancetype)optionObjectWithDict:(NSDictionary *)dict {
    return [[OptionObject alloc] initWithDict:dict];
}

@end
