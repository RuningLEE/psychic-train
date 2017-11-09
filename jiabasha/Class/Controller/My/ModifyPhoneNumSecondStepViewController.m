//
//  ModifyPhoneNumSecondStepViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ModifyPhoneNumSecondStepViewController.h"
#import "SendPhoneCodeRequest.h"
#import "ChangeBindPhoneRequest.h"
#import "JZMainTabController.h"
#import "CheckPhoneIsBindRequest.h"

@interface ModifyPhoneNumSecondStepViewController ()
{
    NSInteger countTimer;
    NSTimer *timermy;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContentHeight;
@property (weak, nonatomic) IBOutlet UITextField *textfieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *textfieldVcode;
@property (weak, nonatomic) IBOutlet UILabel *labelVcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSupply;
//图形验证码
@property (weak, nonatomic) IBOutlet UILabel *labelImageVcode;
@property (weak, nonatomic) IBOutlet UITextField *textfieldImageVcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonImageVcode;
@property (nonatomic, copy) NSString *imgData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVCHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCommitTop;
@end

@implementation ModifyPhoneNumSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _viewContentWidth.constant = kScreenWidth;
    _viewContentHeight.constant = kScreenHeight-64;
    //隐藏图形验证码view
    _constraintVCHeight.constant = 0;
    _constraintCommitTop.constant = 0;
    
    countTimer = 60;
    
    _textfieldMobile.tag = 20;
    _textfieldVcode.tag = 21;
    [self.textfieldMobile addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textfieldVcode addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _buttonSupply.userInteractionEnabled = NO;
    _labelVcode.userInteractionEnabled = NO;
    [_labelVcode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVcodeRequest)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *监听输入
 */
- (void)textDidChanged:(UITextField*)Textfield{
    
    if (Textfield.tag == 20) {
        if (Textfield.text.length>11) {
            _textfieldMobile.text = [Textfield.text substringToIndex:11];
        }
        //倒计时的时候忽略
        if (countTimer == 60) {
            if (_textfieldMobile.text.length == 11) {
                _labelVcode.textColor = RGB(96, 25, 134);
                _labelVcode.userInteractionEnabled = YES;
            }else{
                _labelVcode.textColor = [UIColor lightGrayColor];
                _labelVcode.userInteractionEnabled = NO;
            }
        }
        
    } else if (Textfield.tag == 21){
        
        if (Textfield.text.length>6) {
            _textfieldVcode.text = [Textfield.text substringToIndex:6];
        }
        
    } else if (Textfield.tag == 22){
        if (Textfield.text.length != 0) {
            _labelImageVcode.hidden = NO;
            
            if (Textfield.text.length == 4) {
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
    
    //判断手机号和当前的是否一致 判断验证码是否正确
    
    if (_textfieldMobile.text.length == 11 && _textfieldVcode.text.length == 6) {
        [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonSupply.layer.opacity = 1;
        _buttonSupply.userInteractionEnabled = YES;
    }else{
        [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonSupply.layer.opacity = 0.5;
        _buttonSupply.userInteractionEnabled = NO;
    }
}

#pragma mark - Request

//获取手机验证码
- (void)getVcodeRequest{
    
    if (self.imgData && _constraintVCHeight.constant == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _constraintVCHeight.constant = 60;
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
                                          [_buttonImageVcode setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                                          
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
- (void)confirmChangeBindPhoneRequest{
/*
 {"access_token": "NgDXJv3Ua9au/c11oXvCZ29WyyL81GvWqP3OdKhxxnJ8DoAm6dRrxa33z2KpZsRlfADfaarCNdakpJouqnGQLywQwC2hwDSG+fDOeKsszXsoF5Ir","phone": "18969125545","code":"671937","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_textfieldMobile.text,@"phone",_textfieldVcode.text,@"code", nil];
    [ChangeBindPhoneRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ChangeBindPhoneRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"修改成功" duration:1 position:CSToastPositionCenter];
            //pop到主界面
            NSArray *temArray = self.navigationController.viewControllers;
            for(UIViewController *temVC in temArray)
            {
                if ([temVC isKindOfClass:[JZMainTabController class]])
                {
                    [self.navigationController popToViewController:temVC animated:YES];
                }
            }
         } else {
            [self.view makeToast:@"修改失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
    } onRequestFailed:^(CIWBaseDataRequest *request) {
    }];
}

//验证手机是否绑定
- (void)checkPhoneIsBind {
    [CheckPhoneIsBindRequest requestWithParameters:@{@"phone":_textfieldMobile.text}
                                 withIndicatorView:self.view
                                    onRequestStart:^(CIWBaseDataRequest *request) {}
                                 onRequestFinished:^(CIWBaseDataRequest *request) {
                                     
                                     if([request.errCode isEqualToString:RESPONSE_OK]){
                                         
                                         NSNumber *data = [request.resultDic objectForKey:@"data"];
                                         
                                         if ([data isKindOfClass:[NSNumber class]] && [data boolValue] == NO) {
                                             [self confirmChangeBindPhoneRequest];

                                         } else {
                                             //已经绑定
                                             [MessageView displayMessageByErr:request.errCode];
                                         }
                                         
                                     } else {
                                         [MessageView displayMessageByErr:request.errCode];
                                     }
                                 }
     
                                 onRequestCanceled:^(CIWBaseDataRequest *request) {}
                                   onRequestFailed:^(CIWBaseDataRequest *request) {}];
    
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

#pragma mark buttonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
  *提交
  */
- (IBAction)supplyAction:(id)sender {
    [self checkPhoneIsBind];
}
@end
