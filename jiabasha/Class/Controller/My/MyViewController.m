//
//  MyViewController.m
//  JiaZhuang
//
//  Created by 金伟城 on 16/12/26.
//  Copyright © 2016年 hzdaoshun. All rights reserved.
//

#import "MyViewController.h"
#import "MineTableViewCell.h"
#import "PersonDataViewController.h"
#import "PureLayout.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "QRCodeView.h"
#import "SettingViewController.h"
#import "WaterWareView.h"
#import "MessageViewController.h"
#import "HelpCenterViewController.h"
#import "SubscribeViewController.h"
#import "MyOrderViewController.h"
#import "CashCouponViewController.h"
#import "DisplaySubscribeViewController.h"
#import "MyInvitation.h"
#import "MyClusterViewController.h"
#import "VIPViewController.h"
#import "CommonWebViewController.h"
#import "GetUserDataRequest.h"
#import "CallForCustomerViewController.h"
#import "GetContentRequest.h"
#import "MineAdTableViewCell.h"
#import "AdContent.h"
#import "iGetInvitationInfoRequest.h"
#import "QrInvitationViewController.h"
#import "InvitationDetailViewController.h"
#import "InvitationQrModel.h"
#import "InvitaionDetailModel.h"
#import "GetCouponListRequest.h"
#import "NoCashCouponViewController.h"
#import "WebViewController.h"

#import "ActivityAlterViewRequest.h"
#import "ActivityAlterView.h"

#import "Growing.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic  ) IBOutlet UITableView *TableviewMain;
@property (strong, nonatomic) IBOutlet UIView *ViewHeader;
@property (weak, nonatomic  ) IBOutlet UIImageView *ImageviewHead;
@property (weak, nonatomic  ) IBOutlet UIImageView *imageviewQrBg;
@property(nonatomic,strong  ) QRCodeView *viewQr;
@property(nonatomic,strong) ActivityAlterView *activityView;
@property (weak, nonatomic  ) IBOutlet UIImageView *imageviewTopBg;
@property (weak, nonatomic  ) IBOutlet UIView *viewVip;
@property (weak, nonatomic  ) IBOutlet UILabel *labelName;
@property (strong, nonatomic) YYLabel *labelunLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelNameTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewQr;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (strong, nonatomic) UIImage *qrImage;
@property (weak, nonatomic) IBOutlet UILabel *labelVipScore;
@property (weak, nonatomic) IBOutlet UIButton *imageMessageMark;
@property (strong, nonatomic) NSMutableArray *arrAd;
@property (weak, nonatomic) IBOutlet UIView *customerView;
@property (strong, nonatomic) NSString *isLoading;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelSign;
@property (assign, nonatomic) BOOL loadCoupon;
@property (assign, nonatomic) BOOL loadSignGift;
@property(nonatomic,strong)UIImage *alterImage;//活动弹框的图片
@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated
{
    
     self.growingAttributesPageName = @"myHome_ios";
    [super viewWillAppear:animated];
    //[self GetAcivityAlterView];
    _labelName.text = DATA_ENV.userInfo.user.uname;
    NSLog(@"%@",DATA_ENV.userInfo.user);
    //请求接口刷新数据 如果在登陆的情况下
    if ([_isLoading isEqualToString:@"NO"]) {
        if (![CommonUtil isEmpty:DATA_ENV.userInfo.user.uid]) {
            [self getMineData];
        }
    }
    if ([CommonUtil isEmpty:DATA_ENV.userInfo.user.uid]) {
        _ImageviewHead.image = [UIImage imageNamed:@"未登录头像-1"];
    }
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
    if (DATA_ENV.userInfo.user.uid) {    //登录
        _constraintLabelNameTop.constant = 76.5;
        _viewVip.hidden = NO;
        _imageviewQr.hidden = NO;
        _imageviewQrBg.hidden = NO;
        _labelName.hidden = NO;
        _labelunLogin.hidden = YES;
    } else {    //未登录
        _labelName.hidden = YES;
        _viewVip.hidden = YES;
        _imageviewQr.hidden = YES;
        _imageviewQrBg.hidden = YES;
        _labelunLogin.hidden = NO;
    }
    //初始化UI
    if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"new"]) {
        _labelVipScore.text = @"新会员 >";
    } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"old"]) {
        _labelVipScore.text = @"老会员 >";
    } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"vip"]) {
        _labelVipScore.text = @"Vip会员 >";
    } else {
        _labelVipScore.text = @"金卡会员 >";
    }
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelPhone.text = @"0571-28198188";
    } else {
        _labelPhone.text = @"4000-365-520";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetAcivityAlterView];
    //判断是否处于登录状态 如果是登录则显示vip会员 否则不显示
    //设置tableview
    [self setupTableView];

    [self initGestureTap];
    //初始化动画
    [self setUpWaterView];
    self.customerView.layer.cornerRadius = 5;
    self.customerView.layer.masksToBounds = YES;
    [self initUI];
    _isLoading = @"NO";
    _loadCoupon = NO;
    _loadSignGift = NO;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark //活动弹框

-(void)GetAcivityAlterView{
    NSDictionary *param;
    
      param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.userLevel,@"popup_target",@"my",@"popup_location", nil];
    [ActivityAlterViewRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ActivityAlterViewRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
    
      } onRequestFinished:^(CIWBaseDataRequest *request) {
    if ([request.errCode isEqualToString:RESPONSE_OK]) {
        NSLog(@"******==%@",request.resultDic);
        //_alterImage
        NSString *imageUrl=request.resultDic[@"data"][@"popup_pic_url"];
    NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        _alterImage=[UIImage imageWithData:data];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"myhome"]){
            [self showAlterView:_alterImage];
            
        }else{
            NSLog(@"bool");
        }

        
    } else {
       
        //[self.view makeToast:@"失败" duration:1 position:CSToastPositionCenter];
    }
} onRequestCanceled:^(CIWBaseDataRequest *request) {
    
} onRequestFailed:^(CIWBaseDataRequest *request) {
    
    [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
}];

}
#pragma mark 弹出活动框
-(void)showAlterView:(UIImage *)image{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"myhome"];
    if (_activityView == nil) {
        _activityView = [[ActivityAlterView alloc]init];
        
        _activityView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        __weak typeof(self)WeakSelf = self;
        [_activityView setClickBlock:^(Alterclicktype type) {
            switch (type) {
                case Aclick_blank:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                case Aclick_dismiss:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                default:
                    break;
            }
        }];
        
        [self.view addSubview:_activityView];
    }
    _activityView.QRimage = image;
    [_activityView show];
    
}

- (NSMutableArray *)arrAd
{
    if (_arrAd == nil) {
        _arrAd = [NSMutableArray array];
    }
    return _arrAd;
}

/**
 设置波浪view
 */
- (void)setUpWaterView{
    WaterWareView *viewFirst = [[WaterWareView alloc]init];
    [self.ViewHeader addSubview:viewFirst];
    [viewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageviewTopBg.mas_left);
        make.right.mas_equalTo(self.imageviewTopBg.mas_right);
        make.bottom.mas_equalTo(self.imageviewTopBg.mas_bottom);
        make.height.mas_equalTo(@25);
    }];
    WaterWareView * viewSecond = [[WaterWareView alloc]init];
    viewSecond.offsetX = self.view.bounds.size.width;
    [self.ViewHeader addSubview:viewSecond];
    [viewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageviewTopBg.mas_left);
        make.right.mas_equalTo(self.imageviewTopBg.mas_right);
        make.bottom.mas_equalTo(self.imageviewTopBg.mas_bottom);
        make.height.mas_equalTo(@25);
    }];
    _viewVip.layer.cornerRadius = 8;
    _viewVip.layer.masksToBounds = YES;
    _viewVip.backgroundColor = [UIColor whiteColor];
    _viewVip.alpha = 0.5;
}


/**
 设定tableview主视图
 */
- (void)setupTableView{
    _TableviewMain.delegate = self;
    _TableviewMain.dataSource = self;
    _ViewHeader.frame = CGRectMake(0, 0, kScreenWidth, 240);
    _TableviewMain.tableHeaderView = _ViewHeader;
    _TableviewMain.backgroundColor = RGB(246, 246, 246);
    _TableviewMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableviewMain.bounces = NO;
    _TableviewMain.showsVerticalScrollIndicator = NO;
}

- (void)createQrCodeWithStr:(NSString *)qrstr{
        // 1.创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2.恢复默认
        [filter setDefaults];
        // 3.给过滤器添加数据
        NSData *data = [qrstr dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        // 4.获取输出的二维码
        CIImage *outputImage = [filter outputImage];
        // 5.将CIImage转换成UIImage，并放大显示
        self.qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}

/*
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 初始化UI视图
 */
- (void)initUI{
    self.ImageviewHead.layer.borderColor = RGB(237, 219, 252).CGColor;
    self.ImageviewHead.layer.borderWidth = 2.5;
    self.ImageviewHead.layer.masksToBounds = YES;
    self.ImageviewHead.layer.cornerRadius = 30;
    
    NSMutableAttributedString* name = [[NSMutableAttributedString alloc]initWithString:@"登录 / 注册"];
    [name setYy_font:[UIFont systemFontOfSize:15]];
    [name setYy_color:[UIColor whiteColor]];
    [name yy_setTextHighlightRange:NSMakeRange(0, 3) color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        LoginViewController* loginController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginController animated:YES];
    }];
    
    [name yy_setTextHighlightRange:NSMakeRange(4, 3) color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        RegisterViewController* registerController = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:registerController animated:YES];
    }];
    
    //标题label布局
    _labelunLogin = [YYLabel new];
    _labelunLogin.font = [UIFont systemFontOfSize:15];
    _labelunLogin.textColor = [UIColor whiteColor];
    _labelunLogin.attributedText = name;
    _labelunLogin.frame = CGRectMake(80, 80, 60, 60);
    [self.ViewHeader addSubview:_labelunLogin];
    [_labelunLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ImageviewHead.mas_right).offset(10);
        make.centerY.mas_equalTo(_ImageviewHead.mas_centerY);
    }];
}

/**
 初始化手势
 */
- (void)initGestureTap{
    UITapGestureRecognizer* tap_persondata = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushPersondata)];
    [_ImageviewHead addGestureRecognizer:tap_persondata];
    tap_persondata.numberOfTapsRequired = 1;
    _ImageviewHead.userInteractionEnabled = YES;
    [_imageviewQrBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQrView)]];
    [_viewVip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelVipClicked)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 显示二维码imageView
 */
- (void)showQrView{
   
    if (DATA_ENV.isLogin) {
        if (_viewQr == nil) {
            _viewQr = [[QRCodeView alloc]init];
            
            _viewQr.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            __weak typeof(self)WeakSelf = self;
            [_viewQr setClickBlock:^(clicktype type) {
                switch (type) {
                    case click_blank:
                        [WeakSelf.viewQr dismiss];
                        WeakSelf.viewQr = nil;
                        break;
                    case click_dismiss:
                        [WeakSelf.viewQr dismiss];
                        WeakSelf.viewQr = nil;
                        break;
                    default:
                        break;
                }
            }];
            
            [self.view addSubview:_viewQr];
        }
        _viewQr.QRimage = self.qrImage;
        [_viewQr show];

    } else {
        [self showLoginViewController];
    }
}
#pragma mark - label click

/**
 VIP点击事件
 */
- (void)labelVipClicked{
    VIPViewController *vipController = [[VIPViewController alloc]init];
    [self.navigationController pushViewController:vipController animated:YES];
}

#pragma mark - buttonclick

/**
 取消通话
 */
- (IBAction)cancelCall:(id)sender {
    _viewNotify.hidden = YES;
}


/**
 通话Action
 */
- (IBAction)callMethod:(id)sender {
    if (![CommonUtil isEmpty:_labelPhone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelPhone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
    _viewNotify.hidden = YES;
}


/**
 设置键被点击
 */
- (IBAction)buttonSettingClick:(id)sender {
    SettingViewController* setting = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}


/**
 消息键被点击
 */
- (IBAction)buttonMessageClicked:(id)sender {
    if (DATA_ENV.isLogin) {
        MessageViewController* messageController = [[MessageViewController alloc]init];
        [self.navigationController pushViewController:messageController animated:YES];
    } else {
        [self showLoginViewController];
    }
}

/**
 点击家博会预约
 */
- (IBAction)subscribeClicked:(id)sender {
    if (DATA_ENV.isLogin) {
        DisplaySubscribeViewController *displaySubscribe = [[DisplaySubscribeViewController alloc]init];
        [self.navigationController pushViewController:displaySubscribe animated:YES];
    } else {
        [self showLoginViewController];
    }
}

/**
 点击我的签到礼
 */
- (IBAction)signGiftClicked:(id)sender {
    NSLog(@"%@",self.view.subviews);
    for (UIView *subview in self.view.subviews) {
        if (subview.height == 39.5) {
            return;
        }
    }
    if (DATA_ENV.isLogin) {
        WebViewController *webVC = [[WebViewController alloc]init];
        if (![CommonUtil isEmpty:DATA_ENV.userInfo.user.signInText]) {
            webVC.urlTitle = DATA_ENV.userInfo.user.signInText;
        } else {
            webVC.urlTitle = @"我的签到礼";
        }
        if (![CommonUtil isEmpty:DATA_ENV.userInfo.user.signInUrl]) {
            webVC.urlString = DATA_ENV.userInfo.user.signInUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            [self.view makeToast:@"暂无链接开通" duration:1 position:CSToastPositionCenter];
        }
    } else {
        [self showLoginViewController];
    }
}


/**
 点击我的邀请函
 */
- (IBAction)introduceClicked:(id)sender {
    if (DATA_ENV.isLogin) {
        [self getInvitationRequest];
    } else {
        [self showLoginViewController];
    }
}

/**
 点击我要索票
 */
- (IBAction)askTicketClicked:(id)sender {
    CommonWebViewController *webController = [[CommonWebViewController alloc]init];
    webController.sourceType = 2;
    [self.navigationController pushViewController:webController animated:YES];
}
- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma mark imageview-clickMethod
/**
 跳转至个人资料
 */
- (void)pushPersondata{
    if (DATA_ENV.isLogin) {
        PersonDataViewController * persondata = [[PersonDataViewController alloc]init];
        [self.navigationController pushViewController:persondata animated:YES];
    } else {
        [self showLoginViewController];
    }
}

#pragma mark TableView-Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrAd.count) {
        return 8;
    } else {
        return 7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrAd.count) {
        if (indexPath.row == 4) {
            return 10;
        } else if (indexPath.row == 7){
            return 85;
        } else {
            return 50;
        }

    } else {
        if (indexPath.row == 4) {
            return 10;
        } else {
            return 50;
        }
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrAd.count) {
        if (indexPath.row == 7) {
            AdContent *adModel = (AdContent *)[self.arrAd firstObject];
            MineAdTableViewCell * cellImage = [tableView dequeueReusableCellWithIdentifier:@"cellImage"];
            if (cellImage == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"MineAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellImage"];
                cellImage = [tableView dequeueReusableCellWithIdentifier:@"cellImage"];
            }
            cellImage.selectionStyle = UITableViewCellSelectionStyleNone;
            [cellImage.imageViewContent sd_setImageWithURL:[NSURL URLWithString:adModel.contentPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
            return cellImage;
        }
    }
        MineTableViewCell * cellmine = [tableView dequeueReusableCellWithIdentifier:@"cellmine"];
        if (cellmine == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellmine"];
            cellmine = [tableView dequeueReusableCellWithIdentifier:@"cellmine"];
        }
        if (indexPath.row == 0) {
            cellmine.labelTitle.text = @"我的预约";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"我的_预约"];
            cellmine.labeldetail.hidden = YES;
        } else if (indexPath.row == 1){
            cellmine.labelTitle.text = @"我的订单";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"我的_订单"];
            cellmine.labeldetail.hidden = YES;
        } else if (indexPath.row == 2){
            cellmine.labelTitle.text = @"我的现金券";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"我的现金券"];
            cellmine.labeldetail.hidden = YES;
        } else if (indexPath.row == 3){
            cellmine.labelTitle.text = @"我的拼团";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"我的拼团"];
            cellmine.labeldetail.hidden = YES;
        } else if (indexPath.row == 4){
            cellmine.hidden = YES;//index为5显示空白
        } else if (indexPath.row == 5){
            cellmine.labelTitle.text = @"帮助中心";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"帮助中心"];
            cellmine.labeldetail.hidden = YES;
        } else if (indexPath.row == 6){
            cellmine.labelTitle.text = @"联系客服";
            cellmine.imageviewHead.image = [UIImage imageNamed:@"联系客服"];
            cellmine.labeldetail.hidden = NO;
        }
        cellmine.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellmine;
}

#pragma mark TableView--Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (DATA_ENV.isLogin) {
            SubscribeViewController *subcribeController = [[SubscribeViewController alloc]init];
            [self.navigationController pushViewController:subcribeController animated:YES];
        } else {
            [self showLoginViewController];
        }
    } else if (indexPath.row == 1) {
        if (DATA_ENV.isLogin) {
            MyOrderViewController *orderController = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:orderController animated:YES];        } else {
            [self showLoginViewController];
        }
    } else if (indexPath.row == 2) {
        if (DATA_ENV.isLogin) {
            //请求现金券接口看是否有数据 如果有数据跳到现金券列表界面 如果没有跳转到没有现金券的提示界面
            if (_loadCoupon == YES) {
                return;
            } else {
                [self getCouponListRequest];
            }
        } else {
            [self showLoginViewController];
        }
    } else if (indexPath.row == 3) {
        if (DATA_ENV.isLogin) {
            MyClusterViewController *clusterController = [[MyClusterViewController alloc]init];
            [self.navigationController pushViewController:clusterController animated:YES];
        } else {
            [self showLoginViewController];
        }
    } else if (indexPath.row == 5) {
        HelpCenterViewController *helpController = [[HelpCenterViewController alloc]init];
        [self.navigationController pushViewController:helpController animated:YES];
    } else if (indexPath.row == 6) {
        _viewNotify.hidden = NO;
    }
}

#pragma mark - Request

/**
 在进入我的界面时候进行重新取数据以便及时刷新该页面的数据
 */
- (void)getMineData{
    _isLoading = @"YES";
//"uid": "12659722","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid", nil];
    [GetUserDataRequest requestWithParameters:param withIsCacheData:YES withIndicatorView:self.view withCancelSubject:[GetUserDataRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        NSLog(@"%@",request.resultDic);
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            _isLoading = @"NO";
            [CommonUtil replaceUserInfoWithUser:request.resultDic];
            if (![CommonUtil isEmpty:DATA_ENV.userInfo.user.signInText]) {
                _labelSign.text = DATA_ENV.userInfo.user.signInText;
            } else {
                _labelSign.text = @"我的签到礼";
            }
            [self createQrCodeWithStr:DATA_ENV.userInfo.user.qrcodeImg];
            NSLog(@"%@",DATA_ENV.userInfo);
            _labelName.text = DATA_ENV.userInfo.user.uname;
            [_ImageviewHead sd_setImageWithURL:[NSURL URLWithString:DATA_ENV.userInfo.user.faceUrl] placeholderImage:[UIImage imageNamed:@"未登录头像-1"]];
            if ([CommonUtil isEmpty:DATA_ENV.userInfo.user.unreadMessageCnt]) {
                [_imageMessageMark setImage:[UIImage imageNamed:@"no_has_message_icon"] forState:UIControlStateNormal];
            } else {
                [_imageMessageMark setImage:[UIImage imageNamed:@"有消息提示"] forState:UIControlStateNormal];
            }
            //请求广告底部接口
            [self getAdRequest];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
    } onRequestFailed:^(CIWBaseDataRequest *request) {
    }];
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
                                   if (weakSelf.arrAd.count) {
                                       [weakSelf.TableviewMain reloadData];
                                   }
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];

}

//我的邀请函
- (void)getInvitationRequest{
    /*
     "access_token": "NgDXJv3Ua8Wq9MF5r3nMaWEAyz+7zHPWrvLWfLd42npvDoA78Js0xab0zHSufsx9fhqWMr/CYNGtoZkurXnCKilBkS2uwmjeqvCae/p5zH0sGsF8oQ==","city_id":"330100","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    [iGetInvitationInfoRequest requestWithParameters:nil withCacheType:0 withIndicatorView:self.view withCancelSubject:[iGetInvitationInfoRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        NSLog(@"********==%@",request.resultDic);
        //判断用户有没有绑定手机号 绑定手机号的直接进入 如果没有绑定手机号则进入绑定手机界面
        if ([CommonUtil isEmpty:DATA_ENV.userInfo.user.phone]) {
            MyInvitation *invitation = [[MyInvitation alloc]init];
            invitation.sourceType = @"1";
            [self.navigationController pushViewController:invitation animated:YES];
        } else {
            if ([request.resultDic[@"err"] isEqualToString:@"err.expo.notfound"]) {
                    [self.view makeToast:@"当前城市暂无家博会信息" duration:1 position:CSToastPositionCenter];
            } else if([request.resultDic[@"err"] isEqualToString:@"err.expo.ticket.notfound"]){
                MyInvitation *invitation = [[MyInvitation alloc]init];
                invitation.sourceType = @"2";
                invitation.desc = [NSString stringWithFormat:@"        %@",[request.resultDic objectForKey:@"data"]];
                [self.navigationController pushViewController:invitation animated:YES];
            } else if ([request.errCode isEqualToString:RESPONSE_OK]){
                if ([[[[request.resultDic objectForKey:@"data"] objectForKey:@"type"] description] isEqualToString:@"1"]) {
                    InvitationDetailViewController *detail = [[InvitationDetailViewController alloc]init];
                    detail.qrModel = (InvitationQrModel *)[request.resultDic objectForKey:@"qrModel"];
                    detail.arrDetailModel = [request.resultDic objectForKey:@"arrDetailModel"];
                    [self.navigationController pushViewController:detail animated:YES];
                } else if([[[[request.resultDic objectForKey:@"data"] objectForKey:@"type"] description] isEqualToString:@"2"]){
                    InvitationDetailViewController *detail = [[InvitationDetailViewController alloc]init];
                    detail.qrModel = (InvitationQrModel *)[request.resultDic objectForKey:@"qrModel"];
                    detail.arrDetailModel = [request.resultDic objectForKey:@"arrDetailModel"];
                    [self.navigationController pushViewController:detail animated:YES];
                } else {
                    QrInvitationViewController *qrVC = [[QrInvitationViewController alloc]init];
                    qrVC.qrModel = (InvitationQrModel *)[request.resultDic objectForKey:@"qrModel"];
                    [self.navigationController pushViewController:qrVC animated:YES];
                }
            }
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

- (void)getCouponListRequest{
    _loadCoupon = YES;
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"invalid",PAGESIZE,@"size",@"0",@"page",nil];
    [GetCouponListRequest requestWithParameters:param withIsCacheData:NO withIndicatorView:nil withCancelSubject:[GetCouponListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            _loadCoupon = NO;
            //取总数量
            if ([CommonUtil isEmpty:[[request.resultDic objectForKey:@"data"] objectForKey:@"total"]] || [[[[request.resultDic objectForKey:@"data"] objectForKey:@"total"] description] isEqualToString:@"0"]) {
                NoCashCouponViewController *noCashCouponVC = [[NoCashCouponViewController alloc]init];
                [weakSelf.navigationController pushViewController:noCashCouponVC animated:YES];
            } else {
                CashCouponViewController *cashVC = [[CashCouponViewController alloc]init];
                [weakSelf.navigationController pushViewController:cashVC animated:YES];
            }
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
          _loadCoupon = NO;
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

- (void)showLoginViewController{
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
