//
//  PhoneAddressBook.h
//  PhoneAddress
//
//  Created by 廖挺 on 2016/12/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneAddressBook : NSObject
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *phoneNumArray;
@end
