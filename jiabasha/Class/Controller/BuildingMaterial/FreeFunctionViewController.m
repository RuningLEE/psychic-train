//
//  FreeFunctionViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "AddKeziRequest.h"
#import "BuildingStoreDetail.h"
#import "UITextField+MaxLength.h"
#import "RoomOfficeTableViewCell.h"
#import "CheckPhoneIsBindRequest.h"
#import "GetStoreAddReserveRequest.h"
#import "PlaceholderColorTextField.h"
#import "FreeFunctionViewController.h"
#import "SendPhoneCodeRequest.h"
#import "CheckPhoneCodeRequest.h"
#import "GetBuildingStoreDetailRequest.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface FreeFunctionViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnGray;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreNameOne;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreNameTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelSuccess;

/*  第一步 */
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnStoreWatch;  // 探店按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSignBill;    //  签单按钮
@property (weak, nonatomic) IBOutlet UIView *viewOne;

/* 第二步 */
@property (weak, nonatomic) IBOutlet UIButton *btnStoreWatchTwo;  // 探店按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSignBillTwo;    //  签单按钮
@property (weak, nonatomic) IBOutlet UIView *viewRoom;      // 室
@property (weak, nonatomic) IBOutlet UILabel *LabelRoomNum; // 几室
@property (weak, nonatomic) IBOutlet UIView *viewChamber;   // 厅
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeNum; // 几厅
@property (weak, nonatomic) IBOutlet UIView *viewKitchen;   // 厨
@property (weak, nonatomic) IBOutlet UILabel *labelKitchenNum;
// 几厨
@property (weak, nonatomic) IBOutlet UIView *viewHygiene;   // 卫
@property (weak, nonatomic) IBOutlet UILabel *labelWeiNum; // 几卫

@property (weak, nonatomic) IBOutlet UIView *viewVillage;   // 小区
@property (weak, nonatomic) IBOutlet UITextField *textFieldVillage;
@property (weak, nonatomic) IBOutlet UIView *viewArea;      // 面积
@property (weak, nonatomic) IBOutlet UITextField *textFieldArea;
@property (weak, nonatomic) IBOutlet UIButton *btnFreeAppiont;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;

// 验证码view
@property (strong, nonatomic) IBOutlet UIView *viewCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (weak, nonatomic) IBOutlet UILabel *labelCheckCode;
@property (weak, nonatomic) IBOutlet UIView *viewCodeImg;
@property (weak, nonatomic) IBOutlet PlaceholderColorTextField *textFieldCodeImg;
@property (weak, nonatomic) IBOutlet UIButton *btnCodeImg;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topForBtnCheckCode;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *backScrollerView;//bagview

//倒计时用timer
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger waitCount;

@property (nonatomic, assign) NSInteger getCodeNum;
@property (nonatomic, copy) NSString *imgData;
@property (nonatomic, copy) NSString *phonenumber; //已经发送验证码的手机

// 探店礼 ，签单礼
@property (weak, nonatomic) IBOutlet UIView *viewGiftOne;
@property (weak, nonatomic) IBOutlet UIView *viewLookGiftOne;
@property (weak, nonatomic) IBOutlet UILabel *labelLookTitleOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLookGiftOneHeight;

@property (weak, nonatomic) IBOutlet UIView *viewSignGiftOne;
@property (weak, nonatomic) IBOutlet UILabel *labelSignTitleOne;

@property (weak, nonatomic) IBOutlet UIView *viewGiftTwo;
@property (weak, nonatomic) IBOutlet UIView *viewLookGiftTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelLookTitleTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLookGiftTwoHeight;

@property (weak, nonatomic) IBOutlet UIView *viewSignGiftTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelSignTitleTwo;

// 提交预约成功
@property (strong, nonatomic) IBOutlet UIView *viewCommitSuccuss;
@property (weak, nonatomic) IBOutlet UIView *viewCommitSuccussCenter;

@property (assign ,nonatomic) NSInteger selectType;    // 0:室 1:厅 2:厨 3:卫
@property (assign ,nonatomic) NSInteger roomNum;    // 多少室
@property (assign ,nonatomic) NSInteger officeNum;  // 多少厅
@property (assign ,nonatomic) NSInteger kitchenNum; // 多少厨
@property (assign ,nonatomic) NSInteger weiNum;     // 多少卫

@property (strong, nonatomic) BuildingStoreDetail *buildingStoreDetail;
@property (strong, nonatomic) IBOutlet UIView *ThirdView;//预约到家博会 预约到门店
@property (weak, nonatomic) IBOutlet UIButton *Jiabohui;//100
@property (weak, nonatomic) IBOutlet UIButton *Mendian;//101
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalButton;
@property (weak, nonatomic) IBOutlet UILabel *ThirdLabel;
@property (weak, nonatomic) IBOutlet UITextField *ThirdTextFieldone;
@property (weak, nonatomic) IBOutlet UITextField *ThirdTextFieldTwo;
@property (weak, nonatomic) IBOutlet UIView *ThireGiftone;
@property (weak, nonatomic) IBOutlet UIView *ThirdGiftTwo;

@end

@implementation FreeFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_labelConstraint.constant=
    // Do any additional setup after loading the view from its nib.
    _textFieldPhone.maxLength = 11;
    _textFieldCode.maxLength = 6;

    [self getBuildingStoreDetailData];
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
     [self.waitTimer invalidate];
  
}

- (void)setUi{
    [_Jiabohui addTarget:self action:@selector(JBClick:) forControlEvents:UIControlEventTouchUpInside];
    _Jiabohui.tag=100;
    _Jiabohui.selected=YES;
    _labelConstraint.constant=_Jiabohui.center.x;
    [_Mendian addTarget:self action:@selector(JBClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Jiabohui setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_Jiabohui setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateSelected];
    [_Mendian setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_Mendian setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateSelected];
    _Mendian.tag=101;
    [_totalButton setTitle:@"预约到家博会" forState:UIControlStateNormal];
    _lineLabel.backgroundColor=[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0];
    _labelConstraint.constant=-[UIScreen mainScreen].bounds.size.width/4;
  
    if (DATA_ENV.isLogin) {
        self.textFieldName.text = DATA_ENV.userInfo.user.uname;
        self.textFieldPhone.text =  DATA_ENV.userInfo.user.phone;
        
        _btnNext.tag = 1;
        _btnNext.userInteractionEnabled = YES;
        _btnNext.backgroundColor = [UIColor colorWithHexString:@"#601986"];
    }else{
        _btnNext.tag = 0;
        _btnNext.userInteractionEnabled = NO;
        _btnNext.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
    }
    self.labelStoreNameOne.text = [NSString stringWithFormat:@"当前预约商家：%@", _companyName ];
    self.labelStoreNameTwo.text = [NSString stringWithFormat:@"当前预约商家：%@", _companyName ];
    
    if ([_freeType integerValue] == 0) {
        self.labelTitle.text = _appiontType;
        [self.btnFreeAppiont setTitle:_appiontType forState:UIControlStateNormal];
    }else if ([_freeType integerValue] == 3 ){
        self.labelTitle.text = @"免费预约";
        [self.btnNext setTitle:@"免费预约" forState:UIControlStateNormal];
    
    }
    
    self.btnNext.layer.cornerRadius = 3;
    self.btnStoreWatch.layer.cornerRadius = 2;
    self.btnStoreWatch.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnStoreWatch.layer.borderWidth = 0.7;
    
    self.btnSignBill.layer.cornerRadius = 2;
    self.btnSignBill.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnSignBill.layer.borderWidth = 0.7;
    
    self.btnStoreWatchTwo.layer.cornerRadius = 2;
    self.btnStoreWatchTwo.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnStoreWatchTwo.layer.borderWidth = 0.7;
    
    self.btnSignBillTwo.layer.cornerRadius = 2;
    self.btnSignBillTwo.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnSignBillTwo.layer.borderWidth = 0.7;
    
    self.viewName.layer.cornerRadius = 3;
    self.viewName.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewName.layer.borderWidth = 0.7;
    
    self.viewPhone.layer.cornerRadius = 3;
    self.viewPhone.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewPhone.layer.borderWidth = 0.7;
    
    

    self.viewRoom.layer.cornerRadius = 3;
    self.viewRoom.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewRoom.layer.borderWidth = 0.7;
    
    self.viewChamber.layer.cornerRadius = 3;
    self.viewChamber.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewChamber.layer.borderWidth = 0.7;
    
    self.viewKitchen.layer.cornerRadius = 3;
    self.viewKitchen.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewKitchen.layer.borderWidth = 0.7;
    
    self.viewHygiene.layer.cornerRadius = 3;
    self.viewHygiene.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewHygiene.layer.borderWidth = 0.7;

    self.viewVillage.layer.cornerRadius = 3;
    self.viewVillage.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewVillage.layer.borderWidth = 0.7;
    
    self.viewArea.layer.cornerRadius = 3;
    self.viewArea.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.viewArea.layer.borderWidth = 0.7;
    
    self.btnFreeAppiont.layer.cornerRadius = 3;
    self.btnFreeAppiont.userInteractionEnabled = NO;
    [self.btnFreeAppiont setBackgroundColor:RGB(189, 160, 204)];
    self.viewCommitSuccussCenter.layer.cornerRadius = 4;
}

-(void)JBClick:(UIButton *)sender{
    UIButton *but=(UIButton *)[self.view viewWithTag:100];
    UIButton *but1=(UIButton *)[self.view viewWithTag:101];

    
        if(sender.tag==100){
            sender.selected=YES;
            but1.selected=NO;
            _labelConstraint.constant=-[UIScreen mainScreen].bounds.size.width/4;
            [_totalButton setTitle:@"预约到家博会" forState:UIControlStateNormal];
            
        }else if (sender.tag==101){
            sender.selected=YES;
            but.selected=NO;
            _labelConstraint.constant=[UIScreen mainScreen].bounds.size.width/4;
            [_totalButton setTitle:@"预约到门店" forState:UIControlStateNormal];
        }
    
   
   }


- (void)textFieldTextDidChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (textField == _textFieldName || textField == _textFieldPhone) {
        if ([CommonUtil isEmpty:_textFieldName.text] || _textFieldPhone.text.length != 11) {
            _btnNext.tag = 0;
            _btnNext.userInteractionEnabled = NO;
            _btnNext.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnNext.tag = 1;
             _btnNext.userInteractionEnabled = YES;
            _btnNext.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
    
    if (textField == _textFieldVillage || textField == _textFieldArea) {
        if ([CommonUtil isEmpty:_textFieldVillage.text] || [CommonUtil isEmpty:_textFieldArea.text]) {
            _btnFreeAppiont.tag = 0;
             _btnFreeAppiont.userInteractionEnabled = NO;
            _btnFreeAppiont.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnFreeAppiont.tag = 1;
            _btnFreeAppiont.userInteractionEnabled = YES;
            _btnFreeAppiont.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
    
    if (textField == _textFieldCode) {
        if ([CommonUtil isEmpty:_textFieldCode.text] ) {
            _btnCheckCode.tag = 0;
            _btnCheckCode.backgroundColor = [UIColor colorWithHexString:@"#601986" alpha:.5];
        } else {
            _btnCheckCode.tag = 1;
            _btnCheckCode.backgroundColor = [UIColor colorWithHexString:@"#601986"];
        }
    }
}




//重新发送验证码
- (IBAction)btnGetCodeClicked:(id)sender {
    [self sendPhoneCode];
}



//  返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 下一步
- (IBAction)btnClickNext:(id)sender {

    [self.view endEditing:YES];
  
    
    
    if (_btnNext.tag == 0) {
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
//
                                             } else {
                                                 
                                                 if ([_freeType integerValue] == 3 ){
                                                  
                                                        [self storeAppiontRequest];
                                                
                                                 }else{
                                                     //预约设计
                                                     _viewTwo.hidden = NO;
                                                 }
                                                
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
                                           
                                           if ([_freeType integerValue] == 3 ){
                                               [self getBuildingStoreDetailData];
                                               [self storeAppiontRequest];
                                           
                                               
                                           }else{
                                               //预约设计
                                               _viewTwo.hidden = NO;
                                               
                                           }
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


//关闭验证码画面
- (IBAction)btnCloseCodeView:(id)sender {
    _viewCode.hidden = YES;
    [self.view sendSubviewToBack:_viewCode];
}

// 显示申请成功
- (void)openSuccessViewForView {
    [self.view addSubview:_viewCommitSuccuss];
    _viewCommitSuccuss.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewCommitSuccuss.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)colseSuccessView:(id)sender {
    
    [self closeSuccessView];
    [self .navigationController popViewControllerAnimated:YES];
}

// 关闭申请成功iew
- (void)closeSuccessView {
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewCommitSuccuss.frame = CGRectMake(0, _viewCommitSuccuss.bounds.size.height, _viewCommitSuccuss.frame.size.width, _viewCommitSuccuss.frame.size.height);
    } completion:^(BOOL finished) {
        [_viewCommitSuccuss removeFromSuperview];
    }];
}

// 选择几室
- (IBAction)btnOpenSelectView:(UIButton *)sender {
     // 0:室 1:厅 2:厨 3:卫
    if(sender.tag == 0){
        self.selectType = 0;
    }else if (sender.tag == 1){
        self.selectType = 1;
    }else if (sender.tag == 2){
        self.selectType = 2;
    }else if (sender.tag == 3){
        self.selectType = 3;
    }
    
    [_tableView reloadData];
    self.btnGray.hidden = NO;
    [self.view addSubview:_tableView];
    _tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 176);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame =  CGRectMake(0, kScreenHeight-176, kScreenWidth, 176);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)closeShareBtn:(id)sender {
    [self closeSelectView];
}

- (void)closeSelectView {
    self.btnGray.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0,  kScreenHeight, kScreenWidth, 176);
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * roomOfficeTableViewCell = @"RoomOfficeTableViewCell";
    RoomOfficeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:roomOfficeTableViewCell];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"RoomOfficeTableViewCell" bundle:nil] forCellReuseIdentifier:roomOfficeTableViewCell];
        cell = [tableView dequeueReusableCellWithIdentifier:roomOfficeTableViewCell];
    }
    cell.backgroundColor = RGB(255, 255, 255);
    cell.labelName.textColor  = RGB(51, 51, 51);
    NSString *title;  // 0:室 1:厅 2:厨 3:卫
    if(self.selectType == 0){
       title = [NSString stringWithFormat:@"%ld室",indexPath.row + 1];
        if (indexPath.row == self.roomNum) {
            cell.backgroundColor = RGB(252, 245, 255);
            cell.labelName.textColor  = RGB(96, 25, 134);
        }
    }else if (self.selectType == 1){
        title = [NSString stringWithFormat:@"%ld厅",indexPath.row + 1];
        if (indexPath.row == self.officeNum) {
            cell.backgroundColor = RGB(252, 245, 255);
            cell.labelName.textColor  = RGB(96, 25, 134);
        }
    }else if (self.selectType == 2){
        title = [NSString stringWithFormat:@"%ld厨",indexPath.row + 1];
        if (indexPath.row == self.kitchenNum) {
            cell.backgroundColor = RGB(252, 245, 255);
            cell.labelName.textColor  = RGB(96, 25, 134);
        }
    }else if (self.selectType == 3){
        title = [NSString stringWithFormat:@"%ld卫",indexPath.row + 1];
        if (indexPath.row == self.weiNum) {
            cell.backgroundColor = RGB(252, 245, 255);
            cell.labelName.textColor  = RGB(96, 25, 134);
        }
    }
    cell.labelName.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 0:室 1:厅 2:厨 3:卫
    if(self.selectType == 0){
        self.roomNum = indexPath.row;
        self.LabelRoomNum.text = [NSString stringWithFormat:@"%ld室",indexPath.row + 1];
    }else if (self.selectType == 1){
        self.officeNum = indexPath.row;
        self.labelOfficeNum.text = [NSString stringWithFormat:@"%ld厅",indexPath.row + 1];
    }else if (self.selectType == 2){
        self.kitchenNum = indexPath.row;
        self.labelKitchenNum.text = [NSString stringWithFormat:@"%ld厨",indexPath.row + 1];
    }else if (self.selectType == 3){
        self.weiNum = indexPath.row;
        self.labelWeiNum.text = [NSString stringWithFormat:@"%ld卫",indexPath.row + 1];
    }
    [self closeSelectView];
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
    [_btnGetCode setTitle:@"60s" forState:UIControlStateDisabled];
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


//预约设计
- (IBAction)btnInspectionClicked:(id)sender {
    if (_btnFreeAppiont.tag == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 0:免费验房  1:免费量房 2:免费设计 3:免费预约
    if ([_freeType integerValue] == 0) {
        [params setObject:_appiontType forKey:@"kezi_type"];
    }else if ([_freeType integerValue] == 3){
        [params setObject:@"免费预约" forKey:@"kezi_type"];
    }
    [params setObject:@"2083" forKey:@"cate_id"];
    if([CommonUtil isEmpty:DATA_ENV.userInfo.user.uid]){
        [params setObject:@"" forKey:@"uid"];
    }else{
        [params setObject:DATA_ENV.userInfo.user.uid forKey:@"uid"];
    }

    [params setObject:_textFieldPhone.text forKey:@"phone"];
    [params setObject:_textFieldName.text forKey:@"uname"];
    [params setObject:_companyName forKey:@"store_name"];
    [params setObject:_textFieldVillage.text forKey:@"block"];
    [params setObject:_textFieldArea.text forKey:@"area"];
    NSString *house_type = [NSString stringWithFormat:@"%@%@%@%@", _LabelRoomNum.text, _labelOfficeNum.text, _labelKitchenNum.text, _labelWeiNum.text];
    house_type = [house_type stringByReplacingOccurrencesOfString:@" " withString:@""];
    [params setObject:house_type forKey:@"house_type"];
    
    //添加客资
    __weak typeof(self) weakSelf = self;
    [AddKeziRequest requestWithParameters:params
                        withIndicatorView:self.view
                           onRequestStart:^(CIWBaseDataRequest *request) {}
                        onRequestFinished:^(CIWBaseDataRequest *request) {
                            
                            if([request.errCode isEqualToString:RESPONSE_OK]){
                                
                                [weakSelf.self openSuccessViewForView];
                                
                            } else {
                                
                                [MessageView displayMessageByErr:request.errCode];
                            }
                        }
     
                        onRequestCanceled:^(CIWBaseDataRequest *request) {}
                          onRequestFailed:^(CIWBaseDataRequest *request) {}];
}


// 店铺预约
- (void)storeAppiontRequest {
    if (_btnNext.tag == 0) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // reserve_type 1:预约到店 2:预约到婚博会
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    [params setObject:@"1" forKey:@"reserve_type"];
    [params setObject:_textFieldPhone.text forKey:@"phone"];
    [params setObject:_textFieldName.text forKey:@"name"];
    [params setObject:_companyName forKey:@"store_name"];
    [params setObject:_buildingStoreDetail.cateId forKey:@"cate_id"];
    [params setObject:_storeId forKey:@"store_id"];
    [params setObject:timeString forKey:@"appoint_time"];

    //添加客资
    __weak typeof(self) weakSelf = self;
    [GetStoreAddReserveRequest requestWithParameters:params
                        withIndicatorView:self.view
                           onRequestStart:^(CIWBaseDataRequest *request) {}
                        onRequestFinished:^(CIWBaseDataRequest *request) {
                            
                            if([request.errCode isEqualToString:RESPONSE_OK]){
                                
                                [weakSelf.self openSuccessViewForView];
                                
                            } else {
                               
                               [MessageView displayMessageByErr:request.errCode];
                            }
                        }
     
                        onRequestCanceled:^(CIWBaseDataRequest *request) {}
                          onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

#pragma mark - private
- (void)countdown {
    self.waitCount--;
    if (_waitCount <= 0) {
        [_waitTimer invalidate];
        _waitTimer = nil;
        
        _btnGetCode.enabled = YES;
        [_btnGetCode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        
    } else {
        [_btnGetCode setTitle:[NSString stringWithFormat:@"%lds", self.waitCount] forState:UIControlStateDisabled];
    }
}


#pragma mark - private
// 建筑公司详细
- (void)getBuildingStoreDetailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
    __weak typeof(self) weakSelf = self;
    [GetBuildingStoreDetailRequest requestWithParameters:parameters
                                           withCacheType:DataCacheManagerCacheTypeMemory
                                       withIndicatorView:self.view
                                       withCancelSubject:[GetBuildingStoreDetailRequest getDefaultRequstName]
                                          onRequestStart:nil
                                       onRequestFinished:^(CIWBaseDataRequest *request) {
                                           
                                           if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                               
                                               NSArray * arrStoreData = [request.resultDic objectForKey:@"BuildingStoreDetail"];
                                               NSLog(@"*****==%@",request.resultDic);
                                               if (arrStoreData.count > 0) {
                                                 weakSelf.buildingStoreDetail = arrStoreData[0];
                                                   self.labelStoreNameOne.text = [NSString stringWithFormat:@"当前预约商家：%@",  weakSelf.buildingStoreDetail.storeName];
                                                   _ThirdLabel.text = [NSString stringWithFormat:@"当前预约商家：%@",  weakSelf.buildingStoreDetail.storeName];
                                                   _companyName = [NSString stringWithFormat:@"%@",weakSelf.buildingStoreDetail.storeName];
                                                   NSDictionary *dic=[NSDictionary dictionaryWithDictionary:request.resultDic];
                                                   NSString *strL=[NSString stringWithFormat:@"%@",dic[@"data"][@"store_setting"]];
                                                   NSString *strR=[NSString stringWithFormat:@"%@",dic[@"data"][@"expo_setting"]];
                                                   if([strL isEqualToString:@"1"]&&![[dic[@"data"] allKeys] containsObject:@"expo_setting"]){
                                                       
                                                   [self.btnNext setTitle:@"预约到门店" forState:UIControlStateNormal];
                                                   }else if ([strL isEqualToString:@"1"]&&[strR isEqualToString:@"0"]){
                                                       [self.btnNext setTitle:@"预约到门店" forState:UIControlStateNormal];
                                                   }else if ([strL isEqualToString:@"1"]&&[strR isEqualToString:@"1"]){
                                                       self.ThirdTextFieldone.text = DATA_ENV.userInfo.user.uname;
                                                       self.ThirdTextFieldTwo.text =  DATA_ENV.userInfo.user.phone;
                                                       _ThireGiftone.hidden=YES;
                                                       _ThirdGiftTwo.hidden=YES;
                                                       _ThirdView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
                                                       [_backScrollerView addSubview:_ThirdView];
                                                       
                                                   }else if ([dic[@"data"][@"store_setting"] isEqualToString:@"0"]&&[dic[@"data"][@"expo_setting"] isEqualToString:@"1"]){
                                                        [self.btnNext setTitle:@"预约到展会" forState:UIControlStateNormal];
                                                       
                                                   }

                                                   if ([_freeType integerValue] == 0) {
                                                       self.labelTitle.text = _appiontType;
                                                       if(_appiontType )
                                                           
                                                           if([_appiontType rangeOfString:@"验房"].location !=NSNotFound)
                                                           {
                                                               self.labelSuccess.text = @"「恭喜您预约成功，我们的家装顾问将在近期与您取得联系，与您预约验房档期。」";
                                                           }                                                           else if ([_appiontType rangeOfString:@"量房"].location !=NSNotFound)
                                                           {
                                                               self.labelSuccess.text = @"「恭喜您预约成功，我们的家装顾问将在近期与您取得联系，与您预约量房档期。」";
                                                           }else if ([_appiontType rangeOfString:@"设计"].location !=NSNotFound)
                                                           {
                                                               self.labelSuccess.text = @"「恭喜您预约成功，我们的家装顾问将在近期与您取得联系，为您推荐心仪的设计师。」";
                                                           }
                                                       
                                                   }else if ([_freeType integerValue] == 3 ){
                                                       self.labelSuccess.text = [NSString stringWithFormat:@"「恭喜您成功预约%@，我们的家装顾问将在近期与您取得联系。」",weakSelf.buildingStoreDetail.storeName];
                                                       
                                                   }
                                                   
                                                   [self setGift];
                                                
                                               }
                                      
                                           }
                                           
                                       }
                                       onRequestCanceled:^(CIWBaseDataRequest *request) {
                                           
                                       }
                                         onRequestFailed:^(CIWBaseDataRequest *request) {
                                             NSLog(@"66666666");
                                         }];
}


- (void)setGift{
    NSDictionary *agift = _buildingStoreDetail.agift;
    NSDictionary *ogift = _buildingStoreDetail.ogift;
    self.viewLookGiftOneHeight.constant = 19;
    self.viewLookGiftTwoHeight.constant = 19;
    if(agift[@"title"] == nil && ogift[@"title"]  == nil){
        self.viewGiftOne.hidden = YES;
        self.viewSignGiftOne.hidden = YES;
        self.viewGiftTwo.hidden = YES;
        self.viewSignGiftTwo.hidden = YES;
    }else if(agift[@"title"]  != nil && ogift[@"title"]  != nil){
        self.viewGiftOne.hidden = NO;
        self.viewSignGiftOne.hidden = NO;
        self.viewGiftTwo.hidden = NO;
        self.viewSignGiftTwo.hidden = NO;
        self.labelLookTitleOne.text =  [agift[@"title"] description];
        self.labelLookTitleTwo.text =  [agift[@"title"] description];
        self.labelSignTitleOne.text =  [ogift[@"title"] description];
        self.labelSignTitleTwo.text =  [ogift[@"title"] description];
    }else if(agift[@"title"]  != nil ){
        self.viewGiftOne.hidden = NO;
        self.viewSignGiftOne.hidden = YES;
        self.viewGiftTwo.hidden = NO;
        self.viewSignGiftTwo.hidden = YES;
        self.labelLookTitleOne.text =  [agift[@"title"] description];
        self.labelLookTitleTwo.text =  [agift[@"title"] description];;
    }else if(ogift[@"title"]  != nil ){
        self.viewGiftOne.hidden = YES;
        self.viewSignGiftOne.hidden = NO;
        self.viewGiftTwo.hidden = YES;
        self.viewSignGiftTwo.hidden = NO;
        self.viewLookGiftOneHeight.constant = 0;
        self.viewLookGiftTwoHeight.constant = 0;
        self.labelSignTitleOne.text =  [ogift[@"title"] description];
        self.labelSignTitleTwo.text =  [ogift[@"title"] description];
    }
    
}

@end
