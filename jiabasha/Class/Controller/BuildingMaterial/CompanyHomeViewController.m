
//
//  CompanyHomeViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ShareView.h"
#import "GoodsDetail.h"
#import "StoreComment.h"
#import "BuildingExample.h"
#import "StoreCategory.h"
#import "BuildingStoreDetail.h"
#import "TQStarRatingView.h"
#import "MSSBrowseDefine.h"
#import "CompanyCommentCell.h"
#import "GetMallStoreCategory.h"
#import "DecorationPackageCell.h"
#import "AllCaseViewController.h"
#import "CaseHomeViewController.h"
#import "ShareViewController.h"
#import "GetBuildingStoreDetailRequest.h"
#import "AllPackageViewController.h"
#import "ReceiveCouponViewController.h"
#import "BranchListViewController.h"
#import "WonderfulCaseTableViewCell.h"
#import "CompanyHomeViewController.h"
#import "FreeFunctionViewController.h"
#import "GetMallExampleListRequest.h"
#import "getProductStoreCateogry.h"
#import "GetMallDpCommentListRequest.h"
#import "CouponDetailViewController.h"
#import "RenovationShopDetialViewController.h"
#import "AuthenticationDetialViewController.h"
#import "CompanyAllCommentViewController.h"
#import "GroupProductDetailViewController.h"


#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>

#import "Growing.h"

@interface CompanyHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MFMailComposeViewControllerDelegate, TencentSessionDelegate>
{
    UIView * Viewfooter;
}
@property (nonatomic, retain) TencentOAuth *oauth;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewComment;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

/* 主头部 */
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthentication; // 认证信息按钮
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCompany; // 公司图片
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyAddress; // 公司地址
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCompanyAddressHeigth;
@property (weak, nonatomic) IBOutlet UIButton *btnBranch; // 分店
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCompanyNameWidth;
@property (weak, nonatomic) IBOutlet UILabel *labelAppointment; // 预约点评
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewScoreAppiontWidth;

@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName; // 公司名字
@property (weak, nonatomic) IBOutlet UIButton *btnStoreWatch;  // 探店按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSignBill;    //  签单按钮
@property (weak, nonatomic) IBOutlet UIView *viewTotalCoupon;


/* 尾部 */
@property (strong, nonatomic) IBOutlet UIView *viewWatchShowAll; // 查看更多套餐
@property (strong, nonatomic) IBOutlet UIView *viewWatchAllComment; // 查看更多评论

@property (strong, nonatomic) IBOutlet UIView *viewCommentHead; // 评论头部
@property (strong, nonatomic) IBOutlet UIView *viewCoupon; // 优惠券礼介绍
@property (weak, nonatomic) IBOutlet UIView *viewFreeHelp; // 免费功能
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewFreeHelpHeight;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionHead;
@property (weak, nonatomic) IBOutlet UIView *viewCouponSub; //显示未登录具体优惠券
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCouponSubLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnFreeAppiont;

@property (weak, nonatomic) IBOutlet UIView *viewStar; // 星级
@property (weak, nonatomic) IBOutlet UIView *viewServiceAttitudeStar;  // 服务态度星级
@property (weak, nonatomic) IBOutlet UILabel *labelServiceNum;

//@property (weak, nonatomic) IBOutlet UIView *viewQualityStar;  //  完成质量星级
//@property (weak, nonatomic) IBOutlet UILabel *labelQualityNum;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckAllShop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTaotalCouponHeight;


// 探店 签单按钮
@property (weak, nonatomic) IBOutlet UIView *viewLookSign;
@property (weak, nonatomic) IBOutlet UIButton *btnLookShop;
@property (weak, nonatomic) IBOutlet UILabel *labelLookStore;
@property (weak, nonatomic) IBOutlet UIButton *btnSignGift;
@property (weak, nonatomic) IBOutlet UILabel *labelSignGift;


// 优惠券  "exchange_type" : "0" 优惠券金额类型 0会员等级,1固定金额,2消费金额
@property (weak, nonatomic) IBOutlet UIView *viewNoLoginFourCoupon; // 没有登录显示的优惠券
@property (weak, nonatomic) IBOutlet UIView *viewLoginOneCoupon; // 登录显示对应的优惠券
@property (weak, nonatomic) IBOutlet UILabel *labelLoginShowCouponContent;
@property (weak, nonatomic) IBOutlet UIButton *btnReceiveCoupon;
@property (weak, nonatomic) IBOutlet UIView *viewStaticMoneyCoupon; // 固定金额优惠券，不区分会员级别
@property (weak, nonatomic) IBOutlet UILabel *labelStaticMoneyCoupon;

@property (weak, nonatomic) IBOutlet UIView *viewConsumptionAmountCoupon; // 消费金额优惠券
@property (weak, nonatomic) IBOutlet UIView *viewDepositConsumCoupon;

// 探店里礼 和签单礼
@property (weak, nonatomic) IBOutlet UIView *viewIntoTheShop;
@property (weak, nonatomic) IBOutlet UILabel *labelIntoShopTitle;
@property (weak, nonatomic) IBOutlet UILabel *btnIntoShopContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIntoTheShopHeigth;
@property (weak, nonatomic) IBOutlet UIView *viewIntoShow;

@property (weak, nonatomic) IBOutlet UIView *viewSignTheBill;
@property (weak, nonatomic) IBOutlet UILabel *labelSignBillTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSignBillContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSignTheBillHeight;
@property (weak, nonatomic) IBOutlet UIView *viewSignBillShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSignBillShowHeight;

@property (weak, nonatomic) IBOutlet UIView *viewSelectShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnCatetorySelect;

@property (strong, nonatomic) ShareView *viewShare; // 分享

//  数据源
@property (nonatomic, strong) NSMutableArray *arrStoreData;//商家详细
@property (nonatomic, strong) NSMutableArray *arrStoreCaseData; // 精彩案例
@property (nonatomic, strong) NSMutableArray *arrStoreShopData; // 精彩商品
@property (nonatomic, strong) NSMutableArray *arrStoreCommentData; // 评论

// 分类
@property (strong, nonatomic) NSMutableArray *sortShopNum;
@property (nonatomic, strong) NSString *sortShopDataName;
@property (strong, nonatomic) NSMutableArray *arrStoreCategoryData;

@property (nonatomic, strong) NSString *allCaseNum;
@property (nonatomic) NSInteger pageComment;


@property (strong, nonatomic) TQStarRatingView *companyStarView;
@property (strong, nonatomic) TQStarRatingView *ServiceStarView;
@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIView *thirdShareView;
@end

@implementation CompanyHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    self.growingAttributesPageName=@"storeDetail_ios";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    _arrStoreData = [NSMutableArray array];
    _arrStoreCaseData = [NSMutableArray array];
    _arrStoreShopData = [NSMutableArray array];
    _arrStoreCommentData = [NSMutableArray array];
    _sortShopNum = [NSMutableArray array];
    _arrStoreCategoryData = [NSMutableArray array];
    _sortShopDataName = @"";
    CGFloat itemWidth = kScreenWidth / 2;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemWidth-12.5, 258);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 12.5, 10, 12.5);
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView registerClass:[DecorationPackageCell class] forCellWithReuseIdentifier:@"DecorationPackageCell"];
    
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    self.btnFreeAppiont.layer.cornerRadius=0;
    [self.view insertSubview:self.tableView belowSubview:self.btnFreeAppiont];
    
   [self setUiCornerRadiu];
 
    
    [self getStoreCategoryData];
    [self getBuildingStoreDetailData];
    [self getBuildingStoreCaseData];
    [self getBuildingStoreShopData];
    [self getBuildingStoreCommentDataPage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUiCornerRadiu{

    //设置头视图
    self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 333);
    self.tableView.tableHeaderView = self.viewHead;
    
    self.btnBranch.layer.cornerRadius = 2;
    self.btnBranch.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnBranch.layer.borderWidth = 0.7;
    
    self.btnAuthentication.layer.cornerRadius = 10.5;
    
    self.btnStoreWatch.layer.cornerRadius = 2;
    self.btnStoreWatch.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnStoreWatch.layer.borderWidth = 0.7;
    
    self.btnSignBill.layer.cornerRadius = 2;
    self.btnSignBill.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnSignBill.layer.borderWidth = 0.7;
    
    self.btnLookShop.layer.cornerRadius = 2;
    self.btnLookShop.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnLookShop.layer.borderWidth = 0.7;
    
    self.btnSignGift.layer.cornerRadius = 2;
    self.btnSignGift.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnSignGift.layer.borderWidth = 0.7;
    
    self.btnReceiveCoupon.layer.cornerRadius = 2;
    self.btnReceiveCoupon.layer.borderColor = RGB(255, 85, 85).CGColor;
    self.btnReceiveCoupon.layer.borderWidth = 1;

}

- (void)setHeadUi{
    if (_arrStoreData.count <= 0) {
        return;
    }
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    
    self.companyStarView = [[TQStarRatingView alloc] initWithFrame:self.viewStar.bounds numberOfStar:5 starSpace:2];
    self.companyStarView.couldClick = NO;//不可点击
    [self.viewStar addSubview:self.companyStarView];
    [self.companyStarView changeStarForegroundViewWithPoint:CGPointMake([storeDetail.scoreAvg floatValue]/500*CGRectGetWidth(self.viewStar.frame), 0)];//设置星级
    self.ServiceStarView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 64, 11)  numberOfStar:5 starSpace:2];
    self.ServiceStarView.couldClick = NO;//不可点击
    [self.viewServiceAttitudeStar addSubview:self.ServiceStarView];
    [self.ServiceStarView changeStarForegroundViewWithPoint:CGPointMake(0.0/5*64, 0)];//设置星级

    [self.ServiceStarView changeStarForegroundViewWithPoint:CGPointMake([storeDetail.scoreAvg floatValue]/500*64, 0)];//设置星级
    self.labelServiceNum.text = [NSString stringWithFormat:@"%.1f分",[storeDetail.scoreAvg floatValue]/100];

    NSString * commmentNum = [NSString stringWithFormat:@"%@预约｜%@订单｜%@点评", storeDetail.orderNum,storeDetail.dpOrder,storeDetail.dpCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(0,storeDetail.orderNum.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(storeDetail.orderNum.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(storeDetail.orderNum.length+3,storeDetail.dpOrder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(storeDetail.orderNum.length+3 +storeDetail.dpOrder.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(storeDetail.orderNum.length+3 +storeDetail.dpOrder.length+3,storeDetail.dpCount.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(commmentNum.length -2,2)];
    self.labelAppointment.attributedText = attrString;
    
    if (commmentNum != nil) {
        CGSize contentSize = [commmentNum boundingRectWithSize:CGSizeMake(kScreenWidth - 100, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:11]}
                                                                      context:nil].size;
        _viewScoreAppiontWidth.constant = contentSize.width + 80;
    }
    
    
    [self.imageViewCompany sd_setImageWithURL:[NSURL URLWithString:storeDetail.logo] placeholderImage:[UIImage imageNamed:SMALLPALCEHOLDERIMG]];
    self.labelCompanyName.text = storeDetail.storeName;
    self.labelCompanyAddress.text = storeDetail.address;
    if (self.labelCompanyAddress.text != nil) {
        CGSize contentSize = [self.labelCompanyAddress.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                      attributes:@{NSFontAttributeName:
                                                                                       [UIFont systemFontOfSize:12]}
                                                                         context:nil].size;
        self.labelCompanyAddressHeigth.constant = contentSize.height +1;
    }
    
    self.labelCompanyName.text = storeDetail.storeName;
    if (self.labelCompanyName.text != nil) {
        CGSize contentSize = [self.labelCompanyName.text boundingRectWithSize:CGSizeMake(kScreenWidth - 100, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:17]}
                                                                      context:nil].size;
        self.labelCompanyNameWidth.constant = contentSize.width + 4;
    }

    float lookSignHeight = 76;
    self.viewLookSign.hidden = NO;
    self.viewSignBillShowHeight.constant = 48;
    NSDictionary *agift = storeDetail.agift;
    NSDictionary *ogift = storeDetail.ogift;
    if([agift[@"title"] description] != nil  && [ogift[@"title"] description] != nil){
        self.labelLookStore.text = [agift[@"title"] description];
        self.labelSignGift.text = [ogift[@"title"] description];
    }else if ([agift[@"title"] description] != nil){
        lookSignHeight = 46;
        self.viewIntoShow.hidden = NO;
        self.viewSignBillShow.hidden = YES;
        self.labelLookStore.text = [agift[@"title"] description];
    }else if ([ogift[@"title"] description] != nil){
        lookSignHeight = 46;
        self.viewIntoShow.hidden = YES;
        self.viewSignBillShow.hidden = NO;
        self.viewSignBillShowHeight.constant = 20;
        self.labelSignGift.text = [ogift[@"title"] description];
    }
    else{
        lookSignHeight = 0;
        self.viewLookSign.hidden = YES;
    }
    
    NSDictionary * featureDic = storeDetail.featureVerify;
    NSArray* allKeys = [featureDic allKeys];
    NSMutableArray* allValue = [NSMutableArray array];
    for (NSString* key in allKeys) {
        if(![key isEqualToString:@"_new"]){
            [allValue addObject:[featureDic valueForKey:key]];
        }
    }

    NSInteger freeNum = allValue.count;
    if (freeNum > 0) {
        self.viewFreeHelpHeight.constant = 41;
        float freeWidth = (kScreenWidth-40) / freeNum;
        for (int a = 0; a<freeNum; a++) {
            NSDictionary *dic = allValue[a];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(freeWidth * a +20, 0, freeWidth, 41)];
            [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,8);

            [btn setTitle:[dic[@"title"] description] forState:UIControlStateNormal];
            NSLog(@"********==%@",btn.titleLabel.text);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[dic[@"mark"] description]]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            [btn setImage:image forState:UIControlStateNormal];

            btn.tag = a;
            [btn addTarget:self action:@selector(btnClickFree:) forControlEvents:UIControlEventTouchUpInside];
            [self.viewFreeHelp addSubview:btn];
        }
    }else{
        
        self.viewFreeHelpHeight.constant = 0;
    }
    
    float viewCouponHeight = 71;
    
    // 优惠券  "exchange_type" : "0" 优惠券金额类型 0会员等级,1固定金额,2消费金额
    NSArray *couponArr = storeDetail.coupon;
    if (couponArr.count >0) {
        self.viewTotalCoupon.hidden = NO;
        NSDictionary *couponDic = couponArr[0];
        NSString *couponType = [couponDic[@"exchange_type"] description];
        if ([couponType integerValue] == 0) {
            //已登录时判断
            if (!DATA_ENV.isLogin) {
                [self setNoLoginFourCoupon];
            }else{
                viewCouponHeight = 46;
                [self setLoginFourCoupon];
            }
        }else if ([couponType integerValue] == 1){
            [self vsetStaticMoneyCoupon];
        }else if ([couponType integerValue] == 2){
            [self setConsumptionAmountCoupon];
        }
    }else{
        self.viewTotalCoupon.hidden = YES;
        viewCouponHeight = 0;
    
    }
    self.viewTaotalCouponHeight.constant = viewCouponHeight;
    self.viewHead.height = 291 + self.viewFreeHelpHeight.constant + lookSignHeight -76 +viewCouponHeight -71;
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.viewHead];
    [self.tableView endUpdates];
}

- (void)setMianUi:(NSArray *) Data{
      
    Viewfooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.tableView.tableFooterView = Viewfooter;
    
    
    float viewCollectionHeadHight = 55;
    if (_arrStoreShopData.count == 0) {
        viewCollectionHeadHight = 0;
    }
    _viewCollectionHead.frame = CGRectMake(0,0, kScreenWidth, viewCollectionHeadHight);
  
    
    float collectionViewHight = (_arrStoreShopData.count +1)/2 * 268;
    if(_arrStoreShopData.count == 1 || _arrStoreShopData.count == 2){
        collectionViewHight += 10;
    }else if (_arrStoreShopData.count == 3 || _arrStoreShopData.count == 4){
        collectionViewHight += 5;
    }
    
    if (_arrStoreShopData.count > 0) {
        _viewCollectionHead.clipsToBounds = NO;
    }else{
       _viewCollectionHead.clipsToBounds = YES;
    }
    _collectionView.frame = CGRectMake(0, _viewCollectionHead.frame.origin.y + _viewCollectionHead.frame.size.height, kScreenWidth, collectionViewHight);
    [Viewfooter addSubview:_collectionView];
    
    float viewWatchShowAllHight = 43;
    if (_arrStoreShopData.count == 0) {
        viewWatchShowAllHight = 0;
    }
    _viewWatchShowAll.frame = CGRectMake(0, _collectionView.frame.origin.y + _collectionView.frame.size.height, kScreenWidth, viewWatchShowAllHight);
    [Viewfooter addSubview:_viewWatchShowAll];
    
    float viewCommentHeadHight = 104;
    _viewCommentHead.frame = CGRectMake(0, _viewWatchShowAll.frame.origin.y + _viewWatchShowAll.frame.size.height, kScreenWidth, viewCommentHeadHight);
     [Viewfooter addSubview:_viewCommentHead];
    
    float commentHeightTotal = 0;
    for (int a = 0; a<_arrStoreCommentData.count; a++) {
        StoreComment *storeComment = _arrStoreCommentData[a];
        
        float commentHeight = 100;
        if (storeComment.rrContent != nil) {
            CGSize contentSize = [storeComment.rrContent boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:15]}
                                                                      context:nil].size;
            if (storeComment.imgs.count == 0) {
                commentHeight = 88 + contentSize.height;
            }else{
                commentHeight = 177 + contentSize.height;
            }
        }
        
        commentHeightTotal += commentHeight;
    }
    _tableViewComment.frame = CGRectMake(0, _viewCommentHead.frame.origin.y + _viewCommentHead.frame.size.height, kScreenWidth, commentHeightTotal);
    [Viewfooter addSubview:_tableViewComment];
    
    _viewWatchAllComment.frame = CGRectMake(0, _tableViewComment.frame.origin.y + _tableViewComment.frame.size.height, kScreenWidth, 43);
    [Viewfooter addSubview:_viewWatchAllComment];
    
      [Viewfooter addSubview:_viewCollectionHead];
    
    Viewfooter.height = _viewWatchAllComment.frame.origin.y + _viewWatchAllComment.frame.size.height + 85;
    [self.collectionView reloadData];
    [self.tableView beginUpdates];
    [self.tableView setTableFooterView:Viewfooter];
    [self.tableView endUpdates];
}


// 没有登录显示的优惠券
- (void)setNoLoginFourCoupon{
    _viewNoLoginFourCoupon.hidden = NO;
    _viewLoginOneCoupon.hidden = YES;
    _viewStaticMoneyCoupon.hidden = YES;
    _viewConsumptionAmountCoupon.hidden = YES;
    
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSArray *coupon = storeDetail.coupon;
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
                money = [NSString stringWithFormat:@"￥%@",[levelPrices[@"gold"] description]];
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
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSArray *coupon = storeDetail.coupon;
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
    
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSArray *coupon = storeDetail.coupon;
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
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSArray *coupon = storeDetail.coupon;
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
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSArray *coupon = storeDetail.coupon;
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

// 返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 显示探店礼和签单礼介绍
- (IBAction)btnShowCouponView:(id)sender {
    
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSDictionary *agift = storeDetail.agift;
    NSDictionary *ogift = storeDetail.ogift;
    self.viewSignTheBill.hidden = NO;
    self.viewIntoTheShop.hidden = NO;
    if([agift[@"title"] description] != nil  &&  [ogift[@"title"] description]  != nil){
        [self setAgift:agift];
        [self setOgift:ogift];
    }else if ([agift[@"title"] description]  != nil ){
        [self setAgift:agift];
        self.viewSignTheBill.hidden = YES;
    }else if ([ogift[@"title"] description] != nil ){
        self.viewIntoTheShop.hidden = YES;
        _viewIntoTheShopHeigth = 0;
        [self setOgift:ogift];
    }

    self.viewCoupon.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view insertSubview: self.viewCoupon belowSubview:self.btnFreeAppiont];
    
}

- (void) setAgift:(NSDictionary *)agift{
    self.labelIntoShopTitle.text =  [agift[@"title"] description];
    NSString *agiftSontent =  [agift[@"desc"] description];
    if (agiftSontent != nil) {
        CGSize contentSize = [agiftSontent boundingRectWithSize:CGSizeMake(kScreenWidth - 54, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:12]}
                                                                      context:nil].size;
        _viewIntoTheShopHeigth.constant =  contentSize.height + 70;
    }
    
    self.btnIntoShopContent.text = agiftSontent;
}
- (void) setOgift:(NSDictionary *)ogift{
    self.labelSignBillTitle.text =  [ogift[@"title"] description];
    NSString *ogiftSontent =  [ogift[@"desc"] description];
    if (ogiftSontent != nil) {
        CGSize contentSize = [ogiftSontent boundingRectWithSize:CGSizeMake(kScreenWidth - 54, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:
                                                                      [UIFont systemFontOfSize:12]}
                                                        context:nil].size;
        _viewSignTheBillHeight.constant =  contentSize.height + 70;
    }
    self.labelSignBillContent.text = ogiftSontent;
}


// 关闭优惠券和礼的介绍
- (IBAction)btnCloseCouponView:(id)sender {
    [self.viewCoupon removeFromSuperview];
}

// 前往信息认证详细界面
- (IBAction)btnClickGoAuthenticationView:(id)sender {
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    AuthenticationDetialViewController *view = [[AuthenticationDetialViewController alloc] initWithNibName:@"AuthenticationDetialViewController" bundle:nil];
    
    view.storeId = storeDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

// 前往分店
- (IBAction)btnClickGoBranchView:(id)sender {
    BranchListViewController *view = [[BranchListViewController alloc] initWithNibName:@"BranchListViewController" bundle:nil];
    if (_arrStoreData.count > 0) {
        view.buildingStoreDetail = _arrStoreData[0];
    }
    [self.navigationController pushViewController:view animated:YES];
}

// 前往免费功能
- (void)btnClickFree:(UIButton *)btn{
     BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSDictionary * featureDic = storeDetail.featureVerify;
    
    NSArray* allKeys = [featureDic allKeys];
    NSMutableArray* allValue = [NSMutableArray array];
    for (NSString* key in allKeys) {
        if(![key isEqualToString:@"_new"]){
            [allValue addObject:[featureDic valueForKey:key]];
        }
    }
    NSDictionary *dic = allValue[btn.tag];
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"0";
    view.appiontType = [dic[@"title"] description];
    view.companyName = storeDetail.storeName;
    view.storeId = storeDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    if(_arrStoreData.count == 0){
        return;
    }
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.companyName = storeDetail.storeName;
    view.storeId = storeDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

// 到店领取
- (IBAction)btnClickGoReceiveView:(UIButton *)sender {
//    BuildingStoreDetail *storeDetail =_arrStoreData[0];
//    NSDictionary *agift = storeDetail.agift;
//    NSDictionary *ogift = storeDetail.ogift;
//    ReceiveCouponViewController *view = [[ReceiveCouponViewController alloc] initWithNibName:@"ReceiveCouponViewController" bundle:nil];
//    if (sender.tag == 0) {
//        view.dic = agift;
//        view.couponName = @"探店礼";
//    }else{
//        view.dic = ogift;
//        view.couponName = @"签单礼";
//    }
//    [self.navigationController pushViewController:view animated:YES];
}

// 查看全部精彩案例
- (void)btnWatchAllCase{
    AllCaseViewController *view = [[AllCaseViewController alloc] initWithNibName:@"AllCaseViewController" bundle:nil];
    view.isAllCase = @"0";
    view.storeId = _storeId;
    [self.navigationController pushViewController:view animated:YES];
}

// 查看全部套餐
- (IBAction)btnClickGoAllPackage:(id)sender {
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    AllPackageViewController *view = [[AllPackageViewController alloc] initWithNibName:@"AllPackageViewController" bundle:nil];
    view.storeId = _storeId;
    view.storeName = storeDetail.storeName;
    [self.navigationController pushViewController:view animated:YES];
}

// 查看全部评论
- (IBAction)btnClickGoAllComment:(id)sender {
//    CompanyAllCommentViewController *view = [[CompanyAllCommentViewController alloc] initWithNibName:@"CompanyAllCommentViewController" bundle:nil];
//    view.showType = @"1";
//    view.storeId = _storeId;
//    [self.navigationController pushViewController:view animated:YES];
    
        [self getBuildingStoreCommentDataPage:_pageComment +1];
    
    
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
#pragma mark - 复制
- (void)pasteLink {
    if(_arrStoreData.count == 0){
                return;
            }
            BuildingStoreDetail *storeDetail =_arrStoreData[0];
            NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
            NSString *title = storeDetail.storeName;
            NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", storeDetail.logo,@"logo",url,@"link",nil];
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
    if(_arrStoreData.count == 0){
        return;
    }
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
    NSString *title = storeDetail.storeName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", storeDetail.logo,@"logo",url,@"link",nil];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(99, 99) ]];
    
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
    if(_arrStoreData.count == 0){
        return;
    }
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
    NSString *title = storeDetail.storeName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", storeDetail.logo,@"logo",url,@"link",nil];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(99, 99) ]];
    
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

-(void)deleteView{
    [_popView removeFromSuperview];
    [_thirdShareView removeFromSuperview];
}
// 选择分类
- (IBAction)btnCategory:(UIButton *)sender {
    if (_arrStoreCategoryData.count == 0) {
        [self.view makeToast:@"暂无分类"];
        return;
    }
    if (sender.selected) {
        sender.selected = NO;
        self.viewSelectShow.hidden = YES;
        _viewCollectionHead.frame = CGRectMake(0,0, kScreenWidth, 55);
        [sender setTitleColor:RGB(181, 181, 181)forState:UIControlStateNormal];
    }else{
        [sender setTitleColor:RGB(255, 59, 48)forState:UIControlStateNormal];
        [self creatSelectView:_arrStoreCategoryData.count];
        sender.selected = YES;
        self.viewSelectShow.hidden = NO;
        //[self moveanimations];
    }
}


// 创建选择类型
- (void)creatSelectView:(NSInteger)num{
    for (id id in self.viewSelectShow.subviews) {
        if ([id isKindOfClass:[UIButton class]]) {
            [id removeFromSuperview];
        }
    }
    
    float btnWide = (kScreenWidth -75)/4;
    for (int a = 0; a<num; a++) {
        float yushu = a/4;
        float beiyushu = a%4;
        
        StoreCategory* storeCategory = _arrStoreCategoryData[a];
        UIButton *btnName = [[UIButton alloc] initWithFrame:CGRectMake(15 + (btnWide + 15) *beiyushu , 13 +38 * yushu, btnWide, 25)];
        btnName.backgroundColor = [UIColor clearColor];
        
        [btnName setTitle:storeCategory.scateName forState:UIControlStateNormal];
        btnName.layer.borderWidth = 0.5;
        btnName.tag = a;
        btnName.titleLabel.font = [UIFont systemFontOfSize:12];
        btnName.layer.cornerRadius = 3;
        btnName.layer.borderColor = RGB(193, 193, 193).CGColor;
        [btnName setTitleColor:RGB(193, 193, 193) forState:UIControlStateNormal];
        
        for (NSString *num in _sortShopNum) {
            if ([num integerValue] == a) {
                btnName.layer.borderColor = RGB(255, 59, 48).CGColor;
                [btnName setTitleColor:RGB(255, 59, 48) forState:UIControlStateNormal];
            }
        }
        
        [btnName addTarget:self action:@selector(selectShow:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewSelectShow addSubview:btnName];
        
    }
    float yushu = num/4;
    float beiyushu = num%4;
    float viewSelectH;
    if (beiyushu == 0) {
        viewSelectH = 13 + 38 * yushu;
    }else{
        viewSelectH = 13 + 38 *( yushu + 1);
    }
    if(num == 0){
        viewSelectH = 0;
    }
     self.viewSelectHeight.constant = viewSelectH ;
      _viewCollectionHead.frame = CGRectMake(0,0, kScreenWidth, 55+viewSelectH);
}

// 选择显示类型
- (void)selectShow:(UIButton *)btn{
    NSString *tag = [NSString stringWithFormat:@"%ld",btn.tag];
    if(![self.sortShopNum containsObject:tag]){
        [self.sortShopNum addObject:tag];
    }else{
        [self.sortShopNum removeObject:tag];
    }
    self.sortShopDataName = @"";
    for (NSString *num in _sortShopNum) {
        StoreCategory* storeCategory = _arrStoreCategoryData[[num integerValue]];
        if ([CommonUtil isEmpty:self.sortShopDataName ]) {
            self.sortShopDataName = storeCategory.scateId;
        }else{
            self.sortShopDataName = [NSString stringWithFormat:@"%@,%@",self.sortShopDataName,storeCategory.scateId];
        }
    }
    [self creatSelectView:_sortShopNum.count ];
    self.viewSelectShow.hidden = YES;
    [self goAllShopView];
    
}

- (void)goAllShopView{
    self.btnCatetorySelect.selected = NO;
    [  self.btnCatetorySelect setTitleColor:RGB(181, 181, 181)forState:UIControlStateNormal];
    _viewCollectionHead.frame = CGRectMake(0,0, kScreenWidth, 55);
    BuildingStoreDetail *storeDetail =_arrStoreData[0];
    AllPackageViewController *view = [[AllPackageViewController alloc] initWithNibName:@"AllPackageViewController" bundle:nil];
    view.storeId = _storeId;
    view.storeName = storeDetail.storeName;
    view.storeCategory = self.sortShopDataName;
    view.storeCategoryArr = self.sortShopNum;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark -动画
- (void)moveanimations{
    float hight = self.viewSelectShow.frame.size.height;
    CGRect frame = self.viewSelectShow.frame;
    frame.size.height = 0;
    self.viewSelectShow.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.viewSelectShow.frame;
        frame.size.height = hight;
        self.viewSelectShow.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if (tableView == self.tableView) {
        return _arrStoreCaseData.count;
    }else if (tableView == self.tableViewComment) {
        return _arrStoreCommentData.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
  
    if (tableView == self.tableView) {
        static NSString * wonderfulCaseCell = @"WonderfulCaseTableViewCell";
        WonderfulCaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:wonderfulCaseCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"WonderfulCaseTableViewCell" bundle:nil] forCellReuseIdentifier:wonderfulCaseCell];
            cell = [tableView dequeueReusableCellWithIdentifier:wonderfulCaseCell];
        }
        cell.viewCheckAllCase.hidden = YES;
        if (indexPath.row == (_arrStoreCaseData.count-1)) {
            cell.viewCheckAllCase.hidden = NO;
        }
        cell.viewTopLine.hidden = NO;
        if (indexPath.row == 0) {
            cell.viewTopLine.hidden = YES;
        }
        BuildingExample *buildingExample = _arrStoreCaseData[indexPath.row];
        [cell loadData:buildingExample];
        [cell.btnAllWatch addTarget:self action:@selector(btnWatchAllCase) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAllWatch setTitle:[NSString stringWithFormat:@"查看全部%@个案例...",_allCaseNum] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.tableViewComment) {
        static NSString * commentCell = @"CompanyCommentCell";
        CompanyCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CompanyCommentCell" bundle:nil] forCellReuseIdentifier:commentCell];
            cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.imageView1.userInteractionEnabled = YES;
        cell.imageView1.tag = indexPath.row;
        UITapGestureRecognizer* enlarge_tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewOne:)];
        [cell.imageView1 addGestureRecognizer:enlarge_tap1];
        
        
        cell.imageView2.userInteractionEnabled = YES;
        cell.imageView2.tag = indexPath.row;
        UITapGestureRecognizer* enlarge_tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewTwo:)];
        [cell.imageView2 addGestureRecognizer:enlarge_tap2];
        
        
        cell.imageView3.userInteractionEnabled = YES;
        cell.imageView3.tag = indexPath.row;
        UITapGestureRecognizer* enlarge_tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewThree:)];
        [cell.imageView3 addGestureRecognizer:enlarge_tap3];
        
        StoreComment *StoreComment = _arrStoreCommentData[indexPath.row];
        NSArray *imgs = StoreComment.imgs;
        if (imgs.count == 0) {
            [cell.imageView1 removeGestureRecognizer:enlarge_tap1];
            [cell.imageView2 removeGestureRecognizer:enlarge_tap2];
            [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
        }else if (imgs.count == 1){
            [cell.imageView2 removeGestureRecognizer:enlarge_tap2];
            [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
        }else if (imgs.count == 2){
            [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
        }
        [cell loadData:StoreComment];
        return cell;
    }
   
    return nil;
    
}

#pragma mark- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (_arrStoreCaseData.count == 0) {
            return 0;
        }
        return 55;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_arrStoreCaseData.count == 0) {
        return nil;
    }
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    topView.backgroundColor= RGB(244, 244, 244);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 44)];
    headView.backgroundColor= [UIColor whiteColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 100, 44)];
    labelTitle.textColor = RGB(51, 51, 51);
    labelTitle.backgroundColor = [UIColor whiteColor];
    labelTitle.text = @"精彩案例";
    labelTitle.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *labelAn = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 16, 16)];
    labelAn.textColor = [UIColor whiteColor];
    labelAn.backgroundColor = RGB(90, 183, 255);
    labelAn.text = @"案";
    labelAn.font = [UIFont systemFontOfSize:11.0];
    labelAn.textAlignment = UITextAlignmentCenter;
    
    
    UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-130, 10, 120, 44)];
    labelNum.textAlignment = UITextAlignmentRight;
    labelNum.font = [UIFont systemFontOfSize:12.0];
    NSString * commmentNum = [NSString stringWithFormat:@"全部%@个案例",_allCaseNum];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0,2)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(2,_allCaseNum.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(2+_allCaseNum.length,3)];
    labelNum.attributedText = attrString;
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 54, kScreenWidth, 1)];
    lineBottom.backgroundColor = RGB(221, 221, 221);


    [headView addSubview:topView];
    [headView addSubview:labelAn];
    [headView addSubview:labelNum];
    [headView addSubview:labelTitle];
    [headView addSubview:lineBottom];
    return headView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        if (indexPath.row == (_arrStoreCaseData.count - 1)) {
            return 296;
        }
        return 253;
    }else if (tableView == self.tableViewComment) {
        StoreComment *storeComment = _arrStoreCommentData[indexPath.row];
        float commentHeight = 100;
        if (storeComment.rrContent != nil) {
            CGSize contentSize = [storeComment.rrContent boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:15]}
                                                                      context:nil].size;
            if (storeComment.imgs.count == 0) {
                commentHeight = 88 + contentSize.height;
            }else{
                commentHeight = 177 + contentSize.height;
            }
        }
        return commentHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        BuildingExample *exampleData = _arrStoreCaseData[indexPath.row];
        CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
        view.albumId = exampleData.albumId;
        [self.navigationController pushViewController:view animated:YES];
    }else if (tableView == self.tableViewComment) {
        StoreComment *storeComment = _arrStoreCommentData[indexPath.row];
        CompanyAllCommentViewController *view = [[CompanyAllCommentViewController alloc] initWithNibName:@"CompanyAllCommentViewController" bundle:nil];
        view.storeComment = storeComment;
        view.showType = @"0";
        view.storeId = _storeId;
        [self.navigationController pushViewController:view animated:YES];
    }
 
}

#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{

    return _arrStoreShopData.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
   
    GoodsDetail *goodsDetail = _arrStoreShopData[indexPath.row];
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
    NSArray *imgs = goodsDetail.imgs;
    NSString *imgStr = @" ";
    if (imgs.count > 0) {
        imgStr = imgs[0];
    }
    [cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:PLUSPLACEHOLDERIMG]];
    
    cell.viewMember.hidden = YES;
    if([goodsDetail.huiyuanjie integerValue] == 1){
        cell.viewMember.hidden = NO;
    }
    
    return cell;
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewOne:(UITapGestureRecognizer*)Tap{

    StoreComment *storeComment = _arrStoreCommentData[Tap.view.tag];
    NSArray *imgs = storeComment.imgs;
    
      NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:0];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewTwo:(UITapGestureRecognizer*)Tap{
    
    StoreComment *storeComment = _arrStoreCommentData[Tap.view.tag];
    NSArray *imgs = storeComment.imgs;
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:1];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewThree:(UITapGestureRecognizer*)Tap{
    
    StoreComment *storeComment = _arrStoreCommentData[Tap.view.tag];
    NSArray *imgs = storeComment.imgs;
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:2];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

#pragma mark- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetail *goodsDetail = _arrStoreShopData[indexPath.row];
    //团
    if (goodsDetail.tuan && [goodsDetail.tuan[@"tuaning"] boolValue] == YES) {
        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
        viewControler.productId = goodsDetail.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    } else {
        RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
        viewControler.productId = goodsDetail.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    //创建collectionView
    CGFloat itemWidth = kScreenWidth / 2 ;
    
    return CGSizeMake(itemWidth-15, 258);
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
                                                
                                                weakSelf.arrStoreData = [request.resultDic objectForKey:@"BuildingStoreDetail"];
                                                [self setHeadUi];
                                                [self setMianUi:nil];
                                                NSLog(@"***==%@",weakSelf.arrStoreData);
                                            }
                                            
                                        }
                                        onRequestCanceled:^(CIWBaseDataRequest *request) {
                                            
                                        }
                                          onRequestFailed:^(CIWBaseDataRequest *request) {
                                              
                                          }];
}

// 精彩案例
- (void)getBuildingStoreCaseData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
    [parameters setValue:@0 forKey:@"page"];
    [parameters setValue:@3 forKey:@"size"];

    __weak typeof(self) weakSelf = self;
    [GetMallExampleListRequest requestWithParameters:parameters
                                           withCacheType:DataCacheManagerCacheTypeMemory
                                       withIndicatorView:self.view
                                       withCancelSubject:[GetMallExampleListRequest getDefaultRequstName]
                                          onRequestStart:nil
                                       onRequestFinished:^(CIWBaseDataRequest *request) {
                                           
                                           if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                                weakSelf.arrStoreCaseData = [request.resultDic objectForKey:@"example"];
                                                [weakSelf.tableView reloadData];
                                           }
                                           weakSelf.allCaseNum = [request.resultDic objectForKey:@"total"];
                                           
                                       }
                                       onRequestCanceled:^(CIWBaseDataRequest *request) {
                                           
                                       }
                                         onRequestFailed:^(CIWBaseDataRequest *request) {
                                             
                                         }];
}

// 精彩商品
- (void)getBuildingStoreShopData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
    //[parameters setValue:@"44017" forKey:@"store_id"];
    [parameters setValue:@"" forKey:@"scate_ids"];
    [parameters setValue:@0 forKey:@"page"];
    [parameters setValue:@6 forKey:@"size"];

    __weak typeof(self) weakSelf = self;
    [getProductStoreCateogry requestWithParameters:parameters
                                       withCacheType:DataCacheManagerCacheTypeMemory
                                   withIndicatorView:self.view
                                   withCancelSubject:[getProductStoreCateogry getDefaultRequstName]
                                      onRequestStart:nil
                                   onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                           weakSelf.arrStoreShopData = [request.resultDic objectForKey:@"goodsDetail"];
                                          [self setMianUi:nil];
                                       }
                                       
                                       [weakSelf.btnCheckAllShop setTitle:[NSString stringWithFormat:@"查看全部%@个套餐...",request.resultDic[@"total"]] forState:UIControlStateNormal];
                                       
                                   }
                                   onRequestCanceled:^(CIWBaseDataRequest *request) {
                                       
                                   }
                                     onRequestFailed:^(CIWBaseDataRequest *request) {
                                         
                                     }];
}

// 用户评论
- (void)getBuildingStoreCommentDataPage:(NSInteger)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
   // [parameters setValue:@"44017" forKey:@"store_id"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@3 forKey:@"size"];
    
    __weak typeof(self) weakSelf = self;
    [GetMallDpCommentListRequest requestWithParameters:parameters
                                         withCacheType:DataCacheManagerCacheTypeMemory
                                     withIndicatorView:self.view
                                     withCancelSubject:[GetMallDpCommentListRequest getDefaultRequstName]
                                        onRequestStart:nil
                                     onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                             weakSelf.pageComment = page;
                                             if (weakSelf.pageComment == 0) {
                                                 weakSelf.arrStoreCommentData = [NSMutableArray array];
                                             }
                                             
                                             NSArray *array = [request.resultDic objectForKey:@"storeComment"];
                                             if (array.count > 0) {
                                                 [weakSelf.arrStoreCommentData addObjectsFromArray:array];
                                             }
                                                                                     
                                             float tableViewSizeHeight = self.tableView.contentSize.height ;
                                             
                                             [self setMianUi:nil];
                                             [weakSelf.tableViewComment reloadData];
                                             
                                             //条数
                                             NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                             if(page != 0){
                                                 if(array.count == 0){
                                                     if (weakSelf.arrStoreCommentData.count >= total) {
                                                          [MessageView displayMessage:@"没有更多评论!"];
                                                     }
                                                 }

                                                 CGPoint offset = CGPointMake(0, tableViewSizeHeight - self.tableView.frame.size.height);
                                                 [self.tableView setContentOffset:offset animated:NO];
                                             }

                                         }

                                     }
                                     onRequestCanceled:^(CIWBaseDataRequest *request) {
                                         
                                     }
                                       onRequestFailed:^(CIWBaseDataRequest *request) {
                                           
                                       }];
}

// 店铺分类
- (void)getStoreCategoryData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:_storeId forKey:@"store_id"];
    __weak typeof(self) weakSelf = self;
    [GetMallStoreCategory requestWithParameters:parameters
                                  withCacheType:DataCacheManagerCacheTypeMemory
                              withIndicatorView:self.view
                              withCancelSubject:[GetMallStoreCategory getDefaultRequstName]
                                 onRequestStart:nil
                              onRequestFinished:^(CIWBaseDataRequest *request) {
                                  
                                  if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                      
                                      weakSelf.arrStoreCategoryData = [request.resultDic objectForKey:@"StoreCategory"];
                                      
                                  }
                                  
                              }
                              onRequestCanceled:^(CIWBaseDataRequest *request) {
                                  
                              }
                                onRequestFailed:^(CIWBaseDataRequest *request) {
                                    
                                }];
}



@end
