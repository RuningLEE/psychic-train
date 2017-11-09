//
//  ShoppingGroupViewController.m
//  jiabasha
//
//  Created by guok on 17/1/19.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShoppingGroupViewController.h"
#import "PlaceholderColorTextField.h"
#import "RenovationCompanyHomeViewController.h"
#import "UITextField+MaxLength.h"
#import "SendPhoneCodeRequest.h"
#import "CheckPhoneCodeRequest.h"
#import "GetStoreAddReserveRequest.h"

@interface ShoppingGroupViewController () {
    
    __weak IBOutlet UILabel *_labelStoreName;
    
    //商品
    __weak IBOutlet UIImageView *_imgViewPic;
    __weak IBOutlet UILabel *_labelProductName;
    __weak IBOutlet UILabel *_labelGroupTotal;
    
    __weak IBOutlet UILabel *_labelPriceT;
    __weak IBOutlet UILabel *_labelGroupPrice;
    __weak IBOutlet UILabel *_labelOriPrice;
    
    //预约信息
    __weak IBOutlet PlaceholderColorTextField *_textFieldName;
    __weak IBOutlet PlaceholderColorTextField *_textFieldPhone;
    
    __weak IBOutlet UIView *_viewVcode;
    __weak IBOutlet PlaceholderColorTextField *_textFieldVcode;
    __weak IBOutlet UIButton *_btnGetVcode;
    
    __weak IBOutlet UIView *_viewCodeImg;
    __weak IBOutlet PlaceholderColorTextField *_textFieldCodeImg;
    __weak IBOutlet UIButton *_btnCodeImg;
    
    __weak IBOutlet NSLayoutConstraint *_heightForOrder;
    
    //我要拼团
    __weak IBOutlet UIButton *_btnAppoint;
}

//倒计时用timer
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger waitCount;

@property (nonatomic, copy) NSString *imgData;
@property (nonatomic, copy) NSString *phonenumber; //已经发送验证码的手机

@end

@implementation ShoppingGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //店铺
    if (_productDetail.store) {
        _labelStoreName.text = [_productDetail.store objectForKey:@"store_name"];
    }
    if (_productDetail.imgs.count > 0) {
        [_imgViewPic sd_setImageWithURL:[NSURL URLWithString:_productDetail.imgs[0]] placeholderImage:[UIImage imageNamed:@"正中"]];
    }
    _labelProductName.text = _productDetail.productName;
    
    _labelGroupTotal.text = _productDetail.tuanMaxNum;
    
    //当前价
    NSString *currectPrice = _productDetail.tuanPrice;
    if ([CommonUtil isEmpty:_productDetail.tuanPrice]) {
        currectPrice = _productDetail.mallPrice;
    }
    
    for (int i = 0; i<_productDetail.tuanSetting.tuanPrices.count; i++) {
        TuanPrice *tuanPrice = [_productDetail.tuanSetting.tuanPrices objectAtIndex:i];
        if ([tuanPrice.num integerValue] > [_productDetail.tuanOrderCnt integerValue]) {
            break;
        } else {
            currectPrice = tuanPrice.price;
        }
        
        if (i == 0 && [CommonUtil isEmpty:currectPrice]) {
            currectPrice = tuanPrice.price;
        }
    }
    _labelGroupPrice.text = currectPrice;
    
//    if ([CommonUtil isEmpty:_productDetail.mallPrice]) {
//        _labelGroupPrice.text = @"面议";
//        _labelPriceT.hidden = YES;
//    } else {
//        _labelGroupPrice.text = _productDetail.mallPrice;
//    }

    if ([CommonUtil isEmpty:_productDetail.price]) {
        _labelOriPrice.text = @"";
    } else {
        NSString *mallPrice = [NSString stringWithFormat:@"￥%@", _productDetail.price];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:mallPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, mallPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:RGBFromHexColor(0x999999) range:NSMakeRange(0, mallPrice.length)];
        [_labelOriPrice setAttributedText:attri];
    }
    
    
    _textFieldPhone.maxLength = 11;
    _textFieldVcode.maxLength = 6;
    
    //登录的场合，用户名和手机号自动读取
    if (DATA_ENV.isLogin) {
        _textFieldName.text = DATA_ENV.userInfo.user.uname;
        _textFieldPhone.text = DATA_ENV.userInfo.user.phone;
        [self checkInput];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)textFieldDidChange:(NSNotification*)aNotification {
    [self checkInput];
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//店铺点击进入店铺画面
- (IBAction)btnStoreClicked:(id)sender {
    RenovationCompanyHomeViewController *view = [[RenovationCompanyHomeViewController alloc] initWithNibName:@"RenovationCompanyHomeViewController" bundle:nil];
    view.storeId = _productDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

//重新获取验证码
- (IBAction)btnGetVcodeClicked:(id)sender {
    if (self.imgData && _viewCodeImg.hidden == YES) {
        _viewCodeImg.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _heightForOrder.constant = 183 + 44 + 10 + 44;
        }];
        return;
    }
    
    if (_viewCodeImg.hidden == NO) {
        if ([CommonUtil isEmpty:_textFieldCodeImg.text]) {
            [MessageView displayMessage:@"请输入图形验证码"];
            return;
        }
    }
    
    [self sendPhoneCode];
}

- (void)sendPhoneCode {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textFieldPhone.text forKey:@"phone"];
    if (_viewCodeImg.hidden == NO) {
        [parameters setValue:_textFieldCodeImg.text forKey:@"verify_code"];
    }
    
    __weak typeof(self) weakSelf = self;
    [SendPhoneCodeRequest requestWithParameters:parameters
                              withIndicatorView:self.view
                                 onRequestStart:^(CIWBaseDataRequest *request) {}
                              onRequestFinished:^(CIWBaseDataRequest *request) {
                                  
                                  if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                      
                                      //取到验证码
                                      [weakSelf getVcodeSuccess];
                                  }else{
                                      if ([@"err.catpure" isEqualToString:request.errCode] || [@"err.catpure.err" isEqualToString:request.errCode]) {
                                          //图片验证码
                                          weakSelf.imgData = [request.resultDic objectForKey:@"data"];
                                          NSData *imgData = [[NSData alloc] initWithBase64EncodedString:weakSelf.imgData options:0];
                                          [_btnCodeImg setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                                          
                                          if ([@"err.catpure" isEqualToString:request.errCode]) {
                                              //取到验证码
                                              [weakSelf getVcodeSuccess];
                                              
                                          } else if ([@"err.catpure.err" isEqualToString:request.errCode]) {
                                              
                                              if (_viewVcode.hidden == YES) {
                                                  _viewVcode.hidden = NO;
                                                  _textFieldVcode.text = @"";
                                                  
                                                  [UIView animateWithDuration:0.3 animations:^{
                                                      _heightForOrder.constant = 183 + 44;
                                                  }];
                                                  [self checkInput];
                                              }
                                              
                                              if (_viewCodeImg.hidden == YES) {
                                                  _viewCodeImg.hidden = NO;
                                                  
                                                  _btnGetVcode.enabled = YES;
                                                  [_btnGetVcode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                                                  
                                                  [UIView animateWithDuration:0.3 animations:^{
                                                      _heightForOrder.constant = 183 + 44 + 10 + 44;
                                                  }];
                                              } else {
                                                  
                                                  //验证码错误
                                                  [MessageView displayMessageByErr:request.errCode];
                                              }
                                          }
                                      } else {
                                          
                                          [MessageView displayMessageByErr:request.errCode];
                                      }
                                  }
                              }
     
                              onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

//成功取得验证码
- (void)getVcodeSuccess {
    self.phonenumber = _textFieldPhone.text;
    [_textFieldCodeImg becomeFirstResponder];
    
    //倒计时
    //取到验证
    [self.waitTimer invalidate];
    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [_btnGetVcode setTitle:@"60s" forState:UIControlStateNormal];
    self.waitCount = 60;
    _btnGetVcode.enabled = NO;

    if (_viewVcode.hidden == YES) {
        _viewVcode.hidden = NO;
        _textFieldVcode.text = @"";
        
        [UIView animateWithDuration:0.3 animations:^{
            _heightForOrder.constant = 183 + 44;
        }];
        [self checkInput];
    }
    
    if (_viewCodeImg.hidden == NO) {
        _viewCodeImg.hidden = YES;
        _textFieldCodeImg.text = @"";
    }
}

//我要拼团
- (IBAction)btnAppointClicked:(id)sender {
    NSString *name = _textFieldName.text;
    NSString *phone = _textFieldPhone.text;
    NSString *vcode = _textFieldVcode.text;
    
    if (name.length == 0 || phone.length != 11 || (_viewVcode.hidden == NO && vcode.length != 6)) {
        return;
    }
    
    NSLog(@"phone====%@", DATA_ENV.userInfo.user.phone);
    //判断手机号码
    if ([phone isEqualToString:DATA_ENV.userInfo.user.phone]) {
        
        if (_viewVcode.hidden == NO) {
            //验证手机验证码
            [self checkPhoneCode];
        } else {
            //拼团
            [self appointProduct];
        }
    } else {
        //验证码
        [self sendPhoneCode];
    }
}

//拼团 预约商品
- (void)appointProduct {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // reserve_type 1:预约到店 2:预约到婚博会
    [params setObject:@"1" forKey:@"reserve_type"];
    [params setObject:_textFieldPhone.text forKey:@"phone"];
    [params setObject:_textFieldName.text forKey:@"name"];
    [params setObject:_productDetail.storeId forKey:@"store_id"];
    [params setObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forKey:@"appoint_time"];
    [params setObject:_productDetail.productId forKey:@"product_id"];
    [params setObject:_productDetail.cateId forKey:@"cate_id"];
    
    [GetStoreAddReserveRequest requestWithParameters:params
                                   withIndicatorView:self.view
                                      onRequestStart:^(CIWBaseDataRequest *request) {}
                                   onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       if([request.errCode isEqualToString:RESPONSE_OK]){
                                           
                                           [MessageView displayMessage:@"拼团成功"];
                                       } else {
                                           [MessageView displayMessageByErr:request.errCode];
                                       }
                                   }
     
                                   onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                     onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

#pragma mark - private
- (void)checkInput {
    NSString *name = _textFieldName.text;
    NSString *phone = _textFieldPhone.text;
    NSString *vcode = _textFieldVcode.text;
    
    [_btnAppoint setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:0.5]];
    
    if (name.length > 0 && phone.length == 11) {
        if (_viewVcode.hidden == YES || (vcode.length == 6)) {

            [_btnAppoint setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:1]];
        }
    }
}

- (void)countdown {
    self.waitCount--;
    if (_waitCount <= 0) {
        [_waitTimer invalidate];
        _waitTimer = nil;
        
        _btnGetVcode.enabled = YES;
        [_btnGetVcode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        
        [_btnGetVcode setTitle:@"60s" forState:UIControlStateDisabled];
        
    } else {
        [_btnGetVcode setTitle:[NSString stringWithFormat:@"%lds", self.waitCount] forState:UIControlStateDisabled];
    }
}

//验证验证码
- (IBAction)checkPhoneCode {
    
    NSString *code = _textFieldVcode.text;
    if ([CommonUtil isEmpty:code]) {
        return;
    } else {
        [_textFieldVcode resignFirstResponder];
    }
    
    //验证手机验证码
    __weak typeof(self) weakSelf = self;
    [CheckPhoneCodeRequest requestWithParameters:@{@"phone":_textFieldPhone.text, @"code":code}
                               withIndicatorView:self.view
                                  onRequestStart:^(CIWBaseDataRequest *request) {}
                               onRequestFinished:^(CIWBaseDataRequest *request) {
                                   
                                   if([request.errCode isEqualToString:RESPONSE_OK]){
                                       
                                       NSNumber *data = [request.resultDic objectForKey:@"data"];
                                       if ([data isKindOfClass:[NSNumber class]] && [data boolValue] == NO) {
                                           
                                           //验证码不正确
                                           [MessageView displayMessageByErr:@"验证码不正确"];
                                           
                                       } else {
                                           //拼团
                                           [weakSelf appointProduct];
                                       }
                                   } else {
                                       
                                       [MessageView displayMessageByErr:request.errCode];
                                   }
                               }
     
                               onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                 onRequestFailed:^(CIWBaseDataRequest *request) {}];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFieldName) {
        [_textFieldPhone becomeFirstResponder];
    }
    return YES;
}

@end
