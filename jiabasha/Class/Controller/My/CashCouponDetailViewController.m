//
//  CashCouponDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CashCouponDetailViewController.h"
#import "GetCouponDetailRequest.h"
#import "CouponModel.h"
#import "CancelGetCouponRequest.h"
#import "NSString+AttributedString.h"
#import "MineCouponDescModel.h"

#import "Growing.h"
@interface CashCouponDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewUseRuleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContectHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstant;
@property (assign, nonatomic, getter=ruleisshow) BOOL ruleshow;
@property (assign, nonatomic, getter=contectisshow) BOOL contectshow;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewRuleMark;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewContectMark;
@property (weak, nonatomic) IBOutlet UIView *viewRule;
@property (weak, nonatomic) IBOutlet UIView *viewContect;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelDeadline;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewQR;
@property (weak, nonatomic) IBOutlet UILabel *labelQRNum;
@property (weak, nonatomic) IBOutlet UILabel *labelRule;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGFloat ruleHeight;
@property (assign, nonatomic) CGFloat addressHeight;
@property (strong, nonatomic) CouponModel *couponModel;
@property (strong, nonatomic) UIImage *qrImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelrmb;
@end

@implementation CashCouponDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    self.growingAttributesPageName=@"cashDetail_ios";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self getCouponDetailRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _contentViewWidthConstant.constant = kScreenWidth;
    if (kScreenHeight < 580) {
        _contentHeight = 580;
    } else {
        _contentHeight = kScreenHeight;
    }
    //屏幕的高度在计算展开之后的label高度之后再赋值
    
    _viewUseRuleHeight.constant = 0;
    _viewContectHeight.constant = 0;
    
    _ruleshow = NO;
    _contectshow = NO;
    _viewRule.hidden = YES;
    _viewContect.hidden = YES;
    _viewContect.clipsToBounds = YES;
    
//    _labelRule.text = @"使用规则说明";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _imageviewQR.image = self.qrImage;
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


#pragma mark - Request
- (void)getCouponDetailRequest{
    /*
     "cash_code_id": "703519","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_cashCodeId,@"cash_code_id", nil];
    [GetCouponDetailRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:self.view withCancelSubject:[GetCouponDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            _couponModel = (CouponModel *)[request.resultDic objectForKey:@"couponModel"];
            //设定控件值
            [self setValueForControl];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

//值设定
- (void)setValueForControl{
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:_couponModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelCompanyName.text = _couponModel.store.storeName;
    if (![CommonUtil isEmpty:_couponModel.meetAmount]) {
        _labelSubtitle.text = [NSString stringWithFormat:@"满%@元可用",_couponModel.meetAmount];
    } else {
        _labelSubtitle.text = @"";
    }
    _labelPrice.text = [NSString stringWithFormat:@"%.0f",[_couponModel.parValue floatValue]];
    _labelDeadline.text = [NSString stringWithFormat:@"有效期至:%@",[CommonUtil getDateStringFromtempString:_couponModel.validEnd]];
    //判断时间
    [self vaildTime];
    if ([_couponModel.setting.forExpp isEqualToString:@"0"]) {
        _labelType.text = @"门店券";
        _labelType.textColor = RGB(251, 181, 33);
    } else {
        _labelType.text = @"展会券";
        _labelType.textColor = RGB(96, 25, 134);
    }
    [self createQrCodeWithStr:_couponModel.qrcodeImage];
    _labelQRNum.text = [NSString stringWithFormat:@"券号:%@",_couponModel.cashCouponCode];
    _labelAddress.text = _couponModel.store.address;
    CGFloat labelAddressHeight = [CommonUtil sizeWithString:_labelAddress.text fontSize:15 sizewidth:kScreenWidth-52 sizeheight:0].height;
    _addressHeight = labelAddressHeight+58;
    //使用规则行高是字高的1.5x 利用富文本计算高度
    _labelPhoneNum.text = _couponModel.store.tel;
    NSMutableString *strContent = [NSMutableString stringWithFormat:@"适用范围：%@\n",_couponModel.desc.range.content];
    _labelRule.text = [strContent stringByAppendingString:_couponModel.desc.detailedDesc.content];
    _labelRule.attributedText = [_labelRule.text stringWithParagraphlineSpeace:10.5 textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:14]];
    if ([CommonUtil isEmpty:_labelRule.text]) {
        _ruleHeight = 0;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_labelRule.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10.5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_labelRule.text length])];
        _labelRule.attributedText = attributedString;
        _ruleHeight = [self calculateHeightWithTextString:_labelRule.text];
    }
    
    _contentViewHeightConstant.constant = _contentHeight+_addressHeight+_ruleHeight;
}

- (CGFloat)calculateHeightWithTextString:(NSString *)text{
//    CGFloat textHieght = [_labelRule.text sizeWithFont:[UIFont systemFontOfSize:14]].height;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = 10.5;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [text boundingRectWithSize:CGSizeMake(kScreenWidth-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//判断是否过期
- (void)vaildTime{
    long timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([_couponModel.status isEqualToString:@"1"] && timeStamp < [_couponModel.validEnd longLongValue]) {//正常
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
    } else if ([_couponModel.status isEqualToString:@"2"]){//核销
        _imageViewStatus.image = [UIImage imageNamed:@"我的现金券已使用"];
        _labelrmb.textColor = RGB(187, 187, 187);
        _labelPrice.textColor = RGB(187, 187, 187);
    } else if ([_couponModel.status isEqualToString:@"3"] && timeStamp > [_couponModel.validEnd longLongValue]){//过期
        _imageViewStatus.image = [UIImage imageNamed:@"time_out_icon"];
        _labelrmb.textColor = RGB(187, 187, 187);
        _labelPrice.textColor = RGB(187, 187, 187);
    } else if ([_couponModel.status isEqualToString:@"4"]){//无效
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
    } else {//0 锁定
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
    }
}


#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showRule:(id)sender {
    if ([self ruleisshow]) {
        _viewUseRuleHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _imageviewRuleMark.transform = CGAffineTransformIdentity;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _viewRule.hidden = YES;
        }];
    } else {
        _viewRule.hidden = NO;
        _viewUseRuleHeight.constant = _ruleHeight;
        [UIView animateWithDuration:0.2 animations:^{
            _imageviewRuleMark.transform = CGAffineTransformMakeRotation(M_PI);
            [self.view layoutIfNeeded];
        }];
    }
    _ruleshow = !_ruleshow;
}

- (IBAction)showContect:(id)sender {
    if ([self contectisshow]) {
        _viewContectHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _imageviewContectMark.transform = CGAffineTransformIdentity;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _viewContect.hidden = NO;
        _viewContectHeight.constant = _addressHeight;//展开计算label的高度
        [UIView animateWithDuration:0.2 animations:^{
            _imageviewContectMark.transform = CGAffineTransformMakeRotation(M_PI);
            [self.view layoutIfNeeded];
        }];
    }
    _contectshow = !_contectshow;
}

- (IBAction)buttonCancelClicked:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要取消此现金券吗？取消后不可恢复" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_couponModel.cashCouponCode,@"cash_coupon_code", nil];
        [CancelGetCouponRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[CancelGetCouponRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
            
        } onRequestFinished:^(CIWBaseDataRequest *request) {
            if ([request.errCode isEqualToString:RESPONSE_OK]) {
                [self.view makeToast:@"成功取消现金券"];
            } else if ([request.errCode isEqualToString:@"cash_coupon.u_can_not_cancel"]){
                [self.view makeToast:@"辛苦攒积分兑换的现金券是不能取消的" duration:1 position:CSToastPositionCenter];
            } else {
                [self.view makeToast:@"取消现金券失败" duration:1 position:CSToastPositionCenter];
            }
        } onRequestCanceled:^(CIWBaseDataRequest *request) {
            
        } onRequestFailed:^(CIWBaseDataRequest *request) {
            [self.view makeToast:@"取消现金券失败"];
        }];

    }];
    
    [alertVC addAction:actionCancel];
    [alertVC addAction:actionSure];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    
//    [self.view makeToast:@"取消成功"];
    /*
     "uid": "12743702","cash_code_id": "C690F48311","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    }
@end
