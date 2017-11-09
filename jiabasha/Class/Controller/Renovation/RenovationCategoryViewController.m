//
//  RenovationCategoryViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Store.h"
#import "AdContent.h"
#import "MJRefresh.h"
#import "CateStore.h"
#import "GoodsDetail.h"
#import "LCBannerView.h"
#import "GetContentRequest.h"
#import "WebViewController.h"
#import "SearchStoreRequest.h"
#import "DecorationPackageCell.h"
#import "SearchProductRequest.h"
#import "GetRCategoryListRequest.h"
#import "getProductStoreCateogry.h"
#import "GroupProductDetailViewController.h"
#import "GetRCommonSearchProductRequest.h"
#import "ClassificationTableViewCell.h"
#import "RenovationCollectionReusableView.h"
#import "RenovationMerchantTableViewCell.h"
#import "RenovationCategoryViewController.h"
#import "RenovationCompanyHomeViewController.h"
#import "RenovationShopDetialViewController.h"

#import "UIView+GrowingAttributes.h"
#import "Growing.h"
//广告名称
#define mall_category_2004_1080x448 @"mall_category_2004_1080x448"  //商城-橱柜厨电-通栏-（导航下方）
#define mall_category_2003_1080x448 @"mall_category_2003_1080x448"  //商城-卫浴瓷砖-通栏-（导航下方）
#define mall_category_2005_1080x448 @"mall_category_2005_1080x448"  //商城-地板门窗-通栏-（导航下方）
#define mall_category_2006_1080x448 @"mall_category_2006_1080x448"  //商城-住宅家具-通栏-（导航下方）
#define mall_category_2008_1080x448 @"mall_category_2008_1080x448"  //商城-家居软装-通栏-（导航下方）
#define mall_category_2009_1080x448 @"mall_category_2009_1080x448"  //商城-基础建材-通栏-（导航下方）
#define mall_category_2010_1080x448 @"mall_category_2010_1080x448"  //商城-大家电-通栏-（导航下方）

@interface RenovationCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LCBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewStyleOne;
@property (weak, nonatomic) IBOutlet UITableView *tableViewStyleTwo;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSort;//

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *viewTableHead;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *viewShowSelect;

@property (weak, nonatomic) IBOutlet UIView *viewStyle;//
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStyle;
@property (weak, nonatomic) IBOutlet UIView *viewSort;//
@property (weak, nonatomic) IBOutlet UIButton *btnSort;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSort;
@property (weak, nonatomic) IBOutlet UIView *viewBanner;
@property (weak, nonatomic) IBOutlet UIImageView *imageDefault;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableOneH;

@property (strong, nonatomic) NSArray *sortData;
@property (strong, nonatomic) NSString *strSelectMerchantShop; // 0:商户 1:商品
@property (strong, nonatomic) NSString *strSelectStyleSort; // 0:分类 1:排序
@property (assign, nonatomic) NSInteger styleMerchantNum;   // 商户分类选择
@property (assign, nonatomic) NSInteger styleShopNum;      // 商品分类选择
@property (assign, nonatomic) NSInteger styleTwoMerchantNum;   // 商户分类选择2级
@property (assign, nonatomic) NSInteger styleTwoShopNum;      // 商品分类选择2级
@property (assign, nonatomic) NSInteger styleTureMerchantNum;   // 商户分类确认选择
@property (assign, nonatomic) NSInteger styleTureShopNum;      // 商品分类确认选择

@property (assign, nonatomic) NSInteger sortMerchantNum;    // 商户排序选择
@property (assign, nonatomic) NSInteger sortShopNum;        // 商品排序选择
@property (strong, nonatomic) NSArray *arrStyle;        // 大分类显示

//数据源
@property (nonatomic, strong) NSMutableArray *storeList;
@property (nonatomic, strong) NSMutableArray *shopList;
@property (strong, nonatomic) NSArray *arrayCompanySortData;
@property (nonatomic, strong) NSMutableArray *cateMerchantList;
@property (nonatomic, strong) NSMutableArray *cateShopList;
@property (nonatomic, strong) NSMutableArray *adContentData;

// 公司风格排序选择
@property (strong, nonatomic) NSString *selectCompanyCateId; // 商家
@property (strong, nonatomic) NSString *selectCompanySort; // 排序

// 商品风格排序选择
@property (strong, nonatomic) NSString *selectShopCateId; // 商品cateid
@property (strong, nonatomic) NSString *selectShopCatePid; // 商品catePid
@property (strong, nonatomic) NSString *selectShopSort; // 排序


@property (nonatomic) BOOL shopAd; // 商品是否有广告
@property (nonatomic) BOOL isgGetCategry; //是否去过类目
@property (nonatomic) NSInteger pageStore;
@property (nonatomic) NSInteger pageShop;
@end


@implementation RenovationCategoryViewController
-(void)viewWillAppear:(BOOL)animated{
    _tableView.growingAttributesUniqueTag=@"storeList_ios";
    _collectionView.growingAttributesUniqueTag=@"productList_ios";
    self.tableViewStyleOne.growingAttributesUniqueTag=@"storeList_ios";
    _tableViewStyleTwo.growingAttributesUniqueTag=@"storeList_ios";
    self.tableViewStyleOne.growingAttributesUniqueTag=@"productList_ios";
    _tableViewStyleTwo.growingAttributesUniqueTag=@"productList_ios";
//    [self getShopData];
//    [self.tableViewSort reloadData];
    [self getCategroyData:@"2"];
    [self setStyle];
    [self.tableViewSort reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",_strStyle);
    _storeList = [NSMutableArray array];
    _shopList = [NSMutableArray array];
    _cateMerchantList = [NSMutableArray array];
    _cateShopList = [NSMutableArray array];
    _adContentData = [NSMutableArray array];
    _selectCompanySort = @"default_order"; // 公司默认排序
    _selectShopSort = @"dp_ascdp_desc"; // 商品默认排序
    _selectCompanyCateId = @"2083";
    _shopAd = NO;
    _isgGetCategry = NO;
    MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStoreData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelected.automaticallyChangeAlpha = YES;
    // 隐藏时间
    headerSelected.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
   // [headerSelected beginRefreshing];
    
    MJRefreshNormalHeader *headerSelectedCollect = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getShopData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelectedCollect.automaticallyChangeAlpha = YES;
    // 隐藏时间
    headerSelectedCollect.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
   // [headerSelectedCollect beginRefreshing];

    // 设置header
    _tableView.mj_header = headerSelected;
    _collectionView.mj_header = headerSelectedCollect;
    
    //加载更多
    __weak typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       [weakSelf seachStore:@"" Page:weakSelf.pageStore + 1 cate:_selectCompanyCateId sortType:_selectCompanySort];
    }];
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachShop:@"" Page:weakSelf.pageShop + 1 cateId:_selectShopCateId catePid: _selectShopCatePid sortType:_selectShopSort];
    }];
    
    
    self.strSelectMerchantShop = @"0";
    [self setUi];
    
    [self getCategroyData:@"1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置大分类显示
- (void)setStyle{
    CateStore *cateStore;
    if ([self.strSelectMerchantShop integerValue] == 0) {
        if (_cateMerchantList.count == 0) {
            return;
        }
        cateStore =  _cateMerchantList[self.styleMerchantNum];
        self.tableViewStyleOne.mj_w = kScreenWidth;
        self.tableViewStyleTwo.hidden = YES;
        
    }else{
        if (_cateShopList.count == 0) {
            return;
        }
        cateStore =  _cateShopList[self.styleTureShopNum];
        self.tableViewStyleOne.mj_w = kScreenWidth/2;
        self.tableViewStyleTwo.hidden = NO;
    }
    [self.tableViewStyleOne reloadData];
    [self.tableViewStyleTwo reloadData];
    
    [self.btnStyle setTitle:cateStore.cateName forState:UIControlStateNormal];
    if ([cateStore.cateName isEqualToString:@"橱柜厨电"]) {
        [self getAdContent:mall_category_2004_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"卫浴瓷砖"]){
        [self getAdContent:mall_category_2003_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"地板门窗"]){
        [self getAdContent:mall_category_2005_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"住宅家具"]){
        [self getAdContent:mall_category_2006_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"家居软装"]){
        [self getAdContent:mall_category_2008_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"基础建材"]){
        [self getAdContent:mall_category_2009_1080x448];
    }
    else if ([cateStore.cateName isEqualToString:@"大家电"]){
        [self getAdContent:mall_category_2010_1080x448];
    }else{
        if ([self.strSelectMerchantShop integerValue] == 0) {
            self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, 0);
            self.tableView.tableHeaderView = nil;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }else{
            _shopAd = NO;
            [_collectionView reloadData];
        }
   
    }

}

- (void) setUi{
    //设置头视图
    self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 155 / 375 + 10);
    self.tableView.tableHeaderView = self.viewTableHead;
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat itemWidth = kScreenWidth / 2;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemWidth-12.5, 258);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 12.5, 10, 12.5);
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView registerClass:[DecorationPackageCell class] forCellWithReuseIdentifier:@"DecorationPackageCell"];
    
    [_collectionView registerClass:[RenovationCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RenovationCollectionReusableView"];
}

#pragma mark - 数据源
- (NSArray *)sortData{
    if (_sortData == nil) {
        _sortData = [NSArray arrayWithObjects: @"默认排序",@"价格最高",@"价格最低",nil];
        
    }
    return _sortData;
}

#pragma mark - 数据源
- (NSArray *)arrayCompanySortData{
    if (_arrayCompanySortData == nil) {
        //_arrayCompanySortData = [NSArray arrayWithObjects: @"默认排序",@"点评最多",@"预约最多",@"口碑排序",nil];
        _arrayCompanySortData = [NSArray arrayWithObjects: @"默认排序",@"口碑排序",@"点评最多",@"预约最多",nil];
       
    }
    return _arrayCompanySortData;
}

// 创建banner图
- (void)setBanner{
    for (LCBannerView *bannerView in self.viewBanner.subviews) {
        [bannerView removeFromSuperview];
    }
    NSMutableArray *urls = [NSMutableArray array];
    for (AdContent *banner in _adContentData) {
        [urls addObject:banner.contentPicUrl];
    }
    if (urls.count == 0) {
        self.imageDefault.hidden = NO;
        return;
    }else{
        self.imageDefault.hidden = YES;
    }
    //轮播图
    NSInteger time;
    if (urls.count>1) {
        time=2.0;
    }else{
        time=100000;
    }

    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 155 / 375)
                                                        delegate:self
                                                       imageURLs:urls
                                            placeholderImageName:RECTPLACEHOLDERIMG
                                                    timeInterval:time
                                   currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                          pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
    bannerView.tag = 0;
    [self.viewBanner addSubview:bannerView];
}

#pragma mark - Actions LCBannerViewDelegate
//轮播图点击
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    AdContent *banner = _adContentData[index];
    [self openWebView:banner.contentUrl];
}


//segmentedControl点击事件
- (void)segmentedControlAction:(UISegmentedControl *)seCtr{
    [self initialSelect];
    if (seCtr.selectedSegmentIndex == 0) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        self.strSelectMerchantShop = @"0";
        [self setStyle];
    }else{
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        self.strSelectMerchantShop = @"1";
        [self getCategroyData:@"2"];
        [self setStyle];
    }
    [self.tableViewSort reloadData];
    
    
}

// 重置选择
- (void)initialSelect{
    self.btnSort.selected = NO;
    self.btnStyle.selected = NO;
    self.viewShowSelect.hidden = YES;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
}

//  返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分类选择
- (IBAction)btnStyle:(UIButton *)button {
    self.btnSort.selected = NO;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    if (button.selected) {
        button.selected = NO;
        self.viewShowSelect.hidden = YES;
        self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        self.strSelectStyleSort = @"0";
        self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头紫"];
        button.selected = YES;
        self.viewShowSelect.hidden = NO;
        self.viewStyle.hidden = NO;
        self.viewSort.hidden = YES;
    }
    
}

// 排序选择
- (IBAction)btnSort:(UIButton *)button {
    self.btnStyle.selected = NO;
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    if (button.selected) {
        button.selected = NO;
        self.viewShowSelect.hidden = YES;
        self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        NSLog(@"********==%@",[self.viewSort subviews]);
        self.strSelectStyleSort = @"1";
        button.selected = YES;
        self.viewShowSelect.hidden = NO;
        self.imageViewSort.image = [UIImage imageNamed:@"展开箭头紫"];
        self.viewStyle.hidden = YES;
        self.viewSort.hidden = NO;
        
    }
    
}

// 关闭选择
- (IBAction)btnCloseSelectView:(id)sender {
    self.btnSort.selected = NO;
    self.btnStyle.selected = NO;
    self.viewShowSelect.hidden = YES;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
}

- (IBAction)btnIamgeClick:(id)sender {
     [self openWebView:@"http://bj.jiehun.com.cn"];
}

// 打开web
- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

//活动点击事件
- (void)activityTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self openWebView:@"http://bj.jiehun.com.cn"];
}


#pragma mark - private
// 商店
- (void)getStoreData {
   [self seachStore:@"" Page:0 cate:_selectCompanyCateId sortType:_selectCompanySort];
}

// 商品
- (void)getShopData {
    [self seachShop:@"" Page:0 cateId:_selectShopCateId catePid: _selectShopCatePid sortType:_selectShopSort];
}

- (void)endTableRefreshing{
    [_tableView.mj_header endRefreshing];
}

#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return _storeList.count;
    }else if (tableView == self.tableViewStyleOne){
        if ([self.strSelectMerchantShop integerValue] == 0) {
            _tableOneH.constant =44 * _cateMerchantList.count;
            return _cateMerchantList.count;
        }else{
            _tableOneH.constant =44 * _cateShopList.count;
            return _cateShopList.count;
        }
        
    }else if (tableView == self.tableViewStyleTwo){
        CateStore *cateStore ;
        if ([self.strSelectMerchantShop integerValue] == 0) {
            return 0;
        }else{
            cateStore =  _cateShopList[self.styleShopNum];
        }
         NSArray * arr = cateStore.subCates;
        return arr.count +1;
    }else if (tableView == self.tableViewSort){
        if ([self.strSelectMerchantShop integerValue] == 0) {
            return self.arrayCompanySortData.count;
        }else if ([self.strSelectMerchantShop integerValue] == 1){
            return self.sortData.count;
        }
       
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (tableView == self.tableView) {
        static NSString * renovationMerchantTableViewCell = @"RenovationMerchantTableViewCell";
        RenovationMerchantTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:renovationMerchantTableViewCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"RenovationMerchantTableViewCell" bundle:nil] forCellReuseIdentifier:renovationMerchantTableViewCell];
            cell = [tableView dequeueReusableCellWithIdentifier:renovationMerchantTableViewCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Store *store = _storeList[indexPath.row];
        [cell loadCell:store];
        return cell;
    }else if (tableView == self.tableViewStyleOne){
        static NSString * classificationTableViewCell = @"ClassificationCell";
        ClassificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ClassificationTableViewCell" bundle:nil] forCellReuseIdentifier:classificationTableViewCell];
            cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        }
        [cell.btnTitle setBackgroundColor:RGB(255, 255, 255)];
        [cell.btnTitle setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        CateStore *cateStore;
        if ([self.strSelectMerchantShop integerValue] == 0) {
            cell.btnTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kScreenWidth/2);
            cateStore = _cateMerchantList[indexPath.row];
            if (indexPath.row == self.styleMerchantNum) {
                [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
            }
        }else{
            cell.btnTitle.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
            cateStore = _cateShopList[indexPath.row];
            if (indexPath.row == self.styleShopNum) {
                [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
            }
        }
        cell.viewLine.hidden = YES;
        [cell.btnTitle setTitle:[cateStore.cateName description] forState:UIControlStateNormal];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnTitle.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,20);
       
        return cell;
    }else if (tableView == self.tableViewStyleTwo){
        static NSString * classificationTableViewCell = @"ClassificationTableViewCell";
        ClassificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ClassificationTableViewCell" bundle:nil] forCellReuseIdentifier:classificationTableViewCell];
            cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        }
        cell.viewLine.hidden = NO;
        [cell.btnTitle setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        cell.backgroundColor = RGB(244, 244, 244);
        cell.btnTitle.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        CateStore *cateStore ;
        if ([self.strSelectMerchantShop integerValue] == 0) {
            cateStore =  _cateMerchantList[self.styleMerchantNum];
            if ( self.styleTureMerchantNum == self.styleMerchantNum) {
                if (indexPath.row == self.styleTwoMerchantNum) {
                    [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                    [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
                }
            }
            
        }else{
            cateStore =  _cateShopList[self.styleShopNum];
            if ( self.styleTureShopNum == self.styleShopNum) {
                if (indexPath.row == self.styleTwoShopNum) {
                    [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                    [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
                }
            }
            
        }
        if (indexPath.row == 0) {
           [cell.btnTitle setTitle:@"全部" forState:UIControlStateNormal];
        }else{
            NSArray * arr = cateStore.subCates;
            NSDictionary *dic = arr[indexPath.row -1];
            [cell.btnTitle setTitle:[dic[@"cate_name"] description] forState:UIControlStateNormal];
        }
        
       
        
        return cell;
    }else if (tableView == self.tableViewSort){
        static NSString * classificationTableViewCell = @"ClassificationTableViewCell";
        ClassificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ClassificationTableViewCell" bundle:nil] forCellReuseIdentifier:classificationTableViewCell];
            cell = [tableView dequeueReusableCellWithIdentifier:classificationTableViewCell];
        }
        cell.viewLine.hidden = YES;
        [cell.btnTitle setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [cell.btnTitle setBackgroundColor:RGB(255, 255, 255)];
        if ([self.strSelectMerchantShop integerValue] == 0) {
            [cell.btnTitle setTitle:[self.arrayCompanySortData[indexPath.row] description] forState:UIControlStateNormal];
            if (indexPath.row == self.sortMerchantNum) {
                [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
            }
        }else{
            [cell.btnTitle setTitle:[self.sortData[indexPath.row] description] forState:UIControlStateNormal];
            if (indexPath.row == self.sortShopNum) {
                [cell.btnTitle setTitleColor:RGB(96, 25, 134) forState:UIControlStateNormal];
                [cell.btnTitle setBackgroundColor:RGB(244, 244, 244)];
            }
        }
        cell.btnTitle.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,kScreenWidth/2+20);
      
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
     return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.tableView) {
          return 101;
    }else if (tableView == self.tableViewStyleOne){
        return 44;
    }else if (tableView == self.tableViewStyleTwo){
        return 44;
    }else if (tableView == self.tableViewSort){
        return 44;
    }
    return 0;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        RenovationCompanyHomeViewController *view = [[RenovationCompanyHomeViewController alloc] initWithNibName:@"RenovationCompanyHomeViewController" bundle:nil];
        Store *storeData = _storeList[indexPath.row];
        view.storeId = storeData.storeId;
        [self.navigationController pushViewController:view animated:YES];
    }else if (tableView == self.tableViewStyleOne){
        if([_strSelectMerchantShop integerValue] == 0){
            CateStore *cateStore = _cateMerchantList[indexPath.row];
            self.styleMerchantNum = indexPath.row;
            self.styleTureMerchantNum = self.styleMerchantNum;
            _selectCompanyCateId = cateStore.cateId;
            //[self seachStore:@"" Page:0 cate:_selectCompanyCateId sortType:_selectCompanySort];
            [_tableView.mj_header beginRefreshing];
            [self initialSelect];
            [self setStyle];
        }else{
            self.styleShopNum = indexPath.row;
        }
        
        [self.tableViewStyleOne reloadData];
        [self.tableViewStyleTwo reloadData];
    }else if (tableView == self.tableViewStyleTwo){
        if([_strSelectMerchantShop integerValue] == 0){
            self.styleTwoMerchantNum = indexPath.row;
            self.styleTureMerchantNum = self.styleMerchantNum;
        }else{
            self.styleTwoShopNum = indexPath.row;
            self.styleTureShopNum = self.styleShopNum ;
              CateStore *cateStore =  _cateShopList[self.styleShopNum];
            if (indexPath.row == 0) {
                _selectShopCatePid = cateStore.cateId;
                _selectShopCateId = @"";
            }else{
                NSArray *subCates = cateStore.subCates;
                _selectShopCatePid = cateStore.cateId;
                _selectShopCateId = [subCates[indexPath.row - 1][@"cate_id"] description];
            }
           // [self seachShop:@"" Page:0 cate:_selectShopCateId sortType:_selectShopSort];
            [_collectionView.mj_header beginRefreshing];
        }
        [self.tableViewStyleOne reloadData];
        [self.tableViewStyleTwo reloadData];
        [self initialSelect];
         [self setStyle];
    }else if (tableView == self.tableViewSort){
        if ([self.strSelectMerchantShop integerValue] == 0) {
            
            self.sortMerchantNum = indexPath.row;
            [self selectShowMerchantSort:_sortMerchantNum];
        }else{
            self.sortShopNum = indexPath.row;
            [self selectShowShopSort:_sortShopNum];
        }
       
        [self initialSelect];
        [self.tableViewSort reloadData];
    }
}

// 选择显示类型
- (void)selectShowMerchantSort:(NSUInteger)num{
    // sort_type //排序类型: default_order 默认  dp_desc 口碑  order_desc 点评  appoint_desc 预约
    if ( num == 0) {
        _selectCompanySort = @"default_order"; // 公司默认排序
    }else if (num == 1){
         _selectCompanySort = @"dp_desc";
    }
    else if (num == 2){
        _selectCompanySort = @"order_desc";
    }
    else if (num == 3){
         _selectCompanySort = @"appoint_desc";
    }
    [self seachStore:@"" Page:0 cate:_selectCompanyCateId sortType:_selectCompanySort];
}

// 选择显示类型
- (void)selectShowShopSort:(NSUInteger)num{
    // sort_type 排序: dp_ascdp_desc综合排序(默认),appoint_ascappoint_desc 预约最多 ,dp_descdp_asc 点评权重数 price_desc商品最大值降序 price_asc商品最小值升序
    if ( num == 0) {
        _selectShopSort = @"dp_ascdp_desc"; // 商品默认排序
    }else if (num == 1){
        _selectShopSort = @"appoint_ascappoint_desc";
    }
    else if (num == 2){
        _selectShopSort = @"dp_descdp_asc";
    }
    else if (num == 3){
        _selectShopSort = @"price_desc";
    }
    else if (num == 4){
        _selectShopSort = @"price_asc";
    }
    [self seachShop:@"" Page:0  cateId:_selectShopCateId catePid: _selectShopCatePid sortType:_selectShopSort];
}


#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    return _shopList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    GoodsDetail *goodsDetail = _shopList[indexPath.row];
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

//这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(_shopAd){
        return CGSizeMake(kScreenWidth, kScreenWidth * 155 / 375 + 10);
    }else{
        return CGSizeMake(0, 0);
    }

}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(_shopAd){
        NSString *CellIdentifier = @"RenovationCollectionReusableView";
        //从缓存中获取 Headercell
        RenovationCollectionReusableView *cell = (RenovationCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        NSMutableArray *urls = [NSMutableArray array];
        for (AdContent *banner in _adContentData) {
            [urls addObject:banner.contentPicUrl];
        }
        //轮播图
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 155 / 375)
                                                            delegate:self
                                                           imageURLs:urls
                                                placeholderImageName:RECTPLACEHOLDERIMG
                                                        timeInterval:2.0f
                                       currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                              pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
        bannerView.tag = 0;

        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 155, kScreenWidth, 10)];
        view.backgroundColor = RGB(242, 242, 242);
        [cell addSubview:view];
        [cell addSubview:bannerView];
        return cell;
    }else{
        return nil;
    }
  
}

#pragma mark- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetail *goodsDetail = _shopList[indexPath.row];

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


//检索店铺
- (void)seachStore:(NSString *)keyword Page:(NSInteger)page cate:(NSString *)cate sortType:(NSString *)sortType {
    //default_order综合排序(默认),appoint_ascappoint_desc 预约最多 ,dp_descdp_asc 点评权重数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:cate forKey:@"cate_id"];
    [parameters setValue:@"list" forKey:@"type"];
    [parameters setValue:@"0" forKey:@"add_example"];
    [parameters setValue:sortType forKey:@"sort_type"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];
    __weak typeof(self) weakSelf = self;
    [SearchStoreRequest requestWithParameters:parameters
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:nil
                            withCancelSubject:[SearchStoreRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                    weakSelf.pageStore = page;
                                    
                                    if (weakSelf.pageStore == 0) {
                                        weakSelf.storeList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"store"];
                                    if (array.count > 0) {
                                        [weakSelf.storeList addObjectsFromArray:array];
                                    }
                                    
                                    [_tableView reloadData];
                                    
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    
                                    if (weakSelf.storeList.count >= total) {
                                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_tableView.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_tableView.mj_footer isRefreshing]) {
                                    [_tableView.mj_footer endRefreshing];
                                }
                        
                                
                                [_tableView.mj_header endRefreshing];
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_tableView.mj_footer isRefreshing]) {
                                    [_tableView.mj_footer endRefreshing];
                                }
                                [_tableView.mj_header endRefreshing];
                             
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_tableView.mj_footer isRefreshing]) {
                                      [_tableView.mj_footer endRefreshing];
                                  }
                                  [_tableView.mj_header endRefreshing];
                                 
                              }];
}

//检索商品
- (void)seachShop:(NSString *)keyword Page:(NSInteger)page cateId:(NSString *)cateId catePid:(NSString *)catePid sortType:(NSString *)sortType{
    //sort_type 排序: dp_ascdp_desc综合排序(默认),appoint_ascappoint_desc 预约最多 ,dp_descdp_asc 点评权重数 price_desc商品最大值降序 price_asc商品最小值升序
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (![CommonUtil isEmpty:cateId]) {
        [parameters setValue:cateId forKey:@"cate_id"];
    }
    [parameters setValue:catePid forKey:@"cate_pid"];
    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:sortType forKey:@"sort_type"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];
    __weak typeof(self) weakSelf = self;
    [GetRCommonSearchProductRequest requestWithParameters:parameters
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:nil
                            withCancelSubject:[GetRCommonSearchProductRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                    weakSelf.pageShop = page;
                                    
                                    if (weakSelf.pageShop == 0) {
                                        weakSelf.shopList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"goods"];
                                    if (array.count > 0) {
                                        [weakSelf.shopList addObjectsFromArray:array];
                                    }
                                    
                                    [_collectionView reloadData];
                                    
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    
                                    if (weakSelf.shopList.count >= total) {
                                        [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_collectionView.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_collectionView.mj_footer isRefreshing]) {
                                    [_collectionView.mj_footer endRefreshing];
                                }
                                
                                
                                [_collectionView.mj_header endRefreshing];
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_collectionView.mj_footer isRefreshing]) {
                                    [_collectionView.mj_footer endRefreshing];
                                }
                                [_collectionView.mj_header endRefreshing];
                                
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_collectionView.mj_footer isRefreshing]) {
                                      [_collectionView.mj_footer endRefreshing];
                                  }
                                  [_collectionView.mj_header endRefreshing];
                                  
                              }];
}


// 类目列表
- (void)getCategroyData:(NSString *)level{
    if (_isgGetCategry) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //[parameters setValue:_storeId forKey:@"store_id"];
    if ([level integerValue] == 2) {
         _isgGetCategry = YES;
    }
    [parameters setValue:level forKey:@"level"];
    

    __weak typeof(self) weakSelf = self;
    [GetRCategoryListRequest requestWithParameters:parameters
                                         withCacheType:DataCacheManagerCacheTypeMemory
                                     withIndicatorView:nil
                                     withCancelSubject:[GetRCategoryListRequest getDefaultRequstName]
                                        onRequestStart:nil
                                     onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                             
                                             if([level integerValue] == 1){
                                                 weakSelf.cateMerchantList = [request.resultDic objectForKey:@"cateStore"];
                                                 self.tableViewStyleOne.mj_w = kScreenWidth;
                                                 self.tableViewStyleTwo.hidden = YES;
                                                 if (weakSelf.cateMerchantList.count >0) {
                                                     BOOL isHave = NO;
                                                     for (int a = 0 ; a<_cateMerchantList.count; a ++) {
                                                          CateStore *cateStore = _cateMerchantList[a];
                                                         if ([cateStore.cateName isEqualToString:_strStyle]) {
                                                             self.styleMerchantNum = a;
                                                             _selectCompanyCateId = cateStore.cateId;
                                                             isHave = YES;
                                                         }
                                                     }
                                                     
                                                     if (!isHave) {
                                                         CateStore *cateStore = _cateMerchantList[0];
                                                         _selectCompanyCateId = cateStore.cateId;
                                                     }
                                                     
                                                     [self setStyle];
                                                     [_tableView.mj_header beginRefreshing];
                                                 }
                                    
                                            
                                             }else{
                                                 weakSelf.cateShopList = [request.resultDic objectForKey:@"cateStore"];
                                                 self.tableViewStyleOne.mj_w = kScreenWidth/2;
                                                 self.tableViewStyleTwo.hidden = NO;
                                                 if (weakSelf.cateShopList.count >0) {
                                                     
                                                     BOOL isHave = NO;
                                                     for (int a = 0 ; a<_cateShopList.count; a ++) {
                                                         CateStore *cateStore = _cateShopList[a];
                                                         if ([cateStore.cateName isEqualToString:_strStyle]) {
                                                             self.styleShopNum = a;
                                                             self.styleTureShopNum = a;
                                                             _selectShopCateId = @"";
                                                             _selectShopCatePid = cateStore.cateId;
                                                             isHave = YES;
                                                         }
                                                     }
                                                     
                                                     if (!isHave) {
                                                         CateStore *cateStore =  weakSelf.cateShopList[0];
                                                         _selectShopCateId = @"";
                                                         _selectShopCatePid = cateStore.cateId;
                                                     }

                                                    [self setStyle];
                                                    [_collectionView.mj_header beginRefreshing];
                                                 }
                                             }
                                             
                                             [weakSelf.tableViewStyleOne reloadData];
                                             [weakSelf.tableViewStyleTwo reloadData];
                                           
                                         }
                                         
                                         
                                     }
                                     onRequestCanceled:^(CIWBaseDataRequest *request) {
                                         
                                     }
                                       onRequestFailed:^(CIWBaseDataRequest *request) {
                                           
                                    }];
}

#pragma mark - private
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
                                  
                                   if([_strSelectMerchantShop integerValue] == 0){
                                       if( weakSelf.adContentData.count >0){
                                           [self setBanner];
                                           self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 155 / 375 + 10);
                                           self.tableView.tableHeaderView = self.viewTableHead;
                                       }else{
                                           self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, 0);
                                           self.tableView.tableHeaderView = nil;
                                       }
                                       [self.tableView beginUpdates];
                                       [self.tableView endUpdates];
                                   }else{
                                       if( weakSelf.adContentData.count >0){
                                           _shopAd = YES;
                                           [_collectionView reloadData];
                                       }else{
                                           _shopAd = NO;
                                           [_collectionView reloadData];
                                       }
                                     
                                   }
                                 
                               }else{
                                   
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                             
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                              
                                 
                             }];
    
}

@end
