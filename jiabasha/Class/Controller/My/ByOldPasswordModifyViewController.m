//
//  ByOldPasswordModifyViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ByOldPasswordModifyViewController.h"
#import "FindPwdViewController.h"
#import "LoginViewController.h"
#import "EditUserPasswordRequest.h"
#import "CheckPwdRequest.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ByOldPasswordModifyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfieldOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textfieldNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelLosePassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonSupply;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewShowPassword;

@end

@implementation ByOldPasswordModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGesture];
    _textfieldOldPassword.tag = 22;
    _textfieldNewPassword.tag = 23;
    _textfieldOldPassword.delegate = self;
    _textfieldNewPassword.delegate = self;
    _textfieldOldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfieldNewPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    //添加监听内容输入
    [_textfieldNewPassword addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldOldPassword addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _buttonSupply.userInteractionEnabled = NO;
    [_labelLosePassword addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushFindPassword)]];
    // Do any additional setup after loading the view from its nib.
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

- (void)initGesture{
    [_labelLosePassword addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findPassword)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverKeyboard)]];
}

- (void)recoverKeyboard{
    [_textfieldNewPassword resignFirstResponder];
    [_textfieldOldPassword resignFirstResponder];
}

- (void)textFieldChanged:(UITextField *)textField{
    if (textField.tag == 22) {//旧密码
        //大于6位的时候提交按钮变彩色
        if (_textfieldNewPassword.text.length >=6 && _textfieldOldPassword.text.length>=6) {
            [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
            _buttonSupply.layer.opacity = 1;
            _buttonSupply.userInteractionEnabled = YES;
        }else{
            [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
            _buttonSupply.layer.opacity = 0.5;
            _buttonSupply.userInteractionEnabled = NO;
        }
        //限制20长度
        if (textField.text.length>20) {
            _textfieldOldPassword.text = [textField.text substringToIndex:21];
        }
    }else{
        //大于6位的时候提交按钮变彩色
        if (_textfieldNewPassword.text.length >=6 && _textfieldOldPassword.text.length>=6) {
            [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
            _buttonSupply.layer.opacity = 1;
            _buttonSupply.userInteractionEnabled = YES;
        }else{
            [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
            _buttonSupply.layer.opacity = 0.5;
            _buttonSupply.userInteractionEnabled = NO;
        }
        if (textField.text.length>20) {
            _textfieldNewPassword.text = [textField.text substringToIndex:21];
        }
    }
}

#pragma mark labelClick
- (void)findPassword{
    FindPwdViewController* findpwd = [[FindPwdViewController alloc]init];
    [self.navigationController pushViewController:findpwd animated:YES];
}


#pragma mark buttonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        _imageviewShowPassword.image = [UIImage imageNamed:@"显示密码"];
    } else {
        _textfieldNewPassword.secureTextEntry = YES;
        _imageviewShowPassword.image = [UIImage imageNamed:@"不显示密码"];
    }
}


/**
  确认修改密码
 */
- (IBAction)supplyAction:(id)sender {
    [self recoverKeyboard];
    //辨别密码是否正确
    //辨别密码复杂度
    [self checkPwd];
}

//确认修改
- (void)confirmChangePassword{
    /*
     "access_token": "NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPPe69/zX1hAMs/u8xz1q7y1ny3eNp6b1+Ed/zEZtatp550qCyVfC5AlXr6z2DW+fGbef0qwH56G8E=","old_pwd": "oldpwd","new_pwd": "newpwd","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[_textfieldOldPassword.text md5],@"old_pwd",[_textfieldNewPassword.text md5],@"new_pwd", nil];
    [EditUserPasswordRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[EditUserPasswordRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            DATA_ENV.userInfo = nil;
            [self.view makeToast:@"修改成功"];
            [self performSelector:@selector(pushLogin) withObject:nil afterDelay:2];
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
                                        [self confirmChangePassword];
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

- (void)pushFindPassword{
    FindPwdViewController* findPassWord = [[FindPwdViewController alloc]init];
    [self.navigationController pushViewController:findPassWord animated:YES];
}

- (void)pushLogin{
    LoginViewController* login = [[LoginViewController alloc]init];
    login.sourceType = @"modifyPSD";
    [self.navigationController pushViewController:login animated:YES];
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
@end
