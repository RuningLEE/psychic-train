//
//  MobileLoginViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "MobileLoginViewController.h"
#import "PlaceholderColorTextField.h"
#import "UITextField+MaxLength.h"
#import "UIColor-Expanded.h"
#import "RegisterViewController.h"
#import "SendPhoneCodeRequest.h"
#import "LoginByCodeRequest.h"
#import "LoginViewController.h"
#import "JZMainTabController.h"

@interface MobileLoginViewController () <UITextFieldDelegate> {
    
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
    __weak IBOutlet NSLayoutConstraint *_constTopToCode;
    
    //登录
    __weak IBOutlet UIButton *_btnLogin;
    
    __weak IBOutlet NSLayoutConstraint *_constTop;
    
    
    __weak IBOutlet UIImageView *_imageViewLogo;
}

@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger waitCount;

@property (nonatomic, copy) NSString *imgData;

@end

@implementation MobileLoginViewController

//此方法设置的是白色子体
//******************************************
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//******************************************

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textFieldMobile.maxLength = 11;
    _textFieldVcode.maxLength = 6;
    
    _textFieldMobile.delegate = self;
    _textFieldVcode.delegate = self;
    _textFieldVcodeImg.delegate = self;
    
//    //移动动画
//    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
//    positionAnima.duration = 1;
//    positionAnima.fromValue = @(102 + 10);
//    positionAnima.toValue = @(102- 5);
//    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    positionAnima.repeatCount = HUGE_VALF;
//    //    positionAnima.repeatDuration = 2;
//    positionAnima.autoreverses = YES;
//    positionAnima.removedOnCompletion = NO;
//    positionAnima.fillMode = kCAFillModeForwards;
//    
//    [_imageViewLogo.layer addAnimation:positionAnima forKey:@"AnimationMoveY"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        _constTop.constant = -58;
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        _constTop.constant = 0;
    }];
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    if ([_sourceType isEqualToString:@"modifyPSD"]) {
        //pop到主界面
        NSArray *temArray = self.navigationController.viewControllers;
        for(UIViewController *temVC in temArray)
        {
            if ([temVC isKindOfClass:[JZMainTabController class]])
            {
                [self.navigationController popToViewController:temVC animated:YES];
                return;
            }
        }
    }
    for (NSInteger i = self.navigationController.viewControllers.count - 1; i >= 0; i--) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[LoginViewController class]] || [vc isKindOfClass:[MobileLoginViewController class]]) {
        } else {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

//清空
- (IBAction)btnClearClicked:(UIButton *)btn {
    if (btn == _btnClearMobile) {
        _textFieldMobile.text = @"";
        _labelMobileTip.hidden = YES;
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
            _constTopToCode.constant = 60 + 40;
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
    
    [SendPhoneCodeRequest requestWithParameters:parameters
                              withIndicatorView:self.view
                              withCancelSubject:[SendPhoneCodeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
                                  
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
            _constTopToCode.constant = 40;
        }];
    }
}

//注册新用户
- (IBAction)btnRegisterClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    RegisterViewController* vc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//手机验证登录
- (IBAction)btnLoginByUserClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
}

//登录
- (IBAction)btnLoginClicked:(UIButton *)btn {
    if (btn.tag == 0) {
        return;
    }
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textFieldMobile.text forKey:@"phone"];
    [parameters setValue:_textFieldVcode.text forKey:@"code"];
    
    [LoginByCodeRequest requestWithParameters:parameters
                      withIndicatorView:self.view
                      withCancelSubject:[LoginByCodeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
                          
                      } onRequestFinished:^(CIWBaseDataRequest *request) {
                          
                          if ([RESPONSE_OK isEqualToString:request.errCode]) {
                              
                              NSNumber *data = [request.resultDic objectForKey:@"data"];
                              
                              if ([data isKindOfClass:[NSNumber class]] && [data boolValue] == NO) {
                                  
                                  [MessageView displayMessage:@"登录失败"];
                                  return;
                              }
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogined" object:nil];
                              //[weakSelf.navigationController popViewControllerAnimated:YES];
                              
                              for (NSInteger i = weakSelf.navigationController.viewControllers.count - 1; i >= 0; i--) {
                                  UIViewController *vc = weakSelf.navigationController.viewControllers[i];
                                  if ([vc isKindOfClass:[LoginViewController class]] || [vc isKindOfClass:[MobileLoginViewController class]]) {
                                  } else {
                                      [self.navigationController popToViewController:vc animated:YES];
                                      break;
                                  }
                              }
                              
                          }else{
                              [MessageView displayMessageByErr:request.errCode];
                              NSLog(@"登录异常:%@",request.resultDic);
                          }
                          
                      } onRequestCanceled:^(CIWBaseDataRequest *request) {
                          
                      } onRequestFailed:^(CIWBaseDataRequest *request) {
                      }];
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
        [_textFieldVcode resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(NSNotification*)aNotification {
    [self checkInput];
}

#pragma mark - private
- (void)checkInput {
    NSString *mobile = _textFieldMobile.text;
    NSString *vcode = _textFieldVcode.text;
    
    if (mobile.length > 0 && vcode.length > 0) {
        _btnLogin.tag = 1;
        [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:1.0]];
    } else {
        _btnLogin.tag = 0;
        [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:0.5]];
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

@end
