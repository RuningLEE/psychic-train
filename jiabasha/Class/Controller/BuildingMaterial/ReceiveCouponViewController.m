//
//  ReceiveCouponViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import "ReceiveCouponViewController.h"

@interface ReceiveCouponViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnStoreWatch;  // 探店按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSignBill;    //  签单按钮

@property (weak, nonatomic) IBOutlet UIView *viewPhoneOne;
@property (weak, nonatomic) IBOutlet UIView *viewPhoneTwo;

@property (weak, nonatomic) IBOutlet UIButton *btnReceiveOne;
@property (weak, nonatomic) IBOutlet UIButton *btnReceiveTwo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone1;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCouponHeight;

@end

@implementation ReceiveCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     _textFieldPhone1.maxLength = 11;
    [self setUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //监听输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
    
}

- (void)setUi{
  
    self.btnStoreWatch.layer.cornerRadius = 2;
    self.btnStoreWatch.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnStoreWatch.layer.borderWidth = 0.7;
    
    self.btnSignBill.layer.cornerRadius = 2;
    self.btnSignBill.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnSignBill.layer.borderWidth = 0.7;
    
    self.viewPhoneOne.layer.cornerRadius = 3;
    self.viewPhoneOne.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewPhoneOne.layer.borderWidth = 0.7;
    
    self.viewPhoneTwo.layer.cornerRadius = 3;
    self.viewPhoneTwo.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewPhoneTwo.layer.borderWidth = 0.7;
    
    self.btnReceiveOne.layer.cornerRadius = 3;
    self.btnReceiveTwo.layer.cornerRadius = 3;
    //self.btnNext.userInteractionEnabled = NO;
    // [self.btnNext setBackgroundColor:RGB(189, 160, 204)];
    // [self.btnNext setBackgroundColor:RGB(96, 25, 134)];
    
    
    [self.btnStoreWatch setTitle:_couponName forState:UIControlStateNormal];
    self.labelTitle.text = [_dic[@"title"] description];
    NSString *ogiftSontent =  [_dic[@"desc"] description];
    if (ogiftSontent != nil) {
        CGSize contentSize = [ogiftSontent boundingRectWithSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:
                                                                      [UIFont systemFontOfSize:12]}
                                                        context:nil].size;
        _viewCouponHeight.constant =  contentSize.height + 153;
    }
    self.labelContent.text = ogiftSontent;
}

//  返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
  
    if (textField == _textFieldPhone1) {
        if ([CommonUtil isEmpty:_textFieldPhone1.text] || _textFieldPhone1.text.length != 11) {
            _btnReceiveOne.tag = 0;
            _btnReceiveOne.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnReceiveOne.tag = 1;
            _btnReceiveOne.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
}


@end
