//
//  FindPwdViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "FindPwdViewController.h"
#import "PlaceholderColorTextField.h"
#import "UITextField+MaxLength.h"
#import "UIColor-Expanded.h"
#import "FindPwdSendCodeRequest.h"
//#import "CheckFindPwdCodeRequest.h"
#import "EditUserPwdByCodeRequest.h"
#import <NSObject+Core.h>

@interface FindPwdViewController () <UITextFieldDelegate> {
    
    //手机号
    __weak IBOutlet UILabel *_labelMobileTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldMobile;
    __weak IBOutlet UIButton *_btnClearMobile;
    
    //验证码
    __weak IBOutlet UILabel *_labelVcodeTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldVcode;
    __weak IBOutlet UIButton *_btnClearVcode;
    __weak IBOutlet UIButton *_btnGetVcode;
    
    //图形验证码
    __weak IBOutlet UILabel *_labelVcodeImgTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldVcodeImg;
    __weak IBOutlet UIButton *_btnClearVcodeImg;
    __weak IBOutlet UIButton *_btnVcodeImg;
    __weak IBOutlet UIView *_viewVcode;
    __weak IBOutlet NSLayoutConstraint *_constTop;

    //密码
    __weak IBOutlet UILabel *_labelPwdTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldPwd;
    __weak IBOutlet UIButton *_btnClearPwd;
    __weak IBOutlet UIButton *_btnShowPwd;
    
    //重置密码
    __weak IBOutlet UIButton *_btnResetPwd;
}

@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger waitCount;

@property (nonatomic, copy) NSString *imgData;

@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textFieldMobile.maxLength = 11;
    _textFieldVcode.maxLength = 6;
    _textFieldPwd.maxLength = 20;
    
    _textFieldMobile.delegate = self;
    _textFieldVcode.delegate = self;
    _textFieldVcodeImg.delegate = self;
    _textFieldPwd.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//清空
- (IBAction)btnClearClicked:(UIButton *)btn {
    if (btn == _btnClearMobile) {
        _textFieldMobile.text = @"";
        _labelMobileTip.hidden = YES;
    } else if (btn == _btnClearPwd) {
        _textFieldPwd.text = @"";
        _labelPwdTip.hidden = YES;
    } else if (btn == _btnClearVcode) {
        _textFieldVcode.text = @"";
        _labelVcodeTip.hidden = YES;
    } else if (btn == _btnClearVcodeImg) {
        _textFieldVcodeImg.text = @"";
        _labelVcodeImgTip.hidden = YES;
    }
    
    [self checkInput];
}

//获取验证码
- (IBAction)btnGetVcodeClicked:(id)sender {
    //0-灰色【获取验证码】 1-彩色【获取验证码】 2-灰色【60s】 3-彩色【重新获取验证码】
    if (_btnGetVcode.tag == 0 || _btnGetVcode.tag == 2) {
        return;
    }
    
    if (self.imgData && _viewVcode.hidden == YES) {
        _viewVcode.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _constTop.constant = 60;
        }];
        return;
    }
    
    if (_viewVcode.hidden == NO) {
        if ([CommonUtil isEmpty:_textFieldVcodeImg.text]) {
            [MessageView displayMessage:@"请输入图形验证码"];
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textFieldMobile.text forKey:@"phone"];
    if (_viewVcode.hidden == NO) {
        [parameters setValue:_textFieldVcodeImg.text forKey:@"verify_code"];
    }
    
    [FindPwdSendCodeRequest requestWithParameters:parameters
                                withIndicatorView:self.view
                                   onRequestStart:^(CIWBaseDataRequest *request) {
                                       
                                   } onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                           
                                           //取到验证码
                                           [self getVcodeSuccess];
                                       }else{
                                           if ([@"err.catpure" isEqualToString:request.errCode] || [@"err.catpure.err" isEqualToString:request.errCode]) {
                                               //图片验证码
                                               self.imgData = [request.resultDic objectForKey:@"data"];
                                               NSData *imgData = [[NSData alloc] initWithBase64EncodedString:_imgData options:0];
                                               [_btnVcodeImg setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                                               
                                               if ([@"err.catpure" isEqualToString:request.errCode]) {
                                                   //取到验证码
                                                   [self getVcodeSuccess];
                                                   
                                               } else if ([@"err.catpure.err" isEqualToString:request.errCode] && _viewVcode.hidden == NO) {
                                                   //验证码错误
                                                   [MessageView displayMessageByErr:request.errCode];
                                               }
                                           } else {
                                               
                                               [MessageView displayMessageByErr:request.errCode];
                                           }
                                       }
                                       
                                   } onRequestCanceled:^(CIWBaseDataRequest *request) {
                                       
                                   } onRequestFailed:^(CIWBaseDataRequest *request) {
                                       //@"检查网络";
                                   }];
    
}

//成功取得验证码
- (void)getVcodeSuccess {
    [self.waitTimer invalidate];
    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    _btnGetVcode.tag = 2;
    [_btnGetVcode setTitle:@"60s" forState:UIControlStateNormal];
    self.waitCount = 60;
    _btnGetVcode.enabled = NO;
    
    if (_viewVcode.hidden == NO) {
        _viewVcode.hidden = YES;
        _textFieldVcodeImg.text = @"";
        
        [UIView animateWithDuration:0.3 animations:^{
            _constTop.constant = 0;
        }];
    }
}

//显示密码
- (IBAction)btnShowPwdClicked:(UIButton *)btn {
    if (_textFieldPwd.isSecureTextEntry) {
        _textFieldPwd.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
    } else {
        _textFieldPwd.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"不显示密码"] forState:UIControlStateNormal];
    }
}

//重置密码
- (IBAction)btnResetPwdClicked:(UIButton *)btn {
    if (btn.tag == 0) {
        return;
    }
    
    //密码为纯数字（字母）时，点击弹toast：「密码过于简单」。
    if ([_textFieldPwd.text isNumber]) {
        [MessageView displayMessage:@"密码过于简单"];
        return;
    }
    
    [self.view endEditing:YES];
    
    //修改密码
    [self editUserPwd];
}

- (IBAction)backviewClicked:(UIControl *)control {
    [control endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (textField == _textFieldMobile) {
            _btnClearMobile.hidden = NO;
            _labelMobileTip.hidden = NO;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = NO;
            _labelPwdTip.hidden = NO;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = NO;
            _labelVcodeTip.hidden = NO;
        } else if (textField == _textFieldVcodeImg) {
            _btnClearVcodeImg.hidden = NO;
            _labelVcodeImgTip.hidden = NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textFieldMobile) {
        _btnClearMobile.hidden = YES;
    } else if (textField == _textFieldPwd) {
        _btnClearPwd.hidden = YES;
    } else if (textField == _textFieldVcode) {
        _btnClearVcode.hidden = YES;
    } else if (textField == _textFieldVcodeImg) {
        _btnClearVcodeImg.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (strLength > 0) {
        if (textField == _textFieldMobile) {
            _btnClearMobile.hidden = NO;
            _labelMobileTip.hidden = NO;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = NO;
            _labelPwdTip.hidden = NO;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = NO;
            _labelVcodeTip.hidden = NO;
        } else if (textField == _textFieldVcodeImg) {
            _btnClearVcodeImg.hidden = NO;
            _labelVcodeImgTip.hidden = NO;
        }
    } else {
        if (textField == _textFieldMobile) {
            _btnClearMobile.hidden = YES;
            _labelMobileTip.hidden = YES;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = YES;
            _labelPwdTip.hidden = YES;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = YES;
            _labelVcodeTip.hidden = YES;
        } else if (textField == _textFieldVcodeImg) {
            _btnClearVcodeImg.hidden = YES;
            _labelVcodeImgTip.hidden = YES;
        }
    }
    
    //获取验证码判断
    if (textField == _textFieldMobile) {
        
        if (strLength > 11) {
            return NO;
        } else if (strLength == 11) {
            if (_btnGetVcode.tag == 0) {
                _btnGetVcode.tag = 1;
                _btnGetVcode.enabled = YES;
                [_btnGetVcode setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        } else {
            if (_btnGetVcode.tag == 1 || _btnGetVcode.tag == 3) {
                _btnGetVcode.tag = 0;
                _btnGetVcode.enabled = NO;
                [_btnGetVcode setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFieldMobile) {
        [_textFieldVcode becomeFirstResponder];
    } else if (textField == _textFieldVcode) {
        [_textFieldPwd becomeFirstResponder];
    } else if (textField == _textFieldPwd) {
        [_textFieldPwd resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(NSNotification*)aNotification {
    [self checkInput];
}

#pragma mark - private
- (void)checkInput {
    NSString *mobile = _textFieldMobile.text;
    NSString *pwd = _textFieldPwd.text;
    NSString *vcode = _textFieldVcode.text;
    
    if (mobile.length > 0 && pwd.length > 0 && vcode.length > 0) {
        _btnResetPwd.tag = 1;
        [_btnResetPwd setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:1.0]];
    } else {
        _btnResetPwd.tag = 0;
        [_btnResetPwd setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:0.5]];
    }
}

- (void)countdown {
    self.waitCount--;
    if (_waitCount <= 0) {
        [_waitTimer invalidate];
        _waitTimer = nil;
        
        if (_textFieldMobile.text.length == 11) {
            _btnGetVcode.tag = 3;
            _btnGetVcode.enabled = YES;
            [_btnGetVcode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        } else {
            _btnGetVcode.tag = 1;
            _btnGetVcode.enabled = NO;
            [_btnGetVcode setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        
    } else {
        [_btnGetVcode setTitle:[NSString stringWithFormat:@"%lds", self.waitCount] forState:UIControlStateNormal];
    }
}

////验证手机验证码
//- (void)checkPhoneCode {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:_textFieldMobile.text forKey:@"phone"];
//    [parameters setValue:_textFieldVcode.text forKey:@"code"];
//    
//    [CheckFindPwdCodeRequest requestWithParameters:parameters
//                                 withIndicatorView:self.view
//                                    onRequestStart:^(CIWBaseDataRequest *request) {
//                                        
//                                    } onRequestFinished:^(CIWBaseDataRequest *request) {
//                                        
//                                        if ([RESPONSE_OK isEqualToString:request.errCode]) {
//                                            
//                                            //验证手机验证码
//                                            NSNumber *data = [request.resultDic objectForKey:@"data"];
//                                            
//                                            if ([data isKindOfClass:[NSNumber class]] && [data boolValue]) {
//                                                //修改密码
//                                                [self editUserPwd];
//                                            }
//                                            
//                                        }else{
//                                            [MessageView displayMessage:@"验证码不正确"];
//                                        }
//                                        
//                                    } onRequestCanceled:^(CIWBaseDataRequest *request) {
//                                        
//                                    } onRequestFailed:^(CIWBaseDataRequest *request) {
//                                        //@"检查网络";
//                                    }];
//    
//}

//修改密码
- (void)editUserPwd {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textFieldMobile.text forKey:@"phone"];
    [parameters setValue:_textFieldVcode.text forKey:@"code"];
    [parameters setValue:[_textFieldPwd.text md5] forKey:@"new_pwd"];
    
    __weak typeof(self) weakSelf = self;
    
    [EditUserPwdByCodeRequest requestWithParameters:parameters
                                  withIndicatorView:self.view
                                     onRequestStart:^(CIWBaseDataRequest *request) {
                                         
                                     } onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                             
                                             //注册完成
                                             [_btnResetPwd setTitle:@"修改成功" forState:UIControlStateNormal];
                                             //2秒后跳转首页
                                             weakSelf.view.userInteractionEnabled = NO;
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogined" object:nil];
                                             
                                             dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                                             
                                             dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                                             });
                                             
                                         }else{
                                             [MessageView displayMessageByErr:request.errCode];
                                         }
                                         
                                     } onRequestCanceled:^(CIWBaseDataRequest *request) {
                                         
                                     } onRequestFailed:^(CIWBaseDataRequest *request) {
                                         //@"检查网络";
                                     }];
    
}

@end
