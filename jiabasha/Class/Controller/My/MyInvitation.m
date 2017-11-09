//
//  MyInvitation.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyInvitation.h"
#import "ModifyMobilePhonNumViewController.h"
#import "Masonry.h"
#import "iGetInvitationInfoRequest.h"
#import "LoginViewController.h"
#import "CommonWebViewController.h"
#import "GetContentRequest.h"
#import "WebViewController.h"
@interface MyInvitation ()
/**
 *没有绑定手机号视图
 */
@property (strong, nonatomic) IBOutlet UIView *viewNoBindMobile;
@property (weak, nonatomic) IBOutlet UIButton *buttonBindMobile;
/**
 *绑定手机号没有邀请函视图
 */
@property (strong, nonatomic) IBOutlet UIView *viewNoInvitation;
@property (weak, nonatomic) IBOutlet UILabel *labelNoInvatiationDesc;
@property (weak, nonatomic) IBOutlet UIButton *buttonNIBindMobile;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuery;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeMobile;
/**
 *个人信息视图
 */
@property (strong, nonatomic) IBOutlet UIView *viewInfonation;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelVIP;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
/**
 *二维码视图
 */
@property (strong, nonatomic) IBOutlet UIView *viewQR;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewQR;
@property (weak, nonatomic) IBOutlet UILabel *labelEntrance;
/**
 *提醒视图
 */
@property (strong, nonatomic) IBOutlet UIView *viewWarnning;
@property (weak, nonatomic) IBOutlet UIView *viewNavi;
/**
 *主视图
 */
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConentWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewContentHeightConstant;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UIView *viewBG;

@property (strong, nonatomic) NSMutableArray *arrAd;
@end

@implementation MyInvitation
-(void)viewWillAppear:(BOOL)animated{
    [self getAdRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
    //获取邀请函信息
//    [self getInvitationRequest];
    // Do any additional setup after loading the view from its nib.
}
- (void)getAdRequest{
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":@"myhome_help_bottom_1080x375"}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:nil
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   //刷新数据
                                   NSLog(@"%@",request.resultDic);
                                   weakSelf.arrAd = [request.resultDic objectForKey:@"AdContent"];
                                                                 }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];
    
}
- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)setUp{
    _viewContentHeightConstant.constant = kScreenHeight-64;
    _viewConentWidthConstant.constant = kScreenWidth;
    
    _buttonBindMobile.layer.cornerRadius = 3;
    _buttonBindMobile.layer.masksToBounds = YES;
    _buttonNIBindMobile.layer.cornerRadius = 3;
    _buttonNIBindMobile.layer.masksToBounds = YES;
    _buttonQuery.layer.cornerRadius = 3;
    _buttonQuery.layer.masksToBounds = YES;
    _buttonChangeMobile.layer.cornerRadius = 3;
    _buttonChangeMobile.layer.masksToBounds = YES;
    _buttonChangeMobile.layer.borderColor = RGB(51, 51, 51).CGColor;
    _buttonChangeMobile.layer.borderWidth = 1;
    //判断绑定手机和个人信息的情况然后布局视图  此处先布局没有绑定手机号
    if ([_sourceType isEqualToString:@"1"]) {
        [_viewContent addSubview:_viewNoBindMobile];
        [_viewNoBindMobile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_viewNavi.mas_bottom);
            make.left.mas_equalTo(_viewContent.mas_left);
            make.right.mas_equalTo(_viewContent.mas_right);
            make.bottom.mas_equalTo(_viewContent.mas_bottom);
        }];
    } else if ([_sourceType isEqualToString:@"2"]){
        [_viewContent addSubview:_viewNoInvitation];
        [_viewNoInvitation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_viewNavi.mas_bottom);
            make.left.mas_equalTo(_viewContent.mas_left);
            make.right.mas_equalTo(_viewContent.mas_right);
            make.bottom.mas_equalTo(_viewContent.mas_bottom);
        }];
        _labelNoInvatiationDesc.text = _desc;
    }
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
    _viewBG.layer.cornerRadius = 5;
    _viewBG.layer.masksToBounds = YES;
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelPhone.text = @"0571-28198188";
    } else {
        _labelPhone.text = @"4000-365-520";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelCallMethod:(id)sender {
    _viewNotify.hidden = YES;
}

- (IBAction)callMethod:(id)sender {
    if (![CommonUtil isEmpty:_labelPhone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelPhone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
    _viewNotify.hidden = YES;
}

//点击绑定手机号
- (IBAction)buttonBindMobileClicked:(id)sender {
    ModifyMobilePhonNumViewController *bindController = [[ModifyMobilePhonNumViewController alloc]init];
    [self.navigationController pushViewController:bindController animated:YES];
}

//点击立即索票
- (IBAction)butttonNoInvitationBindClicked:(id)sender {
   
    if(_arrAd.count==0){
        [self.view makeToast:@"获取索票页失败"];
       
    }else{
    [self openWebView:_arrAd[0][@"content_url"]];
    }
//    CommonWebViewController *webController = [[CommonWebViewController alloc]init];
//    webController.sourceType = 2;
//    [self.navigationController pushViewController:webController animated:YES];
}

//点击电话查询按钮
- (IBAction)buttonQueryClicked:(id)sender {
    _viewNotify.hidden = NO;
}

//点击更换手机号
- (IBAction)buttonChangeMobileClicked:(id)sender {
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

//在warnning界面点击退出按钮
- (IBAction)hideWarnningView:(id)sender {
    _viewWarnning.hidden = YES;
}

//点击绑定手机号
- (IBAction)bindMobileAction:(id)sender {
}

#pragma mark - Request

- (void)getInvitationRequest{
    /*
     "access_token": "NgDXJv3Ua8Wq9MF5r3nMaWEAyz+7zHPWrvLWfLd42npvDoA78Js0xab0zHSufsx9fhqWMr/CYNGtoZkurXnCKilBkS2uwmjeqvCae/p5zH0sGsF8oQ==","city_id":"330100","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    [iGetInvitationInfoRequest requestWithParameters:nil withCacheType:0 withIndicatorView:self.view withCancelSubject:[iGetInvitationInfoRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

@end
