//
//  RenovationShopDetialViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "AdContent.h"
#import "GetContentRequest.h"
#import "GoodsDetail.h"
#import "ProductDetail.h"
#import "LCBannerView.h"
#import "UIColor-Expanded.h"
#import "ShareViewController.h"
#import "CompanyCommentCell.h"
#import "WebViewController.h"
#import "DecorationPackageCell.h"
#import "CouponDetailViewController.h"
#import "AllPackageViewController.h"
#import "FreeFunctionViewController.h"
#import "GetRenovationShopDetialRequest.h"
#import "RenovationCompanyHomeViewController.h"
#import "RenovationShopDetialViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

#define product_detail_1080x1920 @"product_detail_1080x1920"  //商城-大家电-通栏-（导航下方）

@interface RenovationShopDetialViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LCBannerViewDelegate,MFMailComposeViewControllerDelegate, TencentSessionDelegate>

{
    UIView * viewFooter;
    UIView * viewHeader;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewIntroduce; // 介绍
@property (weak, nonatomic) IBOutlet UIView *viewBanner;
@property (strong, nonatomic) IBOutlet UIView *viewCoupon;  // 优惠券
@property (strong, nonatomic) IBOutlet UIView *viewCompany; // 公司
@property (strong, nonatomic) IBOutlet UIView *viewShowSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscount; // 优惠按钮
@property (weak, nonatomic) IBOutlet UILabel *labelNumPeopleAppiont;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName; // 商品名字
@property (weak, nonatomic) IBOutlet UILabel *labelMallPrice; // 现价
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelMallPriceWidth;

@property (weak, nonatomic) IBOutlet UILabel *labelOriginalPrice; // 原价
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOriginalWidth;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewStore; // 商家logo
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;  //  商家名称
@property (weak, nonatomic) IBOutlet UILabel *labelStoreAppiontPeopleNum; // 商家预约人数

// 优惠券  "exchange_type" : "0" 优惠券金额类型 0会员等级,1固定金额,2消费金额
@property (weak, nonatomic) IBOutlet UIView *viewNoLoginFourCoupon; // 没有登录显示的优惠券
@property (weak, nonatomic) IBOutlet UIView *viewLoginOneCoupon; // 登录显示对应的优惠券
@property (weak, nonatomic) IBOutlet UILabel *labelLoginShowCouponContent;
@property (weak, nonatomic) IBOutlet UIButton *btnReceiveCoupon;
@property (weak, nonatomic) IBOutlet UIView *viewStaticMoneyCoupon; // 固定金额优惠券，不区分会员级别
@property (weak, nonatomic) IBOutlet UILabel *labelStaticMoneyCoupon;

@property (weak, nonatomic) IBOutlet UIView *viewConsumptionAmountCoupon; // 消费金额优惠券
@property (weak, nonatomic) IBOutlet UIView *viewDepositConsumCoupon;
// 促销广告
@property (weak, nonatomic) IBOutlet UIView *viewPromotionalAd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewPromotionalAdHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelAdContent;

 // 详情 参数 推荐
@property (strong, nonatomic) IBOutlet UIView *viewDetial; //  详情
@property (strong, nonatomic) IBOutlet UIView *viewParameter; // 参数
@property (weak, nonatomic) IBOutlet UIView *viewParameterSub; // 参数动态view
@property (weak, nonatomic) IBOutlet UIWebView *webViewDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnDetial;
@property (weak, nonatomic) IBOutlet UIView *viewDetialLine;
@property (weak, nonatomic) IBOutlet UIButton *btnParameter;
@property (weak, nonatomic) IBOutlet UIView *viewParameterLine;
@property (weak, nonatomic) IBOutlet UIButton *btnRecommend;
@property (weak, nonatomic) IBOutlet UIView *viewRecommendLine;
@property (strong, nonatomic) IBOutlet UIView *viewAllShop;
@property (weak, nonatomic) IBOutlet UIButton *btnWatchAllShop;

@property (strong, nonatomic) IBOutlet UIView *viewCouponSub;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCouponSubLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (assign, nonatomic) NSInteger selectShowView;  // 0:详情  1：参数 2：商品
//商品详细数据
@property (nonatomic, strong) ProductDetail *dicGoodData;
// 广告
@property (nonatomic, strong) NSMutableArray *adContentData;

@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIView *thirdShareView;

@end

@implementation RenovationShopDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectShowView = 0;
    _adContentData = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.tableView.frame = CGRectMake(0,64, kScreenWidth, kScreenHeight - 113);
    [self.view insertSubview:self.tableView belowSubview:self.btnBack];

    _webViewDetail.scrollView.scrollEnabled = NO;
    
    [self getAdContent:product_detail_1080x1920];
    
    [self setUiCornerRadiu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUiCornerRadiu{
    self.btnDiscount.layer.cornerRadius = 2;
    self.btnDiscount.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnDiscount.layer.borderWidth = 1;
    self.btnReceiveCoupon.layer.cornerRadius = 2;
    self.btnReceiveCoupon.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnReceiveCoupon.layer.borderWidth = 1;
    
    CGFloat itemWidth = kScreenWidth / 2;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemWidth-12.5, 258);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 12.5, 10, 12.5);
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView registerClass:[DecorationPackageCell class] forCellWithReuseIdentifier:@"DecorationPackageCell"];
}

//  tableview头view
- (void)setHeadUi{
    
    //设置头视图
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.tableView.tableHeaderView = viewHeader;
    float viewIntroduceHeight = 89 + kScreenWidth * 99 / 125;
    self.viewIntroduce.frame = CGRectMake(0,0, kScreenWidth, viewIntroduceHeight);
    [viewHeader addSubview:self.viewIntroduce];
    
    [self setBanner];
    
    float viewCouponHeight = 109;
    _viewPromotionalAdHeight.constant = 38;
    // 优惠券  "exchange_type" : "0" 优惠券金额类型 0会员等级,1固定金额,2消费金额
    NSArray *couponArr = _dicGoodData.coupon;
    if (couponArr.count >0) {
        NSDictionary *couponDic = couponArr[0];
        NSString *couponType = [couponDic[@"exchange_type"] description];
        if ([couponType integerValue] == 0) {
            //已登录时判断
            if (!DATA_ENV.isLogin) {
                [self setNoLoginFourCoupon];
            }else{
                 viewCouponHeight = 84;
                [self setLoginFourCoupon];
            }
        }else if ([couponType integerValue] == 1){
            [self vsetStaticMoneyCoupon];
        }else if ([couponType integerValue] == 2){
             [self setConsumptionAmountCoupon];
        }
        if(_adContentData.count == 0){
            viewCouponHeight = viewCouponHeight - 38;
            _viewPromotionalAdHeight.constant = 0;
        }
        
    }else{
        if(_adContentData.count == 0){
            viewCouponHeight = 0;
            _viewPromotionalAdHeight.constant = 0;
        }else{
            viewCouponHeight = 47;
        }
    }
    
    if(_adContentData.count > 0){
        AdContent *adContent = _adContentData[0];
        self.labelAdContent.text = adContent.contentName;
    }
    
    self.viewCoupon.frame = CGRectMake(0,self.viewIntroduce.frame.origin.y + viewIntroduceHeight , kScreenWidth, viewCouponHeight);
    [viewHeader addSubview:self.viewCoupon];
   
    
    float viewCompanyHeight = 110;
    self.viewCompany.frame = CGRectMake(0,self.viewCoupon.frame.origin.y + viewCouponHeight, kScreenWidth, viewCompanyHeight);
    [viewHeader addSubview:self.viewCompany];
    
    self.labelShopName.text = _dicGoodData.productName;
    NSString *mallPrice = [NSString stringWithFormat:@"￥%@", _dicGoodData.mallPrice];
    if ([CommonUtil isEmpty:_dicGoodData.mallPrice]) {
        mallPrice = @"面议";
    }
    self.labelMallPrice.text = mallPrice;
    if (! [CommonUtil isEmpty:mallPrice ]) {
        CGSize contentSize = [mallPrice boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:
                                                                  [UIFont systemFontOfSize:24]}
                                                    context:nil].size;
        self.labelMallPriceWidth.constant = contentSize.width + 5;
    }
    
    
    [self setStoreDetailUi];
    
    
    float viewShowSelectHeight = 45;
    self.viewShowSelect.frame = CGRectMake(0,self.viewCompany.frame.origin.y + viewCompanyHeight, kScreenWidth, viewShowSelectHeight);
    [viewHeader addSubview:self.viewShowSelect];
    
    viewHeader.height = viewIntroduceHeight + viewCouponHeight + viewCompanyHeight + viewShowSelectHeight;
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:viewHeader];
    [self.tableView endUpdates];
}

// 没有登录显示的优惠券
- (void)setNoLoginFourCoupon{
    _viewNoLoginFourCoupon.hidden = NO;
    _viewLoginOneCoupon.hidden = YES;
    _viewStaticMoneyCoupon.hidden = YES;
    _viewConsumptionAmountCoupon.hidden = YES;
    NSArray *coupon = _dicGoodData.coupon;
    if (coupon.count == 0) {
        return;
    }
    NSDictionary *couponDic = coupon[0];
    NSMutableDictionary *levelPrices = couponDic[@"level_prices"];
    
    NSInteger couponNum = 4;
    if (couponNum > 0) {
        self.viewCouponSubLeft.constant = 87;
        float couponWidth = (kScreenWidth-108) / couponNum;
        if(kScreenWidth == 320){
            couponWidth = (kScreenWidth-96) / couponNum;
            self.viewCouponSubLeft.constant = 75;
        }else if (kScreenWidth == 414){
            couponWidth = (kScreenWidth-118) / couponNum;
            self.viewCouponSubLeft.constant = 97;
        }
        for (int a = 0; a<couponNum; a++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(couponWidth * a, 0, couponWidth, 36)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1.5, 0, couponWidth -3, 36)];
            [btn setImage:[UIImage imageNamed:@"优惠券未选择"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(couponDetail) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lableTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, couponWidth -4, 20)];
            lableTop.font = [UIFont systemFontOfSize:16];
            lableTop.textColor = RGB(255, 85, 85);
            lableTop.textAlignment = UITextAlignmentCenter;
            NSString *money = @"";
            NSString *grade = @"";
            if(a == 0){
                money = [NSString stringWithFormat:@"￥%@",[levelPrices[@"new"] description]];
                grade = @"新会员";
            }else if (a == 1){
                money = [NSString stringWithFormat:@"￥%@",[levelPrices[@"old"] description]];
                grade = @"老会员";
            }else if (a == 2){
                money = [NSString stringWithFormat:@"￥%@",[levelPrices[@"vip"] description]];
                grade = @"VIP会员";
            }else{
                money = [NSString stringWithFormat:@"￥%@",[levelPrices[@"vip"] description]];
                grade = @"金卡会员";
            }
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:money];
            UIFont *font = [UIFont systemFontOfSize:12];
            [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1,money.length-1)];
            lableTop.attributedText = attrString;
            
            UILabel *lableBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, couponWidth -4, 15)];
            lableBottom.font = [UIFont systemFontOfSize:10];
            lableBottom.textColor = RGB(255, 85, 85);
            lableBottom.textAlignment = UITextAlignmentCenter;
            lableBottom.text = grade;
            
            [view addSubview:lableTop];
            [view addSubview:lableBottom];
            [view addSubview:btn];
            [self.viewCouponSub addSubview:view];
        }
    }
}

// 登录显示的优惠券
- (void)setLoginFourCoupon{
    NSString *sore =  DATA_ENV.userInfo.user.score;
    NSArray *coupon = _dicGoodData.coupon;
    if (coupon.count == 0) {
        return;
    }
    NSDictionary *couponDic = coupon[0];
    NSMutableDictionary *levelPrices = couponDic[@"level_prices"];
    if ([sore isEqualToString:@"new"]) {
        _labelLoginShowCouponContent.text = [NSString stringWithFormat:@"新会员专享%@现金券",[levelPrices[@"new"] description]];
    }else if ([sore isEqualToString:@"old"]) {
        _labelLoginShowCouponContent.text = [NSString stringWithFormat:@"老会员专享%@现金券",[levelPrices[@"old"] description]];
    }else if ([sore isEqualToString:@"vip"]) {
        _labelLoginShowCouponContent.text = [NSString stringWithFormat:@"VIP会员专享%@现金券",[levelPrices[@"vip"] description]];
    }else if ([sore isEqualToString:@"gold"]) {
        _labelLoginShowCouponContent.text = [NSString stringWithFormat:@"金卡会员专享%@现金券",[levelPrices[@"gold"] description]];
    }else{
        _labelLoginShowCouponContent.text = [NSString stringWithFormat:@"新会员专享%@现金券",[levelPrices[@"new"] description]];
    }
    
    _viewNoLoginFourCoupon.hidden = YES;
    _viewLoginOneCoupon.hidden = NO;
    _viewStaticMoneyCoupon.hidden = YES;
    _viewConsumptionAmountCoupon.hidden = YES;
}

// 显示固定金额的优惠券
- (void)vsetStaticMoneyCoupon{
    _viewNoLoginFourCoupon.hidden = YES;
    _viewLoginOneCoupon.hidden = YES;
    _viewStaticMoneyCoupon.hidden = NO;
    _viewConsumptionAmountCoupon.hidden = YES;
    NSArray *coupon = _dicGoodData.coupon;
    if (coupon.count == 0) {
        return;
    }
    NSDictionary *couponDic = coupon[0];
    NSMutableDictionary *levelPrices = couponDic[@"level_prices"];
    NSString *money = [levelPrices[@"new"] description];
    NSString *content = [NSString stringWithFormat:@"￥%@现金券（不区分会员级别）",money];
    NSMutableAttributedString *contentCoupon = [[NSMutableAttributedString alloc] initWithString:content];
    [contentCoupon addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,1)];
    [contentCoupon addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(1,money.length+4)];
    [contentCoupon addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11]range:NSMakeRange(money.length+4,9)];
    _labelStaticMoneyCoupon.attributedText = contentCoupon;
    
}
// 消费金额优惠券
- (void)setConsumptionAmountCoupon{
    _viewNoLoginFourCoupon.hidden = YES;
    _viewLoginOneCoupon.hidden = YES;
    _viewStaticMoneyCoupon.hidden = YES;
    _viewConsumptionAmountCoupon.hidden = NO;

    NSArray *coupon = _dicGoodData.coupon;
    if (coupon.count == 0) {
        return;
    }
    NSDictionary *couponDic = coupon[0];
    NSMutableDictionary *levelPrices = couponDic[@"level_prices"];
    NSMutableDictionary *meetRule = couponDic[@"meet_rule"];
    
    NSArray* allKeys = [levelPrices allKeys];
    NSMutableArray* allValueLevelPrices = [NSMutableArray array];
    for (NSString* key in allKeys) {
        if(![key isEqualToString:@"_new"]){
            [allValueLevelPrices addObject:[levelPrices valueForKey:key]];
        }
    }
    
    NSArray* allKeys1 = [meetRule allKeys];
    NSMutableArray* allValueMeetRule = [NSMutableArray array];
    for (NSString* key in allKeys1) {
        if(![key isEqualToString:@"_new"]){
            [allValueMeetRule addObject:[meetRule valueForKey:key]];
        }
    }
    
    NSInteger couponNum = 4;
    if (couponNum > 0) {
        
        float couponWidth = (kScreenWidth-40) / couponNum;
        for (int a = 0; a<couponNum; a++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(couponWidth * a, 7, couponWidth, 36)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(1.5, 0, couponWidth -3, 36)];
            [btn setImage:[UIImage imageNamed:@"优惠券未选择白色"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(couponDetail) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lableTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, couponWidth -4, 20)];
            lableTop.font = [UIFont systemFontOfSize:16];
            lableTop.textColor = [UIColor whiteColor];
            lableTop.textAlignment = UITextAlignmentCenter;
            NSString *money = [NSString stringWithFormat:@"￥%@" ,allValueLevelPrices[a]];
            NSString *grade =[NSString stringWithFormat:@"满%@可用" ,allValueMeetRule[a]];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:money];
            UIFont *font = [UIFont systemFontOfSize:12];
            [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1,money.length-1)];
            lableTop.attributedText = attrString;
            
            UILabel *lableBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, couponWidth -4, 15)];
            lableBottom.font = [UIFont systemFontOfSize:10];
            lableBottom.textColor = [UIColor whiteColor];
            lableBottom.textAlignment = UITextAlignmentCenter;
            lableBottom.text = grade;
            
            [view addSubview:lableTop];
            [view addSubview:lableBottom];
            [view addSubview:btn];
            [self.viewDepositConsumCoupon addSubview:view];
        }
    }
}

#pragma mark- ButtonClick
// 优惠券详情
- (void)couponDetail{
    NSArray *coupon = _dicGoodData.coupon;
    if (coupon.count == 0) {
        return;
    }
    NSDictionary *couponDic = coupon[0];
    CouponDetailViewController *view = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
    view.cashCouponId = [couponDic[@"cash_coupon_id"] description];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)btnReceiveCouponOnce:(id)sender {
    [self couponDetail];
}

- (IBAction)btnStatocMoneyCoupon:(id)sender {
    [self couponDetail];
}

// 商店详情
- (void)setStoreDetailUi{
    NSString *original = [NSString stringWithFormat:@"原价:￥%@", _dicGoodData.price];
    if ([CommonUtil isEmpty:_dicGoodData.price]) {
        self.viewOriginalWidth.constant = 0;
    }else{
        self.labelOriginalPrice.text = original;
        if (! [CommonUtil isEmpty:original ]) {
            CGSize contentSize = [original boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:
                                                                      [UIFont systemFontOfSize:12]}
                                                        context:nil].size;
            self.viewOriginalWidth.constant = contentSize.width + 2 ;
        }
    }
    
    NSDictionary *storeDic = _dicGoodData.store;
    NSString *orderNum = [_dicGoodData.store[@"order_num"] description];
    if([CommonUtil isEmpty:orderNum]){
        orderNum = @"0";
    }
    NSString *dpCount = [_dicGoodData.store[@"dp_count"] description];
    if([CommonUtil isEmpty:dpCount]){
        dpCount = @"0";
    }
    NSString *dpOrder = [_dicGoodData.store[@"dp_order"] description];
    if([CommonUtil isEmpty:dpOrder]){
        dpOrder = @"0";
    }

    NSString * commmentNum = [NSString stringWithFormat:@"%@预约｜%@订单｜%@点评", orderNum,dpOrder,dpCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(0,orderNum.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(orderNum.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(orderNum.length+3,dpOrder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(orderNum.length+3 +dpOrder.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(orderNum.length+3 +dpOrder.length+3,dpCount.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(commmentNum.length -2,2)];
    self.labelNumPeopleAppiont.attributedText = attrString;
    
    self.labelStoreName.text = [storeDic[@"store_name"] description];
    [self.ImageViewStore sd_setImageWithURL:[NSURL URLWithString:[storeDic[@"logo"] description]] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    
}

//  详情
- (void)setFooterUi{
    NSString *detail = _dicGoodData.content;
 
    if (![CommonUtil isEmpty:detail ]) {

        [self.webViewDetail loadHTMLString:detail baseURL:nil];
    
    }else{
        float viewDetailHeight =  50;
        self.viewDetial.frame = CGRectMake(0,0, kScreenWidth, viewDetailHeight);
        self.tableView.tableFooterView = self.viewDetial;
        self.viewDetial.height = viewDetailHeight;
        
        [self.tableView beginUpdates];
        [self.tableView setTableFooterView:self.viewDetial];
        [self.tableView endUpdates];
    }

}

- (void)setFooterHeght{
    if(_selectShowView == 0){
        float viewDetailHeight =  _webViewDetail.scrollView.contentSize.height;
        self.viewDetial.frame = CGRectMake(0,0, kScreenWidth, viewDetailHeight);
        self.tableView.tableFooterView = self.viewDetial;
        self.viewDetial.height = viewDetailHeight;
        
        [self.tableView beginUpdates];
        [self.tableView setTableFooterView:self.viewDetial];
        [self.tableView endUpdates];
    }else if (_selectShowView == 1){
        self.tableView.tableFooterView = self.viewParameter;
        [self.tableView beginUpdates];
        [self.tableView setTableFooterView: self.viewParameter];
        [self.tableView endUpdates];
    }else if (_selectShowView == 2){
        self.tableView.tableFooterView = viewFooter;
        [self.tableView beginUpdates];
        [self.tableView setTableFooterView:viewFooter];
        [self.tableView endUpdates];
    }
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self setFooterHeght];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self setFooterHeght];
}

// 创建banner图
- (void)setBanner{
    NSArray *imageArr = _dicGoodData.imgs;
   
    if (imageArr.count == 0) {
        imageArr = [NSArray arrayWithObject:@""];
    }
    NSInteger time;
    if (imageArr.count>1) {
        time=2.0;
    }else{
        time=100000;
    }
    //轮播图
    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 99 / 125)
                                                        delegate:self
                                                       imageURLs:imageArr
                                            placeholderImageName:nil
                                                    timeInterval:time
                                   currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                          pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
    bannerView.tag = 0;
    [self.viewBanner addSubview:bannerView];
}

#pragma mark - Actions LCBannerViewDelegate
//轮播图点击
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
//    [self openWebView:@"http://bj.jiehun.com.cn"];
}

// 创建参数表
- (void)creatParamter{
    
    for (id view in self.viewParameterSub.subviews) {
        [view removeFromSuperview];
    }
    
    NSDictionary *attr = _dicGoodData.attr;
    NSArray* allKeysAttr = [attr allKeys];
    NSMutableArray *attrList = [NSMutableArray array];
    for (NSString *key in allKeysAttr) {
        [attrList addObject:attr[key]];
    }
    
    
    float totalHeight;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth- 20, 0)];
    NSInteger bigNum = attrList.count;
    for (int a = 0; a < bigNum ; a++) {
        NSDictionary *smallDic = attrList[a];
    
        NSString *value = [smallDic[@"value"] description];
        float valueheigth = 26;
        if (! [CommonUtil isEmpty:value ]) {
            CGSize contentSize = [value boundingRectWithSize:CGSizeMake(kScreenWidth -90 , MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:
                                                                   [UIFont systemFontOfSize:12]}
                                                     context:nil].size;
            if (contentSize.height >26) {
                valueheigth = contentSize.height +8;
            }
            
        }
        NSString *attrvalue = [smallDic[@"attr_name"] description];
        float attrheigth = 26;
        if (! [CommonUtil isEmpty:attrvalue ]) {
            CGSize contentSize = [attrvalue boundingRectWithSize:CGSizeMake(54 , MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:
                                                                   [UIFont systemFontOfSize:12]}
                                                     context:nil].size;
            if (contentSize.height >26) {
                attrheigth = contentSize.height +8;
            }
            
        }
        if(attrheigth > valueheigth){
            valueheigth = attrheigth;
        }
        
        UILabel *labelSmall = [[UILabel alloc] initWithFrame:CGRectMake(8, totalHeight, 54, valueheigth)];
        labelSmall.text = [smallDic[@"attr_name"] description];
        labelSmall.font = [UIFont systemFontOfSize:12.0f];
        labelSmall.textColor = RGB(102, 102, 102);
        labelSmall.numberOfLines = 0;
        [view addSubview:labelSmall];
        
        
        UILabel *labelDetial = [[UILabel alloc] initWithFrame:CGRectMake(70, labelSmall.frame.origin.y, kScreenWidth - 90, valueheigth)];
        labelDetial.text = value;
        labelDetial.font = [UIFont systemFontOfSize:12.0f];
        labelDetial.textColor = RGB(51, 51, 51);
        labelDetial.numberOfLines = 0;
        [view addSubview:labelDetial];
        
        
        UIView *viewLineSu = [[UIView alloc] initWithFrame:CGRectMake(61, labelSmall.frame.origin.y, 1, valueheigth)];
        viewLineSu.backgroundColor = RGB(221, 221, 221);
        [view addSubview:viewLineSu];
        
        if (a != (bigNum-1)){
            UIView *viewLineHen = [[UIView alloc] initWithFrame:CGRectMake(0, labelSmall.frame.origin.y + valueheigth, kScreenWidth-20, 1)];
            viewLineHen.backgroundColor = RGB(221, 221, 221);
            [view addSubview:viewLineHen];
        }
    
        
        totalHeight += valueheigth;
    }
  
    view.height = totalHeight;
    view.layer.borderColor = RGB(221, 221, 221).CGColor;
    view.layer.borderWidth = 1;
    
    [self.viewParameterSub addSubview:view];
    
    self.viewParameter.frame = CGRectMake(0,0, kScreenWidth, totalHeight + 60 );
    self.tableView.tableFooterView = self.viewParameter;
    // [viewFooter addSubview:self.viewDetial];
    
    [self.tableView beginUpdates];
    [self.tableView setTableFooterView: self.viewParameter];
    [self.tableView endUpdates];
    
}

//// 创建参数表
//- (void)creatParamter{
//    
//    for (id view in self.viewParameterSub.subviews) {
//        [view removeFromSuperview];
//    }
//    
//    NSDictionary *attr = _dicGoodData.attr;
//    NSArray* allKeysAttr = [attr allKeys];
//    NSMutableArray *attrList = [NSMutableArray array];
//    for (NSString *key in allKeysAttr) {
//        [attrList addObject:attr[key]];
//    }
//    
//    
//    float totalHeight;
//    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth- 20, 0)];
//    NSInteger bigNum = 5;
//    for (int a = 0; a < bigNum ; a++) {
//        //NSDictionary *smallDic = attrList[a];
//        NSInteger smallNum = 4;
//        UILabel *labelBig = [[UILabel alloc] initWithFrame:CGRectMake(8, totalHeight , kScreenWidth-36, 26)];
//        labelBig.textColor = RGB(51, 51, 51);
//        labelBig.font = [UIFont systemFontOfSize:12.0f];
//        labelBig.text = @"规格参数";
//        UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, labelBig.frame.origin.y + 25, kScreenWidth-20, 1)];
//        viewline.backgroundColor = RGB(221, 221, 221);
//        [view addSubview:labelBig];
//        [view addSubview:viewline];
//        for (int b = 0; b<smallNum; b++) {
//            UILabel *labelSmall = [[UILabel alloc] initWithFrame:CGRectMake(8, labelBig.frame.origin.y + 26 + 26*b, 54, 26)];
//            labelSmall.text = @"容量";
//            labelSmall.font = [UIFont systemFontOfSize:12.0f];
//            labelSmall.textColor = RGB(102, 102, 102);
//            [view addSubview:labelSmall];
//            
//            UILabel *labelDetial = [[UILabel alloc] initWithFrame:CGRectMake(70, labelSmall.frame.origin.y, kScreenWidth - 90, 26)];
//            labelDetial.text = @"2222220v";
//            labelDetial.font = [UIFont systemFontOfSize:12.0f];
//            labelDetial.textColor = RGB(51, 51, 51);
//            [view addSubview:labelDetial];
//            
//            UIView *viewLineSu = [[UIView alloc] initWithFrame:CGRectMake(61, labelSmall.frame.origin.y, 1, 26)];
//            viewLineSu.backgroundColor = RGB(221, 221, 221);
//            [view addSubview:viewLineSu];
//            
//            UIView *viewLineHen = [[UIView alloc] initWithFrame:CGRectMake(0, labelSmall.frame.origin.y + 25, kScreenWidth-20, 1)];
//            viewLineHen.backgroundColor = RGB(221, 221, 221);
//            [view addSubview:viewLineHen];
//        }
//        totalHeight += smallNum * 26 +26;
//    }
//    view.height = totalHeight;
//    view.layer.borderColor = RGB(221, 221, 221).CGColor;
//    view.layer.borderWidth = 1;
//    
//    [self.viewParameterSub addSubview:view];
//    
//    self.viewParameter.frame = CGRectMake(0,0, kScreenWidth, totalHeight + 89);
//    self.tableView.tableFooterView = self.viewParameter;
//    // [viewFooter addSubview:self.viewDetial];
//    
//    [self.tableView beginUpdates];
//    [self.tableView setTableFooterView: self.viewParameter];
//    [self.tableView endUpdates];
//    
//}

// webview回调
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeOther)
    {
      
    }
    
    return YES;
}

// 促销广告
- (IBAction)goAdClick:(id)sender {
    if(_adContentData.count > 0){
        AdContent *adContent = _adContentData[0];
        [self openWebView:adContent.contentUrl];
    }
}
// 推荐
- (void)creatRecommend{
    
    NSArray *guess = _dicGoodData.guess;
    float collectionViewHight = 268 * ((guess.count+1)/2) +10;
    viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  collectionViewHight + 43)];
    
    self.collectionView.frame = CGRectMake(0,0, kScreenWidth, collectionViewHight );
    [viewFooter addSubview: self.collectionView];
    
    self.viewAllShop.frame = CGRectMake(0, self.collectionView.frame.origin.y +self.collectionView.frame.size.height , kScreenWidth, 43);
    [viewFooter addSubview: self.viewAllShop];
    self.tableView.tableFooterView = viewFooter;
    [self.tableView beginUpdates];
    [self.tableView setTableFooterView:viewFooter];
    [self.tableView endUpdates];

}

// 选择 详情 参数 推荐
- (IBAction)btnSelectShow:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if (sender.tag == 0) {
        self.viewDetialLine.hidden = NO;
        self.btnParameter.selected = NO;
        self.viewParameterLine.hidden = YES;
        self.btnRecommend.selected = NO;
        self.viewRecommendLine.hidden = YES;
        _selectShowView = 0;
        [self setFooterUi];
    }else if (sender.tag == 1){
        self.viewParameterLine.hidden = NO;
        self.btnDetial.selected = NO;
        self.viewDetialLine.hidden = YES;
        self.btnRecommend.selected = NO;
        self.viewRecommendLine.hidden = YES;
          _selectShowView = 1;
        [self creatParamter];
    }else if (sender.tag == 2){
        self.viewRecommendLine.hidden = NO;
        self.btnDetial.selected = NO;
        self.viewDetialLine.hidden = YES;
        self.btnParameter.selected = NO;
        self.viewParameterLine.hidden = YES;
         _selectShowView = 2;
        [self creatRecommend];
    }
}

// 跳商家
- (IBAction)btnClickMerchant:(id)sender {
    NSDictionary *dic = _dicGoodData.store;
    RenovationCompanyHomeViewController *view = [[RenovationCompanyHomeViewController alloc] initWithNibName:@"RenovationCompanyHomeViewController" bundle:nil];
    view.storeId = [dic[@"store_id"] description];
    [self.navigationController pushViewController:view animated:YES];
}


//  返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 打开web
- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

// 查看全部套餐
- (IBAction)btnClickGoAllPackage:(id)sender {
     NSDictionary *dic = _dicGoodData.store;
    AllPackageViewController *view = [[AllPackageViewController alloc] initWithNibName:@"AllPackageViewController" bundle:nil];
    view.storeId = [dic[@"store_id"] description];
    view.storeName = [dic[@"store_name"] description];
    view.isShop = @"1";
    [self.navigationController pushViewController:view animated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    NSDictionary *dic = _dicGoodData.store;
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = [dic[@"store_id"] description];
    [self.navigationController pushViewController:view animated:YES];
}

// 分享
- (IBAction)btnClickShare:(id)sender {
   
   
    
        //添加蒙版
    _popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _popView.backgroundColor=[UIColor blackColor];
    _popView.alpha=0.8;
    _popView.tag=86;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteView)];
    [ _popView addGestureRecognizer:tap1];
    [[UIApplication sharedApplication].keyWindow addSubview: _popView];
    
    //第三方分享view
    _thirdShareView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 210)];
    
    [UIView animateWithDuration:0.5 animations:^{
        _thirdShareView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-210, [UIScreen mainScreen].bounds.size.width, 210);
        [[UIApplication sharedApplication].keyWindow addSubview: _thirdShareView];
        
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.5 animations:^{
            
        }completion:nil];
    }];
    _thirdShareView.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _thirdShareView.frame.size.width, 150)];
    firstView.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView1.userInteractionEnabled=YES;
    UITapGestureRecognizer *WXtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinShare)];
    [ imageView1 addGestureRecognizer:WXtap];
    imageView1.image=[UIImage imageNamed:@"微信"];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y+imageView1.frame.size.height+5, imageView1.frame.size.width, 25)];
    label1.text=@"微信";
    label1.font=[UIFont systemFontOfSize:13];
    label1.textAlignment=NSTextAlignmentCenter;
    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(25+60+imageView1.frame.size.width, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView2.userInteractionEnabled=YES;
    UITapGestureRecognizer *PYtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wxPyquanshare)];
    [ imageView2 addGestureRecognizer:PYtap];
    imageView2.image=[UIImage imageNamed:@"朋友圈"];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y+imageView2.frame.size.height+5, imageView1.frame.size.width, 25)];
    label2.text=@"朋友圈";
    label2.font=[UIFont systemFontOfSize:13];
    label2.textAlignment=NSTextAlignmentCenter;
    
    UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(25+60*2+imageView2.frame.size.width*2, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView3.userInteractionEnabled=YES;
    UITapGestureRecognizer *FZtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pasteLink)];
    [ imageView3 addGestureRecognizer:FZtap];
    imageView3.image=[UIImage imageNamed:@"复制链接"];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(imageView3.frame.origin.x, imageView3.frame.origin.y+imageView3.frame.size.height+5, imageView3.frame.size.width, 25)];
    label3.text=@"复制链接";
    label3.font=[UIFont systemFontOfSize:13];
    label3.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:imageView1];
    [firstView addSubview:label1];
    [firstView addSubview:imageView2];
    [firstView addSubview:label2];
    [firstView addSubview:imageView3];
    [firstView addSubview:label3];
    [_thirdShareView addSubview:firstView];
    
    UIButton *SecdBut=[[UIButton alloc]initWithFrame:CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 50)];
    SecdBut.backgroundColor=[UIColor whiteColor];
    [SecdBut setTitle:@"取消" forState: UIControlStateNormal];
    [SecdBut setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    SecdBut.titleLabel.font=[UIFont systemFontOfSize:15];
    [SecdBut addTarget:self action:@selector(deleteView) forControlEvents:UIControlEventTouchUpInside];
    [_thirdShareView addSubview:SecdBut];
    
    
}
-(void)deleteView{
    [_popView removeFromSuperview];
    [_thirdShareView removeFromSuperview];
}
#pragma mark - 复制
- (void)pasteLink {
    if(_dicGoodData == nil){
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/product/%@",_productId];
    NSString *title = _dicGoodData.productName;
    NSArray *imageArr = _dicGoodData.imgs;
    NSString *image;
    if (imageArr.count > 0) {
        image = imageArr[0];
    }
    
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", image,@"logo",url,@"link",nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = shareDic[@"link"];
    
    [MessageView displayMessage:@"已经复制到剪贴板"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 微信朋友圈
-(void)wxPyquanshare{
    if (![WXApi isWXAppInstalled]) {
        [MessageView displayMessage:@"没有安装微信"];
        return;
    }
    if(_dicGoodData == nil){
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/product/%@",_productId];
    NSString *title = _dicGoodData.productName;
    NSArray *imageArr = _dicGoodData.imgs;
    NSString *image;
    if (imageArr.count > 0) {
        image = imageArr[0];
    }
    
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", image,@"logo",url,@"link",nil];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image1;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image1= [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image1 scaledToSize:CGSizeMake(99, 99) ]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareDic[@"link"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 1;
    [WXApi sendReq:req];
    
}


#pragma mark - 微信好友
- (void) weixinShare {
    if (![WXApi isWXAppInstalled]) {
        [MessageView displayMessage:@"没有安装微信"];
        return;
    }
    if(_dicGoodData == nil){
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/product/%@",_productId];
    NSString *title = _dicGoodData.productName;
    NSArray *imageArr = _dicGoodData.imgs;
    NSString *image;
    if (imageArr.count > 0) {
        image = imageArr[0];
    }
    
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", image,@"logo",url,@"link",nil];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image1;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image1 = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image1 scaledToSize:CGSizeMake(99, 99) ]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareDic[@"link"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    [WXApi sendReq:req];
    
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (UIImage *)saveImage:(UIImage *)image
{
    //png格式压缩后存入当前图片
    //    UIImage *compressImg = [self imageCompressForWidth:image];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    return [UIImage imageWithData:imgData];
    
    
}





#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
     return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
//    static NSString * commentCell = @"CompanyCommentCell";
//    CompanyCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
//    if (cell == nil) {
//        [tableView registerNib:[UINib nibWithNibName:@"CompanyCommentCell" bundle:nil] forCellReuseIdentifier:commentCell];
//        cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     return 195;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    NSArray *guess = _dicGoodData.guess;
    return guess.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [GoodsDetail createModelsArrayByResults:_dicGoodData.guess];
    GoodsDetail *goodsDetail = arr[indexPath.row];
    DecorationPackageCell *cell = (DecorationPackageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DecorationPackageCell" forIndexPath:indexPath];
    NSString *needText = [NSString stringWithFormat:@"￥%@",goodsDetail.mall_price];
    if ([CommonUtil isEmpty:goodsDetail.mall_price ]) {
        needText = @"面议";
        cell.labelPresentPrice.font = [UIFont systemFontOfSize:16];
        cell.labelPresentPrice.text = needText;
    }else{
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
        UIFont *font = [UIFont systemFontOfSize:12];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1,needText.length-1)];
        cell.labelPresentPrice.attributedText = attrString;
    }
    
    cell.labelOriginalPrice.hidden = NO;
    if ([CommonUtil isEmpty: goodsDetail.price]) {
        cell.labelOriginalPrice.hidden = YES;
        cell.viewOrigunalPriceWidth.constant = 0;
    }else{
        NSString *mallPrice = [NSString stringWithFormat:@"￥%@", goodsDetail.price];
        cell.labelOriginalPrice.text = mallPrice;
        if (! [CommonUtil isEmpty:mallPrice ]) {
            CGSize contentSize = [mallPrice boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:
                                                                       [UIFont systemFontOfSize:10]}
                                                         context:nil].size;
            cell.viewOrigunalPriceWidth.constant = contentSize.width +2 ;
        }
    }
    
    if (! [CommonUtil isEmpty:needText ]) {
        CGSize contentSize = [needText boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:
                                                                  [UIFont systemFontOfSize:16]}
                                                    context:nil].size;
        cell.labelPresentWidth.constant = contentSize.width +2 ;
    }
    
    //团
    if (goodsDetail.tuan && [goodsDetail.tuan[@"tuaning"] boolValue] == YES) {
        cell.labelNumPeopleJion.hidden = NO;
        NSString *num = [goodsDetail.tuan[@"order_cnt"] description];
        if ([CommonUtil isEmpty:num]) {
            num = @"0";
        }
        NSString *numPeople = [NSString stringWithFormat:@"已有%@人参团",num];
        NSMutableAttributedString *numPeopleString = [[NSMutableAttributedString alloc] initWithString:numPeople];
        [numPeopleString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0,2)];
        [numPeopleString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(2,num.length)];
        [numPeopleString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(2+num.length,3)];
        cell.labelNumPeopleJion.attributedText = numPeopleString;
    }else{
        cell.labelNumPeopleJion.hidden = YES;
    }
    
    cell.labelTitle.text = goodsDetail.product_name;
    [cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:goodsDetail.productPicUrl] placeholderImage:[UIImage imageNamed:PLUSPLACEHOLDERIMG]];
    
    cell.viewMember.hidden = YES;
    if([goodsDetail.huiyuanjie integerValue] == 1){
        cell.viewMember.hidden = NO;
    }
    
    return cell;
}

#pragma mark- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [GoodsDetail createModelsArrayByResults:_dicGoodData.guess];
    GoodsDetail *goodsDetail = arr[indexPath.row];
    RenovationShopDetialViewController *view = [[RenovationShopDetialViewController alloc] initWithNibName:@"RenovationShopDetialViewController" bundle:nil];
    view.productId = goodsDetail.productId;
    [self.navigationController pushViewController:view animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建collectionView
    CGFloat itemWidth = kScreenWidth / 2 ;
    
    return CGSizeMake(itemWidth-15, 258);
}

#pragma mark - private
// 取商品数据
- (void)getGoodsDetailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_productId forKey:@"product_id"];

    __weak typeof(self) weakSelf = self;
    [GetRenovationShopDetialRequest requestWithParameters:parameters
                                    withCacheType:DataCacheManagerCacheTypeMemory
                                withIndicatorView:self.view
                                withCancelSubject:[GetRenovationShopDetialRequest getDefaultRequstName]
                                   onRequestStart:nil
                                onRequestFinished:^(CIWBaseDataRequest *request) {
                                    
                                    if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                        
                                        weakSelf.dicGoodData = [request.resultDic objectForKey:@"productDetail"];
          
                                        [self setFooterUi];
                                        [self setHeadUi];
                                        [self setFooterUi];
                                     
                                    }
                        
                                                                   }
                                onRequestCanceled:^(CIWBaseDataRequest *request) {
                                  
                                }
                                  onRequestFailed:^(CIWBaseDataRequest *request) {
                                     
                                  }];
}

//取广告数据
- (void)getAdContent:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":name}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:nil
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   weakSelf.adContentData = [request.resultDic objectForKey:@"AdContent"];
                                    [self getGoodsDetailData];
                               }else{
                                    [self getGoodsDetailData];
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                                 [self getGoodsDetailData];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                   [self getGoodsDetailData];
                                 
                             }];
    
}

@end
