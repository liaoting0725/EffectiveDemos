//
//  PhoneAddressBook.m
//  PhoneAddress
//
//  Created by 廖挺 on 2016/12/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "PhoneAddressBook.h"

@implementation PhoneAddressBook

- (instancetype)init {
    if (self = [super init]) {
        self.phoneNumArray = [NSMutableArray array];
    }
    return self;
}

@end
