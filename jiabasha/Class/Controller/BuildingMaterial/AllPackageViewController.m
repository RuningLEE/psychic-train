//
//  AllPackageViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "StoreCategory.h"
#import "GoodsDetail.h"
#import "GetMallStoreCategory.h"
#import "getProductStoreCateogry.h"
#import "DecorationPackageCell.h"
#import "AllPackageViewController.h"
#import "FreeFunctionViewController.h"
#import "GroupProductDetailViewController.h"
#import "RenovationShopDetialViewController.h"

@interface AllPackageViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewSelectShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnCatetorySelect;
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;

@property (strong, nonatomic) NSMutableArray *sortShopNum;
@property (nonatomic, strong) NSString *sortShopDataName;

//  数据源
@property (strong, nonatomic) NSMutableArray *arrStoreShopData;
@property (strong, nonatomic) NSMutableArray *arrStoreCategoryData;
@property (nonatomic) NSInteger pageShop;
@end

@implementation AllPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrStoreShopData = [NSMutableArray array];
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
    
    [self getStoreCategoryData];
    
    if (![CommonUtil isEmpty:_storeCategory ]) {
        _sortShopDataName = _storeCategory;
    }
    
    if (_storeCategoryArr != nil) {
        _sortShopNum = _storeCategoryArr;
    }
    
    // 下拉刷新
    MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStoredData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelected.automaticallyChangeAlpha = YES;
    // 隐藏时间
    headerSelected.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [headerSelected beginRefreshing];
    // 设置header
    _collectionView.mj_header = headerSelected;
    
    //加载更多
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getBuildingStoreShopData:weakSelf.pageShop + 1 scateids:self.sortShopDataName];
    }];

    if ([_isShop integerValue] == 1) {
        _lableTitle.text = @"全部商品";
        _labelSubTitle.text = @"店铺商品";
    }else{
        _lableTitle.text = @"全部套餐";
        _labelSubTitle.text = @"装修套餐";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getStoredData {
    [self getBuildingStoreShopData:0 scateids:self.sortShopDataName];
    //[_tableViewCompany.mj_header endRefreshing];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 选择分类
- (IBAction)btnCategory:(UIButton *)sender {
    if (_arrStoreCategoryData.count == 0) {
        [self.view makeToast:@"暂无分类"];
        return;
    }
    if (sender.selected) {
        sender.selected = NO;
        self.viewSelectShow.hidden = YES;
         [sender setTitleColor:RGB(181, 181, 181)forState:UIControlStateNormal];
    }else{
        [sender setTitleColor:RGB(255, 59, 48)forState:UIControlStateNormal];
        [self creatSelectView:_arrStoreCategoryData.count];
        sender.selected = YES;
        self.viewSelectShow.hidden = NO;
        [self moveanimations];
    }
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

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.companyName = _storeName;
    view.storeId = _storeId;
    [self.navigationController pushViewController:view animated:YES];
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
    if (beiyushu == 0) {
        self.viewSelectHeight.constant = 13 + 38 * yushu ;
    }else{
        self.viewSelectHeight.constant = 13 + 38 *( yushu + 1);
    }
    
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
    [self getBuildingStoreShopData:0 scateids:self.sortShopDataName ];
    [self creatSelectView:_sortShopNum.count ];
    self.viewSelectShow.hidden = YES;
    self.btnCatetorySelect.selected = NO;
    [  self.btnCatetorySelect setTitleColor:RGB(181, 181, 181)forState:UIControlStateNormal];

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


// all商品
- (void)getBuildingStoreShopData:(NSInteger)page scateids:(NSString *)scateids{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
     [parameters setValue:_storeId forKey:@"store_id"];
    [parameters setValue:scateids forKey:@"scate_ids"];
    [parameters setValue:@0 forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];

    __weak typeof(self) weakSelf = self;
    [getProductStoreCateogry requestWithParameters:parameters
                                     withCacheType:DataCacheManagerCacheTypeMemory
                                 withIndicatorView:nil
                                 withCancelSubject:[getProductStoreCateogry getDefaultRequstName]
                                    onRequestStart:nil
                                 onRequestFinished:^(CIWBaseDataRequest *request) {
                                     
                                     if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                            
                                         weakSelf.pageShop = page;
                                         
                                         if (weakSelf.pageShop == 0) {
                                             weakSelf.arrStoreShopData = [NSMutableArray array];
                                         }
                                         
                                         NSArray *array = [request.resultDic objectForKey:@"goodsDetail"];
                                         if (array.count > 0) {
                                             [weakSelf.arrStoreShopData addObjectsFromArray:array];
                                         }
                                         
                                        [weakSelf.collectionView reloadData];
                                         
                                         //条数
                                         NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                         
                                         
                                         if (weakSelf.arrStoreShopData.count >= total) {
                                             [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                         } else {
                                             [_collectionView.mj_footer resetNoMoreData];
                                         }
                                         
                                     }
                                     if ([_collectionView.mj_footer isRefreshing]) {
                                         [_collectionView.mj_footer endRefreshing];
                                     }
                                     _collectionView.tag = 1;
                                     [_collectionView.mj_header endRefreshing];
                                     
                                 }
                                 onRequestCanceled:^(CIWBaseDataRequest *request) {
                                     if ([_collectionView.mj_footer isRefreshing]) {
                                         [_collectionView.mj_footer endRefreshing];
                                     }
                                     [_collectionView.mj_header endRefreshing];
                                     _collectionView.tag = 1;
                                 }
                                   onRequestFailed:^(CIWBaseDataRequest *request) {
                                       if ([_collectionView.mj_footer isRefreshing]) {
                                           [_collectionView.mj_footer endRefreshing];
                                       }
                                       [_collectionView.mj_header endRefreshing];
                                       _collectionView.tag = 1;
                                   }];
}


@end
