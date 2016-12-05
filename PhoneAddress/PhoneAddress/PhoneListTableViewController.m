//
//  PhoneListTableViewController.m
//  PhoneAddress
//
//  Created by 廖挺 on 2016/12/5.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "PhoneListTableViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "PhoneAddressBook.h"
#import <BlocksKit+UIKit.h>

#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]
@interface PhoneListTableViewController () <CNContactPickerDelegate> {
    NSMutableArray *_addressBookTemp;
    CNContactStore *_contactStore;
    ABAddressBookRef _abAddBookRef;
}

@end

@implementation PhoneListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录列表";
    _addressBookTemp = [[NSMutableArray alloc] init];
    [self getAddressBooks];   //获取访问通讯录 权限
}

- (void)getAddressBooks {
    if (SystemVersion >= 9.0f) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        _contactStore = [[CNContactStore alloc] init];
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error = %@",error.localizedDescription);
                    return;
                }
                if (granted) {
                    [self getAddressBooksData];
                } else
                    [self authAlertShow];
            }];
        } else if (authStatus == CNAuthorizationStatusAuthorized){
            [self getAddressBooksData];
        } else {
            [self authAlertShow];
        }
    } else {
        _abAddBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus;
        ABAddressBookRequestAccessWithCompletion(_abAddBookRef, ^(bool greanted, CFErrorRef error)        {
            if (error) {
                return;
            }
            if (greanted) {
                [self getAddressBooksDataBefore9];
            } else
                [self authAlertShow];
        });
    }
}

- (void)getAddressBooksData {
    NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    [_contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString * givenName = contact.givenName;
        NSString * familyName = contact.familyName;
        if (givenName.length || familyName.length) {
            NSArray * phoneArray = contact.phoneNumbers;
            if (phoneArray.count) {
                NSString *resultName = [self componentName:givenName middleName:nil familyName:familyName];
                PhoneAddressBook *addressBook = [[PhoneAddressBook alloc] init];
                addressBook.name = resultName;
                for (CNLabeledValue * labelValue in phoneArray) {
                    CNPhoneNumber * number = labelValue.value;
                    NSLog(@"%@--%@", number.stringValue, labelValue.label);
                    [addressBook.phoneNumArray addObject:number.stringValue];
                }
                [_addressBookTemp addObject:addressBook];
            }
            
        }
    }];
    [self.tableView reloadData];
}

- (void)getAddressBooksDataBefore9 {
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(_abAddBookRef);
    CFIndex number = ABAddressBookGetPersonCount(_abAddBookRef);
    for (int i = 0; i < number; i++) {
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        CFStringRef fullName = ABRecordCopyCompositeName(people);
        NSString *name = nil;
        if (fullName != nil) {
            name = (__bridge NSString *)fullName;
        } else {
            NSString * firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            NSString * lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
            NSString * middleName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
            name = [self componentName:firstName middleName:middleName familyName:lastName];
        }
        if (name.length) {
            ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phones)) {
                PhoneAddressBook *addressBook = [[PhoneAddressBook alloc] init];
                addressBook.name = name;
                for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
                    [addressBook.phoneNumArray addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
                }
                [_addressBookTemp addObject:addressBook];
            }
        }
    }
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressBookTemp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    PhoneAddressBook *book = _addressBookTemp[indexPath.row];
    cell.textLabel.text = book.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld个号码", book.phoneNumArray.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhoneAddressBook *book = _addressBookTemp[indexPath.row];
    if (book.phoneNumArray.count == 1) {
        if (self.backBlock) {
            self.backBlock(book,book.phoneNumArray.firstObject);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:book.name message:@"请选择其中一个号码" preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *phoneNum in book.phoneNumArray) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:phoneNum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.backBlock) {
                    self.backBlock(book, phoneNum);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:action];
        }
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (NSString *)componentName:(NSString *)givenName middleName:(NSString *)middleName familyName:(NSString *)familyName {
    NSMutableArray *nameArray = middleName?[NSMutableArray arrayWithObjects:givenName, middleName,familyName, nil]:[NSMutableArray arrayWithObjects:givenName, familyName, nil];
    [nameArray removeObject:@""];
    return [nameArray componentsJoinedByString:@" "];
}

- (void)authAlertShow {
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"是否打开通讯录权限" cancelButtonTitle:@"不了" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            if (SystemVersion >10.f) {
                NSURL*url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                NSURL*url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    [alert show];
}

@end
