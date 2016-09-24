//
//  ColorSetViewController.m
//  QRCode
//
//  Created by 廖挺 on 16/9/24.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ColorSetViewController.h"

@interface ColorSetViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) UITextField *lastTextField;

@end

@implementation ColorSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.enabled = NO;
}

- (IBAction)backBtnClick:(id)sender {
    if (self.callBack) {
        self.callBack(self.redTextField.text.intValue,self.greenTextField.text.intValue, self.blueTextField.text.intValue);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lastTextField = textField;
    self.backBtn.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.lastTextField = nil;
    NSArray *array = @[self.redTextField, self.greenTextField, self.blueTextField];
    int index = 0;
    for (UITextField *subTextField in array) {
        NSInteger num = [subTextField.text integerValue];
        if (num >255) {
            NSString *title = @"";
            if (index == 0)
                title = @"红色框提示";
            else if (index == 1)
                title = @"绿色框提示";
            else if (index ==2)
                title = @"蓝色框提示";
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:title message:@"数字只能小于256" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
            return;
        }
        index++;
    }
    self.backBtn.enabled = YES;
}

- (IBAction)viewTap:(id)sender {
    if (!self.lastTextField) {
        return;
    }
    [self.lastTextField resignFirstResponder];
}

@end
