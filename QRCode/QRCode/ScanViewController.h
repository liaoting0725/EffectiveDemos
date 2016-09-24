//
//  ScanViewController.h
//  erweima
//
//  Created by 廖挺 on 15/11/3.
//  Copyright © 2015年 liaoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, metadataType) {
    metadataTypeQRCode,
    metadataTypeBarCode,
};

@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (assign, nonatomic) metadataType metadataType;
@property (nonatomic, copy) void(^callbackResult)(NSString *);
@end
