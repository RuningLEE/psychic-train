//
//  LoginViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "LoginViewController.h"
#import "PlaceholderColorTextField.h"
#import "UITextField+MaxLength.h"
#import "FindPwdViewController.h"
#import "UIColor-Expanded.h"
#import "RegisterViewController.h"
#import "MobileLoginViewController.h"
#import "LoginRequest.h"
#import "JZMainTabController.h"

@interface LoginViewController () <UITextFieldDelegate> {
    //用户名/手机号
    __weak IBOutlet UILabel *_labelNameTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldName;
    __weak IBOutlet UIButton *_btnClearName;
    __weak IBOutlet UIControl *_controlContainer;
    
    //密码
    __weak IBOutlet UILabel *_labelPwdTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldPwd;
    __weak IBOutlet UIButton *_btnClearPwd;
    
    //验证码
    __weak IBOutlet UILabel *_labelVcodeTip;
    __weak IBOutlet PlaceholderColorTextField *_textFieldVcode;
    __weak IBOutlet UIButton *_btnClearVcode;
    __weak IBOutlet UIButton *_btnVcodeImg;
    __weak IBOutlet UIView *_viewVcode;
    __weak IBOutlet NSLayoutConstraint *_constTop;
    
    __weak IBOutlet UIButton *_btnLogin;
    
    __weak IBOutlet NSLayoutConstraint *_consTopPwd;
    __weak IBOutlet UIImageView *_imageViewLogo;
    __weak IBOutlet NSLayoutConstraint *_topToLogo;
}

//失败次数
@property (nonatomic) NSInteger failNum;

@end

@implementation LoginViewController

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
    
    _textFieldPwd.maxLength = 20;
    _textFieldVcode.maxLength = 6;
    
    _textFieldName.delegate = self;
    _textFieldPwd.delegate = self;
    _textFieldVcode.delegate = self;
    
//    //移动动画
//    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
//    positionAnima.duration = 1;
//    positionAnima.fromValue = @(102 + 10);
//    positionAnima.toValue = @(102- 5);
//    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    positionAnima.repeatCount = HUGE_VALF;
////    positionAnima.repeatDuration = 2;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    [self.navigationController popViewControllerAnimated:YES];
}

//清空
- (IBAction)btnClearClicked:(UIButton *)btn {
    if (btn == _btnClearName) {
        _textFieldName.text = @"";
        _labelNameTip.hidden = YES;
    } else if (btn == _btnClearPwd) {
        _textFieldPwd.text = @"";
        _labelPwdTip.hidden = YES;
    } else if (btn == _btnClearVcode) {
        _textFieldVcode.text = @"";
        _labelVcodeTip.hidden = YES;
    }
    
    [self checkInput];
}

//忘记密码
- (IBAction)btnForgetPwdClicked:(id)sender {
    [self.view endEditing:YES];
    
    FindPwdViewController* vc = [[FindPwdViewController alloc] initWithNibName:@"FindPwdViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//登录
- (IBAction)btnLoginClicked:(UIButton *)btn {
    if (btn.tag == 0) {
        return;
    }
    
    if (_viewVcode.hidden == NO) {
        if ([CommonUtil isEmpty:_textFieldVcode.text]) {
            [MessageView displayMessage:@"请输入图形验证码"];
            return;
        }
    }
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *name = _textFieldName.text;
    NSString *password = _textFieldPwd.text;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:name forKey:@"login_name"];
    [parameters setValue:[password md5] forKey:@"pwd"];
    if (_viewVcode.hidden == NO) {
        [parameters setValue:_textFieldVcode.text forKey:@"verify_code"];
    }
    
    [LoginRequest requestWithParameters:parameters
                      withIndicatorView:self.view
                      withCancelSubject:[LoginRequest getDefaultRequstName]
                         onRequestStart:^(CIWBaseDataRequest *request) {
                             
                         } onRequestFinished:^(CIWBaseDataRequest *request) {
                             
                             if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                 
                                 NSNumber *data = [request.resultDic objectForKey:@"data"];
                                 
                                 if ([data isKindOfClass:[NSNumber class]] && [data boolValue] == NO) {
                                     
                                     [MessageView displayMessage:@"登录失败"];
                                     return;
                                 }
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogined" object:nil];
                                 if ([_sourceType isEqualToString:@"modifyPSD"]) {//如果是从修改界面push过来 pop到主界面
                                     NSArray *temArray = self.navigationController.viewControllers;
                                     for(UIViewController *temVC in temArray)
                                     {
                                         if ([temVC isKindOfClass:[JZMainTabController class]])
                                         {
                                             [self.navigationController popToViewController:temVC animated:YES];
                                         }
                                     }
                                 } else {
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }
                                 
                                 
                             }else{
                                 
                                 NSString *data = [request.resultDic objectForKey:@"data"];
                                 if ([@"err.catpure" isEqualToString:request.errCode] || [@"err.catpure.err" isEqualToString:request.errCode]) {
                                     //图片验证码
                                     
                                     if (_viewVcode.hidden == YES) {
                                         _viewVcode.hidden = NO;
                                         
                                         _textFieldPwd.returnKeyType = UIReturnKeyNext;
                                         
                                         [UIView animateWithDuration:0.3 animations:^{
                                             _consTopPwd.constant = 40 + 60;
                                         }];
                                     } else {
                                         [MessageView displayMessageByErr:request.errCode];
                                     }
                                     NSData *imgData = [[NSData alloc] initWithBase64EncodedString:data options:0];
                                     [_btnVcodeImg setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                                 } else {
                                     [MessageView displayMessageByErr:request.errCode];
                                 }
                                 NSLog(@"登录异常:%@",request.resultDic);
                             }
                             
                         } onRequestCanceled:^(CIWBaseDataRequest *request) {
                             
                         } onRequestFailed:^(CIWBaseDataRequest *request) {
                         }];
}

//注册新用户
- (IBAction)btnRegisterClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    RegisterViewController* vc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//手机验证登录
- (IBAction)btnLoginByMobileClicked:(UIButton *)btn {
    [self.view endEditing:YES];
    
    MobileLoginViewController* vc = [[MobileLoginViewController alloc] initWithNibName:@"MobileLoginViewController" bundle:nil];
    vc.sourceType = self.sourceType;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (textField == _textFieldName) {
            _btnClearName.hidden = NO;
            _labelNameTip.hidden = NO;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = NO;
            _labelPwdTip.hidden = NO;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = NO;
            _labelVcodeTip.hidden = NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textFieldName) {
        _btnClearName.hidden = YES;
    } else if (textField == _textFieldPwd) {
        _btnClearPwd.hidden = YES;
    } else if (textField == _textFieldVcode) {
        _btnClearVcode.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (strLength > 0) {
        if (textField == _textFieldName) {
            _btnClearName.hidden = NO;
            _labelNameTip.hidden = NO;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = NO;
            _labelPwdTip.hidden = NO;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = NO;
            _labelVcodeTip.hidden = NO;
        }
    } else {
        if (textField == _textFieldName) {
            _btnClearName.hidden = YES;
            _labelNameTip.hidden = YES;
        } else if (textField == _textFieldPwd) {
            _btnClearPwd.hidden = YES;
            _labelPwdTip.hidden = YES;
        } else if (textField == _textFieldVcode) {
            _btnClearVcode.hidden = YES;
            _labelVcodeTip.hidden = YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFieldName) {
        [_textFieldPwd becomeFirstResponder];
    } else if (textField == _textFieldPwd) {
        if (_viewVcode.isHidden) {
            [_textFieldPwd resignFirstResponder];
        } else {
            [_textFieldVcode becomeFirstResponder];
        }
    } else if (textField == _textFieldVcode) {
        [_textFieldVcode resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(NSNotification*)aNotification {
    [self checkInput];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        _constTop.constant = -58;
        [_controlContainer layoutIfNeeded];
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:.3 animations:^{
        _constTop.constant = 0;
        [_controlContainer layoutIfNeeded];
    }];
}

- (IBAction)backviewClicked:(UIControl *)control {
    [control endEditing:YES];
}


#pragma mark - private
- (void)checkInput {
    NSString *name = _textFieldName.text;
    NSString *pwd = _textFieldPwd.text;
    NSString *vcode = _textFieldVcode.text;
    
    _btnLogin.tag = 0;
    [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:0.5]];
    
    if (name.length > 0 && pwd.length >= 6) {
        if (_viewVcode.hidden == YES || (vcode.length > 0)) {
            _btnLogin.tag = 1;
            [_btnLogin setBackgroundColor:[UIColor colorWithHexString:@"#601986" alpha:1.0]];
        }
    }
}

@end
