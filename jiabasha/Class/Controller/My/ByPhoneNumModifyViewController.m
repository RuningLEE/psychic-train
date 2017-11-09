//
//  ByPhoneNumModifyViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ByPhoneNumModifyViewController.h"
#import "LoginViewController.h"
#import "SendPhoneCodeRequest.h"
#import "CheckPhoneCodeRequest.h"
#import "CheckPwdRequest.h"
#import "ModifyPasswordByPhoneNum.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ByPhoneNumModifyViewController ()<UITextFieldDelegate>{
    NSInteger countTimer;
    NSTimer *timermy;
}

@property (weak, nonatomic) IBOutlet UITextField *textfieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *textfieldVcode;
@property (weak, nonatomic) IBOutlet UITextField *textfieldNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelVcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewPasswordShow;

@property (weak, nonatomic) IBOutlet UIView *imageVcodeView;
@property (weak, nonatomic) IBOutlet UITextField *textfieldImageVcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonVcode;
@property (weak, nonatomic) IBOutlet UILabel *labelImageVcode;
@property (nonatomic, copy) NSString *imgData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVCHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNPTop;
@property (assign, nonatomic) int requestCount;//==3显示图形验证码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@end

@implementation ByPhoneNumModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];

    [self initGesture];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{

    [timermy invalidate];
    timermy = nil;
    
}

- (void)initGesture{

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard)]];

}

- (void)recoverKeyboard{

    [_textfieldNewPassword resignFirstResponder];
    [_textfieldVcode resignFirstResponder];
    [_textfieldMobile resignFirstResponder];

}

- (void)setUpSubViews{

    //添加监听内容输入
    [_textfieldMobile addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldMobile.tag = 97;
    
    [_textfieldNewPassword addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldNewPassword.tag = 98;
    
    [_textfieldImageVcode addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldImageVcode.tag = 96;
    
    [_textfieldVcode addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldVcode.tag = 99;
    
    _textfieldNewPassword.delegate = self;

    _labelVcode.textColor = [UIColor lightGrayColor];
    _labelVcode.userInteractionEnabled = NO;
    
    _buttonDone.userInteractionEnabled = NO;
    
    [_labelVcode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVcodeRequest)]];
    
    countTimer = 60;
    _requestCount = 0;
    
    _constraintContentHeight.constant = kScreenHeight - 64;
    _constraintContentWidth.constant = kScreenWidth;
    //隐藏图片验证码
    _constraintNPTop.constant = 0;
    _constraintVCHeight.constant = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}

//监听textfield内容输入
- (void)textFieldChanged:(UITextField *)textField{
    if (textField.tag == 97) {//手机输入框
        if (textField.text.length > 11) {
            _textfieldMobile.text = [textField.text substringToIndex:11];
        }
        if (countTimer == 60) {
            if (textField.text.length == 11) {
                _labelVcode.textColor = RGB(96, 25, 134);
                _labelVcode.userInteractionEnabled = YES;
            }else{
                _labelVcode.textColor = [UIColor lightGrayColor];
                _labelVcode.userInteractionEnabled = NO;
            }
        }
    }else if (textField.tag == 99){//验证码输入框
        if (textField.text.length > 6) {
            _textfieldVcode.text = [textField.text substringToIndex:6];
        }
    }else if (textField.tag == 98){//密码输入框
        if (textField.text.length > 20) {
            _textfieldNewPassword.text = [textField.text substringToIndex:20];
        }
    }
    //如果电话为11位并且和当前电话一致 验证码为6位 密码格式正确 则完成btn为彩色
    if (_textfieldMobile.text.length == 11 && _textfieldVcode.text.length == 6 && _textfieldNewPassword.text.length >=6) {
        [_buttonDone setBackgroundColor:RGB(96, 25, 134)];
        _buttonDone.layer.opacity = 1;
        _buttonDone.userInteractionEnabled = YES;
    }else{
        [_buttonDone setBackgroundColor:RGB(96, 25, 134)];
        _buttonDone.layer.opacity = 0.5;
        _buttonDone.userInteractionEnabled = NO;
    }
    //图片验证码输入框
    if (textField.tag == 96) {
        if (textField.text.length != 0) {
            _labelImageVcode.hidden = NO;
            
            if (textField.text.length == 4) {
                _labelVcode.textColor = RGB(96, 25, 134);
                _labelVcode.userInteractionEnabled = YES;
            }else{
                _labelVcode.textColor = [UIColor lightGrayColor];
                _labelVcode.userInteractionEnabled = NO;
            }
            
        } else {
            _labelImageVcode.hidden = YES;
        }
    }
}

#pragma mark labelClick
- (void)getVcodeSucess{
    
    //判断和本地手机号是否一致 如果不一致 弹出dialog提示 “手机号与注册时不一致”
    _labelVcode.userInteractionEnabled = NO;

    __weak typeof(self) Weakself = self;
    
    timermy = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (countTimer) {
            
            countTimer--;
            
            Weakself.labelVcode.text = [NSString stringWithFormat:@"%ds",countTimer];
            
            _labelVcode.textColor = [UIColor lightGrayColor];
            _labelVcode.userInteractionEnabled = NO;
            
        }else{
            
            if (_textfieldMobile.text.length == 11) {
                _labelVcode.textColor = RGB(96, 25, 134);
                _labelVcode.userInteractionEnabled = YES;
            }else{
                _labelVcode.textColor = [UIColor lightGrayColor];
                _labelVcode.userInteractionEnabled = NO;
            }
            
            countTimer = 60;
            
            Weakself.labelVcode.text = @"获取验证码";
            
            [timer invalidate];
            
        }
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timermy forMode:NSDefaultRunLoopMode];

}

#pragma mark - Request

//获取验证码
- (void)getVcodeRequest{
    
    if (self.imgData && _constraintVCHeight.constant == 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _constraintVCHeight.constant = 60;
            _constraintNPTop.constant = 10;
        }];
        return;
    }
    
    if (_constraintVCHeight.constant == 60) {
        if ([CommonUtil isEmpty:_textfieldImageVcode.text]) {
            [MessageView displayMessage:@"请输入图形验证码"];
            return;
        }
    }


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textfieldMobile.text forKey:@"phone"];
    if (_constraintVCHeight.constant == 60) {
        [parameters setValue:_textfieldImageVcode.text forKey:@"verify_code"];
    }
    
    [SendPhoneCodeRequest requestWithParameters:parameters
                              withIndicatorView:self.view
                              withCancelSubject:[SendPhoneCodeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
                                  
                              } onRequestFinished:^(CIWBaseDataRequest *request) {
                                  
                                  if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                      
                                      //取到验证码
                                      [self getVcodeSucess];
                                  }else{
                                      if ([@"err.catpure" isEqualToString:request.errCode] || [@"err.catpure.err" isEqualToString:request.errCode]) {

                                          //图片验证码
                                          self.imgData = [request.resultDic objectForKey:@"data"];
                                          NSData *imgData = [[NSData alloc] initWithBase64EncodedString:_imgData options:0];
                                          [_buttonVcode setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                                          
                                          if ([@"err.catpure" isEqualToString:request.errCode]) {
                                              //取到验证码
                                              [self getVcodeSucess];
                                              
                                          } else if ([@"err.catpure.err" isEqualToString:request.errCode] && _constraintVCHeight.constant == 60) {
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

//确认修改
- (void)confirmRequest{
/*
{"phone":"18999999999","code":"197877","new_pwd":"688d496b16b394d7cd6d29985f349510","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
 */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_textfieldVcode.text,@"code",[_textfieldNewPassword.text md5],@"new_pwd",_textfieldMobile.text,@"phone", nil];
    [ModifyPasswordByPhoneNum requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ModifyPasswordByPhoneNum getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"修改成功" duration:1 position:CSToastPositionCenter];
            DATA_ENV.userInfo = nil;
            [self performSelector:@selector(pushLogin) withObject:nil afterDelay:2];

        } else {
            [self.view makeToast:@"修改失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

//检查用户注册密码是否符合要求
- (void)checkPwd {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_textfieldNewPassword.text forKey:@"pwd"];
    
    [CheckPwdRequest requestWithParameters:parameters
                         withIndicatorView:self.view
                            onRequestStart:^(CIWBaseDataRequest *request) {
                                
                            } onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                    
                                    //符合要求
                                    NSNumber *data = [request.resultDic objectForKey:@"data"];
                                    
                                    if ([data isKindOfClass:[NSNumber class]] && [data boolValue]) {
                                        //确认修改
                                        [self confirmRequest];
                                    } else {
                                        [MessageView displayMessage:@"密码不符合要求"];
                                    }
                                    
                                }else{
                                    [MessageView displayMessage:@"密码不符合要求"];
                                }
                                
                            } onRequestCanceled:^(CIWBaseDataRequest *request) {
                                
                            } onRequestFailed:^(CIWBaseDataRequest *request) {
                                //@"检查网络";
                            }];
    
}

#pragma mark ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender {

    [self recoverKeyboard];
    
//    if ([self checkIsHaveNumAndLetter:_textfieldNewPassword.text] == 1 || [self checkIsHaveNumAndLetter:_textfieldNewPassword.text] == 2) {
//        [self.view makeToast:@"密码过于简单"];
//        return;
//    }
    //修改之前先要判断密码是否符合要求
    [self checkPwd];
    
}


/**
 清空图形验证码输入框
 */
- (IBAction)clearImageVcodeTextfield:(id)sender {
    _textfieldImageVcode.text = @"";
}

- (IBAction)watchPasswordAction:(id)sender {
    
//    _textfieldNewPassword.secureTextEntry = !_textfieldNewPassword.secureTextEntry;
//    NSString* text = _textfieldNewPassword.text;
//    
//    _textfieldNewPassword.text = @" ";
//    _textfieldNewPassword.text = text;
//    
//    _textfieldNewPassword.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    if (_textfieldNewPassword.isSecureTextEntry) {
        _textfieldNewPassword.secureTextEntry = NO;
        _imageviewPasswordShow.image = [UIImage imageNamed:@"显示密码"];
    } else {
        _textfieldNewPassword.secureTextEntry = YES;
        _imageviewPasswordShow.image = [UIImage imageNamed:@"不显示密码"];
    }
    
}

//判断字符串内容
-(int)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}

- (void)pushLogin{
    LoginViewController* login = [[LoginViewController alloc]init];
    login.sourceType = @"modifyPSD";
    [self.navigationController pushViewController:login animated:YES];
}


@end
