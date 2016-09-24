//
//  ViewController.m
//  QRCode
//
//  Created by 廖挺 on 16/9/24.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "RQCodeMakeViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)makeQRCodePic:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RQCodeMakeViewController *vc = (RQCodeMakeViewController *)[sb instantiateViewControllerWithIdentifier:@"RQCode"];
    [self presentViewController:vc animated:NO completion:nil];
}


//调用原声iOS控件生成二维码和条形码扫描界面
- (IBAction)click:(id)sender {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"点击选择" message:@"选择二维码或者条形码扫描" preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScanViewController *scanVC = (ScanViewController *)[sb instantiateViewControllerWithIdentifier:@"Scan"];
        scanVC.metadataType = metadataTypeQRCode;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:scanVC animated:YES completion:nil];
        });
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"条形码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScanViewController *scanVC = (ScanViewController *)[sb instantiateViewControllerWithIdentifier:@"Scan"];
        scanVC.metadataType = metadataTypeBarCode;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:scanVC animated:YES completion:nil];
        });
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:vc animated:YES completion:nil];
}



@end
