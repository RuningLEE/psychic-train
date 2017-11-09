//
//  QrInvitationViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "QrInvitationViewController.h"

@interface QrInvitationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelVip;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet YYLabel *labelAccess;
@property (strong, nonatomic) UIImage *qrImage;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@end

@implementation QrInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _labelName.text = [NSString stringWithFormat:@"新人姓名：%@",_qrModel.uname];
    //初始化UI
    if ([_qrModel.userLevel isEqualToString:@"new"]) {
        _labelVip.text = @"会员身份：新会员";
    } else if ([_qrModel.userLevel isEqualToString:@"old"]) {
        _labelVip.text = @"会员身份：老会员";
    } else if ([_qrModel.userLevel isEqualToString:@"vip"]) {
        _labelVip.text = @"会员身份：Vip会员";
    } else {
        _labelVip.text = @"会员身份：金卡会员";
    }
    _labelMobile.text = [NSString stringWithFormat:@"绑定手机：%@",_qrModel.phone];
    _labelAccess.text = [NSString stringWithFormat:@"请从%@进入",_qrModel.doorNumber];
    [self createQrCodeWithStr:_qrModel.qrcodeTicketStr];
    
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
    if ([DATA_ENV.userInfo.user.cityId isEqualToString:@"330100"]) {
        _labelPhone.text = @"0571-28198188";
    } else {
        _labelPhone.text = @"4000-365-520";
    }
}

- (void)createQrCodeWithStr:(NSString *)qrstr{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSData *data = [qrstr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    self.qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    self.qrImageView.image = self.qrImage;
}

/*
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callMethod:(id)sender {
    _viewNotify.hidden = NO;
}

- (IBAction)callAction:(id)sender {
    if (![CommonUtil isEmpty:_labelPhone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelPhone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

- (IBAction)cancelCall:(id)sender {
    _viewNotify.hidden = YES;
}
@end
