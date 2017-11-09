//
//  AppointDesignViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "AppointDesignViewController.h"
#import "PlaceholderColorTextField.h"
#import "UITextField+MaxLength.h"
#import "UIColor-Expanded.h"
#import "CheckPhoneIsBindRequest.h"
#import "SendPhoneCodeRequest.h"
#import "CheckPhoneCodeRequest.h"
#import "CustomPickerViewController.h"
#import "AddKeziRequest.h"

@interface AppointDesignViewController () <UITextFieldDelegate, CustomPickerDelegate, UITextFieldDelegate> {
    __weak IBOutlet PlaceholderColorTextField *_textFieldName;
    __weak IBOutlet PlaceholderColorTextField *_textFieldPhone;
    __weak IBOutlet UIButton *_btnNextStep;
    
    __weak IBOutlet UIView *_viewApply;
    __weak IBOutlet UILabel *_labelRoom;
    __weak IBOutlet UILabel *_labelHall;
    __weak IBOutlet UILabel *_labelKitchen;
    __weak IBOutlet UILabel *_labelToilet;
    
    __weak IBOutlet PlaceholderColorTextField *_textFieldCell;
    __weak IBOutlet PlaceholderColorTextField *_textFieldArea;
    __weak IBOutlet UIButton *_btnInspection;
    
    //验证码
    __weak IBOutlet UIView *_viewCode;
    __weak IBOutlet PlaceholderColorTextField *_textFieldCode;
    __weak IBOutlet UIButton *_btnGetCode;
    __weak IBOutlet UILabel *_labelCheckCode;
    
    __weak IBOutlet UIView *_viewCodeImg;
    __weak IBOutlet PlaceholderColorTextField *_textFieldCodeImg;
    __weak IBOutlet UIButton *_btnCodeImg;
    __weak IBOutlet UIButton *_btnCheckCode;
    
    // 提交
    __weak IBOutlet NSLayoutConstraint *_topForBtnCheckCode;
    
    //申请成功
    __weak IBOutlet UIView *_viewSuccess;
}
//倒计时用timer
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger waitCount;

@property (nonatomic, strong) CustomPickerViewController *customPickerViewController;
@property (nonatomic) NSInteger structType;

@property (nonatomic, copy) NSString *imgData;
@property (nonatomic, copy) NSString *phonenumber; //已经发送验证码的手机

@end

@implementation AppointDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewApply.hidden = YES;
    
    _textFieldPhone.maxLength = 11;
    _textFieldCode.maxLength = 6;
    
    //登录的场合，用户名和手机号自动读取
    if (DATA_ENV.isLogin) {
        _textFieldName.text = DATA_ENV.userInfo.user.uname;
        _textFieldPhone.text = DATA_ENV.userInfo.user.phone;
        
        if ([CommonUtil isEmpty:_textFieldName.text] || _textFieldPhone.text.length != 11) {
            _btnNextStep.tag = 0;
            _btnNextStep.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnNextStep.tag = 1;
            _btnNextStep.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //监听输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.waitTimer invalidate];
}

- (IBAction)backviewClicked:(UIControl *)control {
    [control endEditing:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//下一步
- (IBAction)btnNextStepClicked:(id)sender {
    if (_btnNextStep.tag == 0) {
        return;
    }
    
    [self.view endEditing:YES];
    
    //判断手机号码是否已经取得验证码
    if (self.phonenumber && [self.phonenumber isEqualToString:_textFieldPhone.text]) {
        [self.view bringSubviewToFront:_viewCode];
        _viewCode.hidden = NO;
        return;
    }
    
    //已登录时判断
    if (DATA_ENV.isLogin) {
        
        //判断手机绑定
        if ([_textFieldPhone.text isEqualToString:DATA_ENV.userInfo.user.phone]) {
            //预约设计
            _viewApply.hidden = NO;
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        [CheckPhoneIsBindRequest requestWithParameters:@{@"phone":_textFieldPhone.text}
                                     withIndicatorView:self.view
                                        onRequestStart:^(CIWBaseDataRequest *request) {}
                                     onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if([request.errCode isEqualToString:RESPONSE_OK]){
                                             
                                             NSNumber *data = [request.resultDic objectForKey:@"data"];
                                             
                                             if ([data isKindOfClass:[NSNumber class]] && [data boolValue] == NO) {
                                                 
                                                 //手机未绑定的情况发送验证码
                                                 [weakSelf sendPhoneCode];
                                             } else {
                                                 //预约设计
                                                 _viewApply.hidden = NO;
                                             }
                                             
                                         } else {
                                             [MessageView displayMessageByErr:request.errCode];
                                         }
                                     }
         
                                     onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                       onRequestFailed:^(CIWBaseDataRequest *request) {}];
    } else {
        //手机未绑定的情况发送验证码
        [self sendPhoneCode];
    }
}

//提交验证码
- (IBAction)btnCheckCodeClicked:(id)sender {
    
    if (_viewCodeImg.hidden == NO) {
        [MessageView displayMessage:@"请重新获取验证码"];
        return;
    }
    
    NSString *code = _textFieldCode.text;
    if ([CommonUtil isEmpty:code]) {
        return;
    } else {
        [_textFieldCode resignFirstResponder];
    }
    
    _labelCheckCode.hidden = YES;
    
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
                                           _labelCheckCode.hidden = NO;
                                           _topForBtnCheckCode.constant = 40;
                                           
                                       } else {
                                           //预约设计
                                           _viewApply.hidden = NO;
                                           
                                           _viewCode.hidden = YES;
                                           [weakSelf.view sendSubviewToBack:_viewCode];
                                       }
                                       
                                       
                                   } else {
                                       [MessageView displayMessageByErr:request.errCode];
                                   }
                               }
     
                               onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                 onRequestFailed:^(CIWBaseDataRequest *request) {}];
    
}

//预约设计
- (IBAction)btnInspectionClicked:(id)sender {
    if (_btnInspection.tag == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:@"预约设计" forKey:@"kezi_type"];
    [params setObject:_textFieldPhone.text forKey:@"phone"];
    [params setObject:_textFieldName.text forKey:@"uname"];
    [params setObject:_textFieldCell.text forKey:@"block"];
    [params setObject:_textFieldArea.text forKey:@"area"];
    [params setObject:[NSString stringWithFormat:@"%@室%@厅%@厨%@卫", _labelRoom.text, _labelHall.text, _labelKitchen.text, _labelToilet.text] forKey:@"house_type"];
    
    [params setObject:_labelRoom.text forKey:@"room"];
    [params setObject:_labelHall.text forKey:@"hall"];
    [params setObject:_labelKitchen.text forKey:@"kitchen"];
    [params setObject:_labelToilet.text forKey:@"bathroom"];
    
    //添加客资
    __weak typeof(self) weakSelf = self;
    [AddKeziRequest requestWithParameters:params
                        withIndicatorView:self.view
                           onRequestStart:^(CIWBaseDataRequest *request) {}
                        onRequestFinished:^(CIWBaseDataRequest *request) {
                            
                            if([request.errCode isEqualToString:RESPONSE_OK]){
                                
                                _viewSuccess.hidden = NO;
                                
                                [weakSelf.view bringSubviewToFront:_viewSuccess];
                                
                            } else {
                                [MessageView displayMessageByErr:request.errCode];
                            }
                        }
     
                        onRequestCanceled:^(CIWBaseDataRequest *request) {}
                          onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

- (IBAction)successCloseClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//关闭验证码画面
- (IBAction)btnCloseCodeView:(id)sender {
    _viewCode.hidden = YES;
    [self.view sendSubviewToBack:_viewCode];
}

//重新发送验证码
- (IBAction)btnGetCodeClicked:(id)sender {
    [self sendPhoneCode];
}

//房屋结构 室 厅 厨 卫
- (IBAction)structClicked:(UIControl *)control {
    [self.view endEditing:YES];
    
    self.structType = control.tag;
    
    self.customPickerViewController = [[CustomPickerViewController alloc] initWithNibName:@"CustomPickerViewController" bundle:nil];
    _customPickerViewController.view.frame = self.view.bounds;
    _customPickerViewController.selectTitle = @"选择数量";
    _customPickerViewController.delegate = self;
    [self.view addSubview:_customPickerViewController.view];
}

//发送短信验证码
- (void)sendPhoneCode {
    
    if (self.imgData && _viewCodeImg.hidden == YES) {
        _viewCodeImg.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _topForBtnCheckCode.constant = 60;
        }];
        return;
    }
    
    if (_viewCodeImg.hidden == NO) {
        if ([CommonUtil isEmpty:_textFieldCodeImg.text]) {
            [MessageView displayMessage:@"请输入图形验证码"];
            return;
        }
    }
    
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
                                              
                                              if (_viewCode.hidden == YES) {
                                                  _viewCode.hidden = NO;
                                                  
                                                  _viewCodeImg.hidden = NO;
                                                  _btnGetCode.enabled = YES;
                                                  [_textFieldCodeImg becomeFirstResponder];
                                                  [_btnGetCode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                                                  _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:11];
                                                  
                                                  [UIView animateWithDuration:0.3 animations:^{
                                                      _topForBtnCheckCode.constant = 60;
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
    [_btnGetCode setTitle:@"60s" forState:UIControlStateNormal];
    _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:13];
    self.waitCount = 60;
    _btnGetCode.enabled = NO;
    
    [self.view bringSubviewToFront:_viewCode];
    _viewCode.hidden = NO;
    
    if (_viewCodeImg.hidden == NO) {
        _viewCodeImg.hidden = YES;
        _textFieldCodeImg.text = @"";
        
        [UIView animateWithDuration:0.3 animations:^{
            _topForBtnCheckCode.constant = 15;
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFieldName) {
        [_textFieldPhone becomeFirstResponder];
    } else if (textField == _textFieldPhone) {
        [_textFieldPhone resignFirstResponder];
    } else if (textField == _textFieldCell) {
        [_textFieldArea becomeFirstResponder];
    } else if (textField == _textFieldArea) {
        [_textFieldArea resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (textField == _textFieldName || textField == _textFieldPhone) {
        if ([CommonUtil isEmpty:_textFieldName.text] || _textFieldPhone.text.length != 11) {
            _btnNextStep.tag = 0;
            _btnNextStep.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnNextStep.tag = 1;
            _btnNextStep.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
    
    if (textField == _textFieldCell || textField == _textFieldArea) {
        if ([CommonUtil isEmpty:_textFieldCell.text] || [CommonUtil isEmpty:_textFieldArea.text]) {
            _btnInspection.tag = 0;
            _btnInspection.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnInspection.tag = 1;
            _btnInspection.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
    
    if (textField == _textFieldCode) {
        if ([CommonUtil isEmpty:_textFieldCode.text] || _viewCodeImg.hidden == NO) {
            _btnCheckCode.tag = 0;
            _btnCheckCode.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnCheckCode.tag = 1;
            _btnCheckCode.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
}

#pragma mark - CustomPickerDelegate
//行数
- (NSInteger)numberOfRowsInPickerView:(UIPickerView *)pickerView {
    return 10;
}

//每行表示的值
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld", row + 1];
}

//确认时返回 选择的行数和表示的值
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSString *title = [NSString stringWithFormat:@"%ld", row + 1];
    if (self.structType == 0) {
        _labelRoom.text = title;
    } else if (self.structType == 1) {
        _labelHall.text = title;
    } else if (self.structType == 2) {
        _labelKitchen.text = title;
    } else if (self.structType == 3) {
        _labelToilet.text = title;
    }
}

#pragma mark - private
- (void)countdown {
    self.waitCount--;
    if (_waitCount <= 0) {
        [_waitTimer invalidate];
        _waitTimer = nil;
        
        _btnGetCode.enabled = YES;
        [_btnGetCode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [_btnGetCode setTitle:@"60s" forState:UIControlStateDisabled];
    } else {
        [_btnGetCode setTitle:[NSString stringWithFormat:@"%lds", self.waitCount] forState:UIControlStateDisabled];
    }
}

@end
