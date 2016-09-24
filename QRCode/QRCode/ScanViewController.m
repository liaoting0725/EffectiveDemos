//
//  ScanViewController.m
//  erweima
//
//  Created by 廖挺 on 15/11/3.
//  Copyright © 2015年 liaoting. All rights reserved.
//


#define APP_SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define APP_SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height

#import "ScanViewController.h"

@interface ScanViewController ()
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong, nonatomic)AVCaptureDevice * device;
@property (strong, nonatomic)AVCaptureDeviceInput * input;
@property (strong, nonatomic)AVCaptureMetadataOutput * output;
@property (strong, nonatomic)AVCaptureSession * session;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain)UIImageView * line;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    upOrdown = NO;
    num =0;
    
    //定义的可扫描的外框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 280)];
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.borderColor = [UIColor redColor].CGColor;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    
    
    //扫描线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"h_seprator_line@2x"];
    _line.center = CGPointMake(self.view.center.x, _line.center.y);
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    
    if (upOrdown == NO) {
        num ++;
        //        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        _line.center = CGPointMake(_line.center.x, 111+2*num);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        //        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        _line.center = CGPointMake(_line.center.x, 111+2*num);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    CGSize size = self.view.bounds.size;
    CGRect cropRect = CGRectMake(50, 160, 220, 220);
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                            cropRect.origin.x/size.width,
                                            cropRect.size.height/fixHeight,
                                            cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                            (cropRect.origin.x + fixPadding)/fixWidth,
                                            cropRect.size.height/size.height,
                                            cropRect.size.width/fixWidth);
    }
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    if (self.metadataType == metadataTypeQRCode) { //二维码
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    } else if (self.metadataType == metadataTypeBarCode) { //条形码
        _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
    }
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0,0,375,667);

   // _preview.frame =CGRectMake((self.view.bounds.size.width-280)/2.0,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}

//手电筒点击事件
- (IBAction)flashLightClick:(id)sender {
    if (![_device hasTorch]) { //判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alter show];
    }
    if (_device.torchMode == AVCaptureTorchModeOff) {
        [self turnOnLed:YES];
    } else if (_device.torchMode == AVCaptureTorchModeOn) {
        [self turnOffLed:YES];
    }
}

//打开手电筒
-(void) turnOnLed:(bool)update {
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOn];
    [_device unlockForConfiguration];
}

//关闭手电筒
-(void) turnOffLed:(bool)update {
    [_device lockForConfiguration:nil];
    [_device setTorchMode: AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
}

//扫描成功回调
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    NSLog(@"扫描结果是：%@",stringValue);
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
     }];
}

@end
