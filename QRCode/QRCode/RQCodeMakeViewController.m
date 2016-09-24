//
//  RQCodeMakeViewController.m
//  QRCode
//
//  Created by 廖挺 on 16/9/24.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "RQCodeMakeViewController.h"
#import <CoreImage/CoreImage.h>
#import "RQCodeMakeViewController.h"
#import "ColorSetViewController.h"

@interface RQCodeMakeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) NSString *lastString;
@end

@implementation RQCodeMakeViewController
- (void)viewDidLoad {
    self.lastString = @"";
    [super viewDidLoad];
}

- (IBAction)viewTap:(id)sender {
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
}

//生成图片
+ (UIImage *)imageOfQRFromURL:(NSString *)networkAddress codeSize:(CGFloat)codeSize {
    if (!networkAddress||!networkAddress.length || (NSNull *)networkAddress == [NSNull null])
        return nil;
    CIImage * originImage = [self createQRFromAddress: networkAddress];
    UIImage * result =  [self excludeFuzzyImageFromCIImage:originImage size:[self validateCodeSize: codeSize]];
    return result;
}

//返回图片尺寸
+ (CGFloat)validateCodeSize:(CGFloat)codeSize {
    codeSize = MAX(160, codeSize);
    codeSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, codeSize);
    return codeSize;
}

//转换字符串为图片
+ (CIImage *)createQRFromAddress:(NSString *)networkAddress {
    NSData * stringData = [networkAddress dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter * qrFilter = [CIFilter filterWithName: @"CIQRCodeGenerator"];
    [qrFilter setValue: stringData forKey: @"inputMessage"];
    [qrFilter setValue: @"H" forKey: @"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

//清晰图片
+ (UIImage *)excludeFuzzyImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建灰度色调空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage: scaledImage];
}

+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress codeSize: (CGFloat)codeSize red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    NSUInteger rgb = (red << 16) + (green << 8) + blue;
    NSAssert((rgb & 0xffffff00) <= 0xd0d0d000, @"The color of QR code is two close to white color than it will diffculty to scan");
   return [self.class imageFillBlackColorAndTransparent:[self.class imageOfQRFromURL:networkAddress codeSize:codeSize] red:red green:green blue:blue];
}

//对二维码图像进行颜色填充
+ (UIImage *)imageFillBlackColorAndTransparent: (UIImage *)image red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self fillWhiteToTransparentOnPixel: rgbImageBuf pixelNum: pixelNumber red: red green: green blue: blue];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}

void ProviderReleaseData(void * info, const void * data, size_t size) {
    free((void *)data);
}

//遍历所有像素点进行颜色替换
+ (void)fillWhiteToTransparentOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    uint32_t * pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (![self.lastString isEqualToString:textView.text]) {
        self.imageView.image = [UIImage new];
    }
    self.lastString = textView.text;
    if (!self.lastString.length)
        return;
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"点击选择样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [vc addAction:[UIAlertAction actionWithTitle:@"普通样式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imageView.image = [self.class imageOfQRFromURL:self.lastString codeSize:0];
        });
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"带颜色样式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ColorSetViewController *colorSet = (ColorSetViewController *)[sb instantiateViewControllerWithIdentifier:@"ColorSet"];
            colorSet.callBack = ^(int red, int green, int blue){
                self.imageView.image = [self.class imageOfQRFromURL:self.lastString codeSize:0 red:red green:green blue:blue];
            };
            [self presentViewController:colorSet animated:YES completion:nil];
        });
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
