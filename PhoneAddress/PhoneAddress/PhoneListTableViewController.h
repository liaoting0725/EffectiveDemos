//
//  PhoneListTableViewController.h
//  PhoneAddress
//
//  Created by 廖挺 on 2016/12/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhoneAddressBook;
@interface PhoneListTableViewController : UITableViewController
@property (copy, nonatomic) void (^backBlock)(PhoneAddressBook *addressBook, NSString *selectPhone);
@end
