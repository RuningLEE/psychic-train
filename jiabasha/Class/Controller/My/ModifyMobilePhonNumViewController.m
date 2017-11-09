//
//  ModifyMobilePhonNumViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ModifyMobilePhonNumViewController.h"

@interface ModifyMobilePhonNumViewController ()<UITextFieldDelegate>{
    NSInteger countTimer;
    NSTimer *timermy;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *textfieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *textfieldVcode;
@property (weak, nonatomic) IBOutlet UILabel *labelVcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonsupply;
@end

@implementation ModifyMobilePhonNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGesture];
    _textfieldMobile.tag = 99;
    _textfieldVcode.tag = 100;
    self.textfieldMobile.delegate = self;
    self.textfieldVcode.delegate = self;
    //添加监听内容输入
    [_textfieldMobile addTarget:self action:@selector(ModifyPhoneNumtextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldVcode addTarget:self action:@selector(ModifyPhoneNumtextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    countTimer = 60;
    _buttonsupply.userInteractionEnabled = NO;
    _labelVcode.userInteractionEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)recoverKeyboard{
    [self.textfieldMobile resignFirstResponder];
    [self.textfieldVcode resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [timermy invalidate];
    timermy = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGesture{
    //验证码手势
    UITapGestureRecognizer* tap_vcode = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getVcodeMethod)];
    tap_vcode.numberOfTapsRequired = 1;
    [self.labelVcode addGestureRecognizer:tap_vcode];
    //撤销键盘手势
    UITapGestureRecognizer* recover_gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverKeyboard)];
    recover_gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recover_gesture];
}

//当textfield.text改变的时候调用
- (void)ModifyPhoneNumtextFieldChanged:(UITextField *)textField {
    if (textField.tag == 99) {//电话
        if (textField.text.length > 11) {
            _textfieldMobile.text = [textField.text substringToIndex:11];
        }
        if (_textfieldMobile.text.length == 11) {
            _labelVcode.textColor = RGB(96, 25, 134);
            if (countTimer == 60) {
                _labelVcode.userInteractionEnabled = YES;
            }else{
                _labelVcode.userInteractionEnabled = NO;
            }
        } else {
            _labelVcode.textColor = [UIColor lightGrayColor];
            _labelVcode.userInteractionEnabled = NO;
        }
    } else {//验证码
        if (textField.text.length>6) {
            _textfieldVcode.text = [textField.text substringToIndex:6];
        }
    }
    if (_textfieldVcode.text.length == 6 && _textfieldMobile.text.length == 11) {
        [_buttonsupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonsupply.layer.opacity = 1;
        _buttonsupply.userInteractionEnabled = YES;
    }else{
        [_buttonsupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonsupply.layer.opacity = 0.5;
        _buttonsupply.userInteractionEnabled = NO;
    }
}

#pragma mark label-clickaction
- (void)getVcodeMethod{
    __weak typeof(self) Weakself = self;
     _labelVcode.userInteractionEnabled = NO;
    timermy = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (countTimer) {
            countTimer--;
            Weakself.labelVcode.text = [NSString stringWithFormat:@"%ds",countTimer];
            _labelVcode.textColor = [UIColor lightGrayColor];
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


#pragma mark button-clickmethod
- (IBAction)Goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**s
 *点击提交
 */
- (IBAction)supplyAction:(id)sender {
    [_textfieldVcode resignFirstResponder];
    [_textfieldMobile resignFirstResponder];
    [self.view makeToast:@"提交成功"];
}

@end
