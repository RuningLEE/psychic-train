//
//  GroupProductDetailViewController.m
//  jiabasha
//
//  Created by guok on 17/1/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GroupProductDetailViewController.h"
#import "ProductDetail.h"
#import "GetRenovationShopDetialRequest.h"
#import "LCBannerView.h"
#import "DecorationPackageCell.h"
#import "GoodsDetail.h"
#import "RenovationShopDetialViewController.h"
#import "RenovationCompanyHomeViewController.h"
#import "ShoppingGroupViewController.h"
#import "ShareViewController.h"

@interface GroupProductDetailViewController ()<LCBannerViewDelegate> {
    __weak IBOutlet UIView *_viewBanner;
    
    //商品名称
    __weak IBOutlet UILabel *_lableProductName;
    
    //当前价
    __weak IBOutlet UILabel *_labelCurrentPrice;
    
    //原价
    __weak IBOutlet UILabel *_labelOrigPrice;
    
    __weak IBOutlet UILabel *_labelOrigPriceTitle;
    //拼团提示［还差99人，即可享最高成团价2999元］
    __weak IBOutlet UILabel *_labelMsg;
    
    //报名人数
    __weak IBOutlet UILabel *_labelJoins;
    
    //成团进度条
    __weak IBOutlet UILabel *_labelPeoples1;
    __weak IBOutlet UILabel *_labelPeoples2;
    __weak IBOutlet UILabel *_labelPeoples3;
    __weak IBOutlet UILabel *_labelPeoples4;
    __weak IBOutlet UILabel *_labelPeoples5;
    
    __weak IBOutlet UILabel *_labelPrice1;
    __weak IBOutlet UILabel *_labelPrice2;
    __weak IBOutlet UILabel *_labelPrice3;
    __weak IBOutlet UILabel *_labelPrice4;
    __weak IBOutlet UILabel *_labelPrice5;
    
    __weak IBOutlet UIView *_viewDot1;
    __weak IBOutlet UIView *_viewDot2;
    __weak IBOutlet UIView *_viewDot3;
    __weak IBOutlet UIView *_viewDot4;
    __weak IBOutlet UIView *_viewDot5;
    
    // 点的位置
    __weak IBOutlet NSLayoutConstraint *_leadForDoit2;
    __weak IBOutlet NSLayoutConstraint *_leadForDoit4;
    __weak IBOutlet NSLayoutConstraint *_widthOfJoins;
    
    //剩余时间
    __weak IBOutlet UILabel *_labelTime;
    
    //店铺
    __weak IBOutlet UIImageView *_imgViewStoreLogo;
    __weak IBOutlet UILabel *_labelStoreName;
    __weak IBOutlet UILabel *_labelDpOrder;
    __weak IBOutlet UILabel *_labelOrderNum;
    __weak IBOutlet UILabel *_labelDpCount;
    
    //详情
    __weak IBOutlet UIButton *_btnDetail;
    __weak IBOutlet UIView *_viewDetailContainer;
    
    __weak IBOutlet UIWebView *_webViewDetail;
    __weak IBOutlet NSLayoutConstraint *_heightOfDetail;

    //参数
    __weak IBOutlet UIButton *_btnAttr;
    __weak IBOutlet UIView *_viewAttrContainer;
    __weak IBOutlet NSLayoutConstraint *_heightOfAttr;

    //推荐
    __weak IBOutlet UIButton *_btnRecommend;
    __weak IBOutlet UIView *_viewRecomContainer;
    __weak IBOutlet NSLayoutConstraint *_heightOfRecom;
    __weak IBOutlet UICollectionView *_collectionView;
    
    //下画线对齐
    __weak IBOutlet NSLayoutConstraint *_centerToDetail;
    __weak IBOutlet NSLayoutConstraint *_centerToAttr;
    __weak IBOutlet NSLayoutConstraint *_centerToRecom;
    
    //下边距
    __weak IBOutlet NSLayoutConstraint *_bottomOfDetail;
    __weak IBOutlet NSLayoutConstraint *_bottomOfAttr;
    __weak IBOutlet NSLayoutConstraint *_bottomOfRecom;
    
    //下部
    __weak IBOutlet UILabel *_labelPriceFix;
    __weak IBOutlet UILabel *_labelJoinsFix;
}


@property (nonatomic, strong) ProductDetail *productDetail;

@end

@implementation GroupProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat itemWidth = kScreenWidth / 2;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemWidth-12.5, 258);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 12.5, 10, 12.5);
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView registerClass:[DecorationPackageCell class] forCellWithReuseIdentifier:@"DecorationPackageCell"];
    
    [self getProductDetailData];
}

#pragma mark - private
// 取商品数据
- (void)getProductDetailData {
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
                                                
                                                weakSelf.productDetail = [request.resultDic objectForKey:@"productDetail"];
                                                [weakSelf displayProductDetail];
                                            } else {
                                                [MessageView displayMessageByErr:request.errCode];
                                            }
                                        }
                                        onRequestCanceled:^(CIWBaseDataRequest *request) {
                                            
                                        }
                                          onRequestFailed:^(CIWBaseDataRequest *request) {
                                              
                                          }];
}

//显示商品详情
- (void)displayProductDetail {
    if (!self.productDetail) {
        return;
    }
    
    //轮播图
    NSArray *imageArr = _productDetail.imgs;
    NSInteger time1;
    if (imageArr.count == 0) {
        imageArr = [NSArray arrayWithObject:@""];
    }
    if (imageArr.count>1) {
        time1=2.0;
    }else{
        time1=100000;
    }
    //轮播图
    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 662 / 750)
                                                        delegate:self
                                                       imageURLs:imageArr
                                            placeholderImageName:@"正大"
                                                    timeInterval:time1
                                   currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                          pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
    bannerView.tag = 1;
    [_viewBanner addSubview:bannerView];
    
    //商品名称
    _lableProductName.text = _productDetail.productName;
    
    //当前价
    if ([CommonUtil isEmpty:_productDetail.mallPrice]) {
        _labelCurrentPrice.text = @"面议";
    } else {
        _labelCurrentPrice.text = [NSString stringWithFormat:@"￥%@", _productDetail.mallPrice];
    }
    
    //原价
    if ([CommonUtil isEmpty:_productDetail.price]) {
        _labelOrigPriceTitle.hidden = YES;
        _labelOrigPrice.text = @"";
    } else {
        _labelOrigPriceTitle.hidden = NO;
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", _productDetail.price]
                                                                      attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17.f],
                                                                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        
        _labelOrigPrice.attributedText = attrStr;
    }
    
    //拼团提示［还差99人，即可享最高成团价2999元］
    NSInteger num = [_productDetail.tuanMaxNum integerValue] - [_productDetail.tuanOrderCnt integerValue];
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还差%ld人，即可享最高成团价", num]];
    
    //最高成团价
    NSString *price = @"0";
    
    //当前价
    NSString *currectPrice = _productDetail.tuanPrice;
    if ([CommonUtil isEmpty:_productDetail.tuanPrice]) {
        currectPrice = _productDetail.mallPrice;
    }
    
    for (int i = 0; i<_productDetail.tuanSetting.tuanPrices.count; i++) {
        TuanPrice *tuanPrice = [_productDetail.tuanSetting.tuanPrices objectAtIndex:i];
        price = tuanPrice.price;
        if ([tuanPrice.num integerValue] > [_productDetail.tuanOrderCnt integerValue]) {
//            break;
        } else {
            currectPrice = tuanPrice.price;
        }
        
        if (i == 0 && [CommonUtil isEmpty:currectPrice]) {
            currectPrice = tuanPrice.price;
        }
    }
    NSAttributedString *priceattr = [[NSAttributedString alloc] initWithString:price attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
    
    [msg appendAttributedString:priceattr];
    [msg appendAttributedString:[[NSAttributedString alloc] initWithString:@"元"]];
    
    _labelMsg.attributedText = msg;
    
    //报名人数
    _labelJoins.text = _productDetail.tuanOrderCnt;
    
    //成团进度条
    _leadForDoit2.constant = (kScreenWidth - 90)/4;
    _leadForDoit4.constant = (kScreenWidth - 90)/4;

    //非等比时不正确
//    if ([_productDetail.tuanMaxNum integerValue] > 0) {
//        _widthOfJoins.constant = (kScreenWidth - 40) * [_productDetail.tuanOrderCnt integerValue] / [_productDetail.tuanMaxNum integerValue];
//    } else {
//        _widthOfJoins.constant = kScreenWidth - 40;
//    }
    _widthOfJoins.constant = 0;
    
    NSArray *peoples = @[_labelPeoples1, _labelPeoples2, _labelPeoples3, _labelPeoples4, _labelPeoples5];
    NSArray *prices = @[_labelPrice1, _labelPrice2, _labelPrice3, _labelPrice4, _labelPrice5];
    
    NSArray *viewDots = @[_viewDot1, _viewDot2, _viewDot3, _viewDot4, _viewDot5];

    for (int i = 0; i<_productDetail.tuanSetting.tuanPrices.count && i<5; i++) {
        TuanPrice *tuanPrice = [_productDetail.tuanSetting.tuanPrices objectAtIndex:i];
        
        ((UILabel *)peoples[i]).text = [NSString stringWithFormat:@"%@人", tuanPrice.num];
        ((UILabel *)prices[i]).text = [NSString stringWithFormat:@"￥%@", tuanPrice.price];
        
        if ([_productDetail.tuanOrderCnt integerValue] >= [tuanPrice.num integerValue]) {
            ((UIView *)viewDots[i]).backgroundColor = [UIColor colorWithHexString:@"#906AA5"];
            
            _widthOfJoins.constant = 10 + (10 + (kScreenWidth - 90)/4) *i;
        } else {
            ((UIView *)viewDots[i]).backgroundColor = [UIColor whiteColor];
            
            if (i > 0) {
                TuanPrice *tuanPricePer = [_productDetail.tuanSetting.tuanPrices objectAtIndex:i-1];
                if ([_productDetail.tuanOrderCnt integerValue] > [tuanPricePer.num integerValue]
                    && [tuanPrice.num integerValue] > [tuanPricePer.num integerValue]) {
                    _widthOfJoins.constant = _widthOfJoins.constant + (kScreenWidth - 90)/4 * ([_productDetail.tuanOrderCnt integerValue] - [tuanPricePer.num integerValue])/ ([tuanPrice.num integerValue] - [tuanPricePer.num integerValue]);
                }
            }
            
        }
    }
    
    //剩余时间 [28小时28分钟28秒]
    NSTimeInterval value = [_productDetail.tuanSetting.end doubleValue] - [[NSDate date] timeIntervalSince1970];
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    house = house + day * 24;
    
    NSMutableAttributedString *time = [[NSMutableAttributedString alloc] initWithString:@"剩余："];
    if (house > 0) {
        NSAttributedString *houseAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", house] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        
        [time appendAttributedString:houseAttr];
        [time appendAttributedString:[[NSAttributedString alloc] initWithString:@"小时"]];
    }
    if (minute > 0) {
        NSAttributedString *minuteAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", minute] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        
        [time appendAttributedString:minuteAttr];
        [time appendAttributedString:[[NSAttributedString alloc] initWithString:@"分钟"]];
    }
    if (second > 0) {
        NSAttributedString *secondAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", second] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        
        [time appendAttributedString:secondAttr];
        [time appendAttributedString:[[NSAttributedString alloc] initWithString:@"秒"]];
    }
    _labelTime.attributedText = time;
    
    //店铺
    if (_productDetail.store) {
        [_imgViewStoreLogo sd_setImageWithURL:[NSURL URLWithString:_productDetail.store[@"logo"]] placeholderImage:[UIImage imageNamed:@"正小"]];
        _labelStoreName.text = [_productDetail.store objectForKey:@"store_name"];
        
        NSString *value = [CommonUtil getNumDefaultZero:[_productDetail.store objectForKey:@"dp_order"]];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"点评" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}]];
        _labelDpOrder.attributedText = attr;
        
        value = [CommonUtil getNumDefaultZero:[_productDetail.store objectForKey:@"order_num"]];
        attr = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"预约" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}]];
        _labelOrderNum.attributedText = attr;
        
        value = [CommonUtil getNumDefaultZero:[_productDetail.store objectForKey:@"dp_count"]];
        attr = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF3B30"]}];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"签单" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}]];
        _labelDpCount.attributedText = attr;
    }

    //详情
    [self displayProductContent];
    
    //参数
    [self displayProductAttr];
    
    //推荐
    [self displayProductGuess];

    //下部
    _labelPriceFix.text = [NSString stringWithFormat:@"￥%@", currectPrice];
    _labelJoinsFix.text = [NSString stringWithFormat:@"当前已有%@人预约", _productDetail.tuanOrderCnt];
}

//显示商品详情
- (void)displayProductContent {
    NSString *detail = _productDetail.content;

    if (![CommonUtil isEmpty:detail ]) {
        [_webViewDetail loadHTMLString:detail baseURL:nil];
    }
}

// 创建参数表
- (void)displayProductAttr{
    
    NSDictionary *attr = _productDetail.attr;
    NSArray* allKeysAttr = [attr allKeys];
    NSMutableArray *attrList = [NSMutableArray array];
    for (NSString *key in allKeysAttr) {
        [attrList addObject:attr[key]];
    }
    
    
    float totalHeight;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(10, 43, kScreenWidth- 20, 0)];
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
    
    [_viewAttrContainer addSubview:view];
    _heightOfAttr.constant = totalHeight + 50;
}

// 推荐
- (void)displayProductGuess{
    
    NSArray *guess = _productDetail.guess;
    _collectionView.frame = CGRectMake(0,0, kScreenWidth, 268 * ((guess.count+1)/2)+10 );
    _heightOfRecom.constant = _collectionView.height + 20;
    [_collectionView reloadData];
}

#pragma mark - UIWebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    _heightOfDetail.constant = webView.scrollView.contentSize.height + 50;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _heightOfDetail.constant = webView.scrollView.contentSize.height + 50;
}

#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    NSArray *guess = _productDetail.guess;
    return guess.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [GoodsDetail createModelsArrayByResults:_productDetail.guess];
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
    NSArray *arr = [GoodsDetail createModelsArrayByResults:_productDetail.guess];
    GoodsDetail *goodsDetail = arr[indexPath.row];
    
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

#pragma mark - Actions LCBannerViewDelegate
//轮播图点击
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    //查看大图
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
- (IBAction)btnShareClicked:(id)sender {

    NSString *imageurl = @"";
    if (_productDetail.imgs.count > 0) {
        imageurl = _productDetail.imgs[0];
    }
    NSString *link = [NSString stringWithFormat:@"http://h5.jiabasha.com/product/%@", _productDetail.productId];
    
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    viewController.shareContent = @{@"title":_productDetail.productName, @"logo":imageurl, @"link":link};
    
    UIViewController* controller = self.view.window.rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [controller presentViewController:viewController animated:YES completion:^{
        viewController.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

//点击 店铺信息 进入店铺画面
- (IBAction)btnStoreInfoClicked:(id)sender {
    RenovationCompanyHomeViewController *view = [[RenovationCompanyHomeViewController alloc] initWithNibName:@"RenovationCompanyHomeViewController" bundle:nil];
    view.storeId = _productDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

//详情 参数 推荐
- (IBAction)btnCategroyClicked:(UIButton *)button {
    
    if (button.isSelected) {
        return;
    }
    
    if (button == _btnDetail) {
        _btnDetail.selected = YES;
        _btnAttr.selected = NO;
        _btnRecommend.selected = NO;
        
        _viewDetailContainer.hidden = NO;
        _viewAttrContainer.hidden = YES;
        _viewRecomContainer.hidden = YES;
        
        //下画线对齐
        _centerToDetail.priority = UILayoutPriorityDefaultHigh;
        _centerToAttr.priority = UILayoutPriorityDefaultLow;
        _centerToRecom.priority = UILayoutPriorityDefaultLow;
        
        //下边距
        _bottomOfDetail.priority = UILayoutPriorityDefaultHigh;
        _bottomOfAttr.priority = UILayoutPriorityDefaultLow;
        _bottomOfRecom.priority = UILayoutPriorityDefaultLow;
        
    } else if (button == _btnAttr) {
        _btnDetail.selected = NO;
        _btnAttr.selected = YES;
        _btnRecommend.selected = NO;
        
        _viewDetailContainer.hidden = YES;
        _viewAttrContainer.hidden = NO;
        _viewRecomContainer.hidden = YES;
        
        //下画线对齐
        _centerToDetail.priority = UILayoutPriorityDefaultLow;
        _centerToAttr.priority = UILayoutPriorityDefaultHigh;
        _centerToRecom.priority = UILayoutPriorityDefaultLow;
        
        //下边距
        _bottomOfDetail.priority = UILayoutPriorityDefaultLow;
        _bottomOfAttr.priority = UILayoutPriorityDefaultHigh;
        _bottomOfRecom.priority = UILayoutPriorityDefaultLow;
    } else if (button == _btnRecommend) {
        _btnDetail.selected = NO;
        _btnAttr.selected = NO;
        _btnRecommend.selected = YES;
        
        _viewDetailContainer.hidden = YES;
        _viewAttrContainer.hidden = YES;
        _viewRecomContainer.hidden = NO;
        
        //下画线对齐
        _centerToDetail.priority = UILayoutPriorityDefaultLow;
        _centerToAttr.priority = UILayoutPriorityDefaultLow;
        _centerToRecom.priority = UILayoutPriorityDefaultHigh;
        
        //下边距
        _bottomOfDetail.priority = UILayoutPriorityDefaultLow;
        _bottomOfAttr.priority = UILayoutPriorityDefaultLow;
        _bottomOfRecom.priority = UILayoutPriorityDefaultHigh;
    }
}

//邀请好友一起参与
- (IBAction)btnInviteClicked:(id)sender {
}

//我要预约
- (IBAction)btnAppointClicked:(id)sender {
    if (DATA_ENV.isLogin) {
        ShoppingGroupViewController *viewController = [[ShoppingGroupViewController alloc] init];
        viewController.productDetail = self.productDetail;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
    }
    
}

@end
