//
//  CouponDetailViewController.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "GetMallCouponDetailRequest.h"
#import "CouponMall.h"
#import "ExchangeCouponRequest.h"
#import "MessageView.h"
#import "HomeContentView.h"
#import "Product.h"
#import "GroupProductDetailViewController.h"
#import "RenovationShopDetialViewController.h"
#import "CompanyHomeViewController.h"

#import "Growing.h"
@interface CouponDetailViewController () {
    //店铺
    __weak IBOutlet UIImageView *_imgViewLogo;
    __weak IBOutlet UILabel *_labelStoreName;
    __weak IBOutlet UILabel *_labelAddress;
    __weak IBOutlet UILabel *_labelTel;
    
    //限量 兑换
    __weak IBOutlet UILabel *_labelLimit;
    __weak IBOutlet UILabel *_labelReceive;
    __weak IBOutlet UILabel *_labelScore;
    
    //优惠券金额
    __weak IBOutlet UIView *_viewLevel;
    __weak IBOutlet UILabel *_labelNew;
    __weak IBOutlet UILabel *_labelOld;
    __weak IBOutlet UILabel *_labelVip;
    __weak IBOutlet UILabel *_labelGold;
    
    __weak IBOutlet UILabel *_labelRuleNew;
    __weak IBOutlet UILabel *_labelRuleOld;
    __weak IBOutlet UILabel *_labelRuleVip;
    __weak IBOutlet UILabel *_labelRuleGold;
    
    // 固定金额
    __weak IBOutlet UIView *_viewFixPrice;
    __weak IBOutlet UILabel *_labelPrice;
    
    //好评
    __weak IBOutlet UILabel *_labelPraise;
    
    //点评
    __weak IBOutlet UILabel *_labelComment;
    
    //使用规则
    __weak IBOutlet UILabel *_labelRuleTitle;
    __weak IBOutlet UIView *_viewRuleLine;
    
    //为你推荐
    __weak IBOutlet UILabel *_labelRecommTitle;
    __weak IBOutlet UIView *_viewRecommLine;
    
    //使用范围
    __weak IBOutlet UILabel *_labelRange;
    
    //规则提醒
    __weak IBOutlet UILabel *_labelRule;
    
    //详细说明
    __weak IBOutlet UILabel *_labelDetail;
    
    __weak IBOutlet UIView *_viewDetailedDesc;
    __weak IBOutlet UIView *_viewProduct;
    __weak IBOutlet NSLayoutConstraint *_heightForProduct;
    __weak IBOutlet NSLayoutConstraint *_bottomForProduct;
    __weak IBOutlet NSLayoutConstraint *_bottomForDetail;
    
    //下部领取部分
    __weak IBOutlet UILabel *_labelUserPrice;
    __weak IBOutlet UILabel *_labelUserLevel;
    
    __weak IBOutlet UIView *_viewLogin;
}

@property (nonatomic, strong) CouponMall *couponDetail;

@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getCouponDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.growingAttributesPageName=@"cashDetail_ios";
    if (!DATA_ENV.isLogin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserInfo) name:@"userLogined" object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getCouponDetail {
    __weak typeof(self) weakSelf = self;
    [GetMallCouponDetailRequest requestWithParameters:@{@"cash_coupon_id":self.cashCouponId}// 参数
                                    withIndicatorView:self.view//网络加载视图加载到某个view
                                       onRequestStart:^(CIWBaseDataRequest *request) {}
                                    onRequestFinished:^(CIWBaseDataRequest *request) {
                                        
                                        if([request.errCode isEqualToString:RESPONSE_OK]){
                                            weakSelf.couponDetail = [request.resultDic objectForKey:KEY_COUPONDETAIL];
                                            
                                            [weakSelf showCouponDetail];
                                        }
                                    }
                                    onRequestCanceled:^(CIWBaseDataRequest *request) {
                                    }
                                      onRequestFailed:^(CIWBaseDataRequest *request) {
                                      }];
}

- (void)showCouponDetail {
    if (!self.couponDetail) {
        return;
    }
    
    //店铺
    [_imgViewLogo sd_setImageWithURL:[NSURL URLWithString:_couponDetail.imgUrl] placeholderImage:[UIImage imageNamed:@"正小"]];
    _labelStoreName.text = _couponDetail.title;
    _labelAddress.text = _couponDetail.store.address;
    _labelTel.text = _couponDetail.store.tel;
    
    //限量 兑换
    _labelLimit.text = [NSString stringWithFormat:@"・限量%@份", _couponDetail.totalCount];
    _labelReceive.text = [NSString stringWithFormat:@"・%@人已兑换", _couponDetail.receiveCount];
    _labelScore.text = [NSString stringWithFormat:@"・%@积分兑换", _couponDetail.score];;
    
    if ([self.couponDetail.exchangeType integerValue] == 1) {
        // 固定金额
        _viewLevel.hidden = YES;
        _viewFixPrice.hidden = NO;
        _labelPrice.text = [NSString stringWithFormat:@"%@现金券", [_couponDetail.levelPrices getDisplayPrices]];
    } else {
        //优惠券金额
        _viewFixPrice.hidden = YES;
        _viewLevel.hidden = NO;
        _labelNew.text = _couponDetail.levelPrices.priceNew;
        _labelOld.text = _couponDetail.levelPrices.priceOld;
        _labelVip.text = _couponDetail.levelPrices.priceVip;
        _labelGold.text = _couponDetail.levelPrices.priceGold;
        
        if ([self.couponDetail.exchangeType integerValue] == 2) {
            //消费金额
            _labelRuleNew.text = [NSString stringWithFormat:@"满%@可用", _couponDetail.meetRule.priceNew];
            _labelRuleOld.text = [NSString stringWithFormat:@"满%@可用", _couponDetail.meetRule.priceOld];
            _labelRuleVip.text = [NSString stringWithFormat:@"满%@可用", _couponDetail.meetRule.priceVip];
            _labelRuleGold.text = [NSString stringWithFormat:@"满%@可用", _couponDetail.meetRule.priceGold];
        }
    }

    //好评
    if (_couponDetail.store && _couponDetail.store.rateBest) {
        _labelPraise.text = _couponDetail.store.rateBest;
    }
    
    //点评
    if (_couponDetail.store && _couponDetail.store.dpCount) {
        _labelComment.text = [NSString stringWithFormat:@"共%@条订单点评", _couponDetail.store.dpCount];
    }
    
    //使用范围
    _labelRange.text = _couponDetail.range.content;
    
    //规则提醒
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_couponDetail.rulesRemind.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_couponDetail.rulesRemind.content length])];
    
    _labelRule.attributedText = attributedString;
    
    //详细说明
    NSString *content = [_couponDetail.detailedDesc.content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    _labelDetail.attributedText = attributedString;

    //为你推荐商品表示
    [self showProductList];
    
    //画面下部表示
    [self showUserInfo];
}

- (void)showProductList {
    [_viewProduct removeAllSubviews];
    if (self.couponDetail.productList.count == 0) {
        return;
    }
    
    CGFloat _y = 10;
    CGFloat _x = 10;
    CGFloat _w = (kScreenWidth - 25) / 2;
    CGFloat _h = 0;
    
    for (int i = 0; i<self.couponDetail.productList.count; i++) {
        _x = 10 + i%2 * (_w + 5);
        
        Product *product = [self.couponDetail.productList objectAtIndex:i];
        
        if (i%2 == 0) {
            NSMutableArray *array = [@[product.productName] mutableCopy];
            if (i<self.couponDetail.productList.count - 1) {
                Product *product2 = [self.couponDetail.productList objectAtIndex:i + 1];
                [array addObject:product2.productName];
            }
            
            _h = [self getProductHeight:array];
        }
        
        HomeContentView *productView = [HomeContentView instanceProductView];
        productView.frame = CGRectMake(_x, _y, _w, _h);
        productView.controlPro.tag = i;
        [productView.controlPro addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [productView.imgViewProPic sd_setImageWithURL:[NSURL URLWithString:product.productPicUrl] placeholderImage:[UIImage imageNamed:@"正中"]];
        productView.labelProName.text = product.productName;
        
        if (![CommonUtil isEmpty:product.mallPrice]) {
            productView.labelPrice.text = [NSString stringWithFormat:@"￥%@", product.mallPrice];
        } else {
            productView.labelPrice.text = @"";
        }
        
        if (![CommonUtil isEmpty:product.price]) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", product.price]
                                                                          attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
                                                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                        NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
            
            productView.labelOriginal.attributedText = attrStr;
        } else {
            productView.labelOriginal.text = @"";
        }
        
        if ([product.huiyuanjie boolValue] == YES) {
            productView.viewMark.hidden = NO;
        } else {
            productView.viewMark.hidden = YES;
        }
        
        [_viewProduct addSubview:productView];
        
        //下一行
        if (i%2 == 1) {
            _y = _y + _h + 10;
        }
    }
    
    //单数时
    if (self.couponDetail.productList.count%2 == 1) {
        _y = _y + _h + 10;
    }
    
    _heightForProduct.constant = _y;
}

- (CGFloat)getProductHeight:(NSArray *)array {
    
    CGFloat width = (kScreenWidth - 25) / 2;
    
    CGFloat _height = 0;
    for (NSString *name in array) {
        _height = MAX([name getSizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(width - 10, 60)].height, _height);
    }
    
    if (_height > 20) {
        return width + 77 + 16;
    } else {
        return width + 77;
    }
}

//商品详细表示
- (void)productClicked:(UIControl *)control {
    
    Product *product = [self.couponDetail.productList objectAtIndex:control.tag];

    //团
    if ([product.tuaning boolValue] == YES) {
        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
        viewControler.productId = product.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    } else {
        RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
        viewControler.productId = product.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    }
}

- (void)showUserInfo {
    //下部领取部分
    if (DATA_ENV.isLogin) {
        _viewLogin.hidden = YES;
        if ([self.couponDetail.exchangeType isEqualToString:@"1"]) {
            // 固定金额
            _labelUserPrice.text = [_couponDetail.levelPrices getDisplayPrices];
            _labelUserLevel.hidden = YES;
        } else {
            _labelUserLevel.hidden = NO;
            if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"new"]) {
                _labelUserPrice.text = _couponDetail.levelPrices.priceNew;
                _labelUserLevel.text = @"(您是新会员)";
            } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"old"]) {
                _labelUserPrice.text = _couponDetail.levelPrices.priceOld;
                _labelUserLevel.text = @"(您是老会员)";
            } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"vip"]) {
                _labelUserPrice.text = _couponDetail.levelPrices.priceVip;
                _labelUserLevel.text = @"(您是VIP会员)";
            } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"gold"]) {
                _labelUserPrice.text = _couponDetail.levelPrices.priceGold;
                _labelUserLevel.text = @"(您是金卡会员)";
            }
        }
    } else {
        _viewLogin.hidden = NO;
    }
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//使用规则  为你推荐
- (IBAction)ruleAndRecommClicked:(UIControl *)control {
    if (control.tag == 0) {
        _labelRuleTitle.textColor = RGBFromHexColor(0x601986);
        _viewRuleLine.hidden = NO;
        _viewDetailedDesc.hidden = NO;
        _bottomForDetail.priority = UILayoutPriorityDefaultHigh;
        
        _labelRecommTitle.textColor = RGBFromHexColor(0x666666);
        _viewRecommLine.hidden = YES;
        _viewProduct.hidden = YES;
        _bottomForProduct.priority = UILayoutPriorityDefaultLow;
    } else {
        _labelRuleTitle.textColor = RGBFromHexColor(0x666666);
        _viewRuleLine.hidden = YES;
        _viewDetailedDesc.hidden = YES;
        _bottomForDetail.priority = UILayoutPriorityDefaultLow;
        
        _labelRecommTitle.textColor = RGBFromHexColor(0x601986);
        _viewRecommLine.hidden = NO;
        _viewProduct.hidden = NO;
        _bottomForProduct.priority = UILayoutPriorityDefaultHigh;
    }
}

//立即领取
- (IBAction)btnReceiveClicked:(id)sender {
    if (!DATA_ENV.isLogin) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [ExchangeCouponRequest requestWithParameters:@{@"cash_coupon_id":_cashCouponId}// 参数
                               withIndicatorView:self.view//网络加载视图加载到某个view
                                  onRequestStart:^(CIWBaseDataRequest *request) {}
                               onRequestFinished:^(CIWBaseDataRequest *request) {
                                   
                                   if([request.errCode isEqualToString:RESPONSE_OK]){
                                       [MessageView displayMessage:weakSelf.couponDetail.successDesc];
                                   } else {
                                       [MessageView displayMessageByErr:request.errCode];
                                   }
                               }
                               onRequestCanceled:^(CIWBaseDataRequest *request) {
                               }
                                 onRequestFailed:^(CIWBaseDataRequest *request) {
                                 }];
    
}

//订单点评
- (IBAction)commentClicked:(id)sender {
    NSString *storeId = _couponDetail.store.storeId;
    CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
    view.storeId = storeId;
    [self.navigationController pushViewController:view animated:YES];
}

@end
