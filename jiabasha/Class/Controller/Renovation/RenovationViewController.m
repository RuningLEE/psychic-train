//
//  RenovationViewController.m
//  JiaZhuang
//
//  Created by 金伟城 on 16/12/26.
//  Copyright © 2016年 hzdaoshun. All rights reserved.
//

#import "Banner.h"
#import "Category.h"
#import "VipPrice.h"
#import "Activity.h"
#import "AppDelegate.h"
#import "RenovationBrand.h"
#import "RenovationTopic.h"
#import "MJRefresh.h"
#import "LCBannerView.h"
#import "UIColor-Expanded.h"
#import "WebViewController.h"
#import "SearchViewController.h"
#import "JZMainTabController.h"
#import "CouponViewController.h"
#import "DecorateViewController.h"
#import "MessageViewController.h"
#import "GetRenovationTopicRequest.h"
#import "GetRenovationHomeRequest.h"
#import "SwitchCityViewController.h"
#import "GoodSelectTableViewCell.h"
#import "HomeMemberTableViewCell.h"
#import "RenovationViewController.h"
#import "BrandSpecialTableViewCell.h"
#import "ActivityListViewController.h"
#import "BrandActivitiesTableViewCell.h"
#import "AppointDesignViewController.h"
#import "RenovationCategoryViewController.h"
#import "RenovationShopDetialViewController.h"
#import "BuildingMaterialViewController.h"

#import "ActivityAlterViewRequest.h"
#import "ActivityAlterView.h"
@interface RenovationViewController ()<UITableViewDelegate, UITableViewDataSource, LCBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewTableHead;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
// banner图
@property (weak, nonatomic) IBOutlet UIView *viewBanner;
// 分类页
@property (weak, nonatomic) IBOutlet UIView *viewSort;

//轮播图
@property (nonatomic, strong) NSArray *bannerSelectedList;
//会员专场
@property (nonatomic, strong) NSArray *vippriceSelectedList;
//分类
@property (nonatomic, strong) NSArray *categorySelectedList;
//品牌专场
@property (nonatomic, strong) NSArray *brandSelectedList;
//品牌活动
@property (nonatomic, strong) NSArray *activitySelectedList;
//专题
@property (nonatomic, strong) NSArray *topicSelectedList;
@property(nonatomic,strong) ActivityAlterView *activityView;
@property(nonatomic,strong)UIImage *alterImage;//活动弹框的图片
@end

@implementation RenovationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetAcivityAlterView];
    // Do any additional setup after loading the view from its nib.
    [_btnLocation setTitle:DATA_ENV.city.sname forState:UIControlStateNormal];

    
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 109);
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSelectedData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelected.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    headerSelected.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [headerSelected beginRefreshing];
    
    // 设置header
    _tableView.mj_header = headerSelected;
    
    //注册tableViewCell
    [_tableView registerNib:[UINib nibWithNibName:@"HomeMemberTableViewCell" bundle:nil]
    forCellReuseIdentifier:@"HomeMemberTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BrandSpecialTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"BrandSpecialTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BrandActivitiesTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"BrandActivitiesTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"GoodSelectTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"GoodSelectTableViewCell"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self GetAcivityAlterView];
    NSString *cityname = _btnLocation.currentTitle;
    if (![DATA_ENV.city.sname isEqualToString:cityname]) {
        [_btnLocation setTitle:DATA_ENV.city.sname forState:UIControlStateNormal];
        [_tableView.mj_header beginRefreshing];
    }
}
#pragma mark //活动弹框

-(void)GetAcivityAlterView{
    NSDictionary *param;
    
    param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.userLevel,@"popup_target",@"mall",@"popup_location", nil];
    [ActivityAlterViewRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ActivityAlterViewRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"******==%@",request.resultDic);
            //_alterImage
            NSString *imageUrl=request.resultDic[@"data"][@"popup_pic_url"];
            NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            _alterImage=[UIImage imageWithData:data];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"reno"]){
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reno"];
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



- (void)setHeadUi{
    //设置头视图
    self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, 372);
    self.tableView.tableHeaderView = self.viewTableHead;

    [self setBanner];
    
    float sortHight =  [self setSort];
    
    CGFloat height = kScreenWidth * 360 / 750;
    
    self.viewTableHead.height = height + sortHight + 10;
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.viewTableHead];
    [self.tableView endUpdates];
}

- (void)btnCategory:(UIButton *)sender {
    CategorySelected *category= _categorySelectedList[sender.tag];
    NSString *urlString = category.contentUrl;
    
    if ([@"jbs://hot_activities/" isEqualToString:urlString]) {
        //热门活动
        ActivityListViewController *viewContoller = [[ActivityListViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://order_design/" isEqualToString:urlString]) {
        //预约设计
        AppointDesignViewController *viewContoller = [[AppointDesignViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_assistant/" isEqualToString:urlString]) {
        //装修助手
        DecorateViewController *viewContoller = [[DecorateViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cash_ticket/" isEqualToString:urlString]) {
        //现金券
        CouponViewController *viewContoller = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cabinet_electric/" isEqualToString:urlString]) {
        //橱柜厨电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://bathroom_accessory_ceramic/" isEqualToString:urlString]) {
        //卫浴陶瓷
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://floor_board_windows/" isEqualToString:urlString]) {
        //地板门窗
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://house_furniture/" isEqualToString:urlString]) {
        //住宅家具
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://furniture_soft_decoration/" isEqualToString:urlString]) {
        //家居软装
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://base_building_materials/" isEqualToString:urlString]) {
        //基础建材
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://big_household_appliances/" isEqualToString:urlString]) {
        //大家电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_company/" isEqualToString:urlString]) {
        //装修公司
        RenovationCategoryViewController *viewContoller = [[ RenovationCategoryViewController alloc]init];
        viewContoller.strStyle= [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
//        AppDelegate *appDelegate = APP_DELEGATE;
//        [appDelegate.MyTabBarController controlBuildingMaterialClick];
        
    } else if ([@"jbs://login/" isEqualToString:urlString]) {
        //登陆
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        
    } else if ([@"jbs://home/" isEqualToString:urlString]) {
        //首页
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlHomeClick];
        
    } else if ([@"jbs://mine/" isEqualToString:urlString]) {
        //我的
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlMyClick];
        
    } else if ([@"jbs://message/" isEqualToString:urlString]) {
        //消息中心
        if (DATA_ENV.isLogin) {
            MessageViewController* messageController = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:messageController animated:YES];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        }
    } else {
        if (![CommonUtil isEmpty:category.contentUrl ]) {
            [self openWebView:category.contentUrl];
        }
        
    }

}

// 创建banner图
- (void)setBanner{
    for (LCBannerView *bannerView in self.viewBanner.subviews) {
        [bannerView removeFromSuperview];
    }
    NSMutableArray *urls = [NSMutableArray array];
    for (Banner *banner in _bannerSelectedList) {
        [urls addObject:banner.contentPicUrl];
    }
    if (urls.count == 0) {
        return;
    }
    //轮播图
    NSInteger time;
    if (urls.count>1) {
        time=2.0;
    }else{
        time=100000;
        
    }

    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 360 / 750)
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
    Banner *banner = _bannerSelectedList[index];
    [self openWebView:banner.contentUrl];
}

- (float)setSort{
    //NSArray *arrSort = [NSArray arrayWithObjects:@"橱柜厨电",@"卫浴陶瓷",@"地板门窗",@"住宅家具",@"家居软装",@"基础建材",@"大家电",@"装修公司", nil];
    
    for (UIView *view in _viewSort.subviews) {
        [view removeFromSuperview];
    }
    
    float height = 0.0;
    NSInteger sortNum = _categorySelectedList.count;
    float width = (kScreenWidth - 20)/4;
    for (int a = 0; a < sortNum; a++) {
        float yushu = a/4;
        float beiyushu = a%4;
        
        CategorySelected *cate= _categorySelectedList[a];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(beiyushu * width , yushu * width, width, width)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag  = a;
        [btn addTarget:self action:@selector(btnCategory:) forControlEvents:UIControlEventTouchUpInside];
        [_viewSort addSubview:btn];
        
    
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((width-kScreenWidth/7)/2, (width- kScreenWidth/7-18)/2, kScreenWidth/7,  kScreenWidth/7)];
        [image sd_setImageWithURL:[NSURL URLWithString:cate.contentPicUrl] placeholderImage:[UIImage imageNamed:SMALLPALCEHOLDERIMG]];
         [btn addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.origin.y +  kScreenWidth/7 + 7, width, 12)];
        label.text = [cate.contentTile description];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB(51, 51, 51);
        label.textAlignment = UITextAlignmentCenter;
        [btn addSubview:label];
    }
    float yushu = sortNum/4;
    float beiyushu = sortNum%4;
    if (beiyushu == 0) {
        height = width* yushu ;
    }else{
        height = width *( yushu + 1);
    }
    return height;
}

#pragma mark- tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //  0-家装会员 1-品牌专场 2-品牌活动 3-导购精选
    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

     // 0-家装会员 1-品牌专场 2-品牌活动 3-导购精选
    if (section == 0) {
        if (_vippriceSelectedList.count == 0) {
            return 0;
        }
        return 1;
    } else if (section == 1) {
        if (_brandSelectedList.count == 0) {
            return 0;
        }
        return 1;
    } else if (section == 2) {
        if (_activitySelectedList.count == 0) {
            return 0;
        }
        return _activitySelectedList.count;
    }else if (section == 3) {
        if (_topicSelectedList.count == 0) {
            return 0;
        }
        return _topicSelectedList.count;
    }
    return 0;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  0-家装会员 1-品牌专场 2-品牌活动 3-导购精选
    if (indexPath.section == 0) {
        return [HomeMemberTableViewCell getHeightForDevice];
    } else if (indexPath.section  == 1) {
        return [BrandSpecialTableViewCell getHeightForDevice];
    } else if (indexPath.section  == 2) {
        if(indexPath.row == 0){
            if(indexPath.row == (_activitySelectedList.count - 1)){
                return [BrandActivitiesTableViewCell getHeightForDevice:NO isLast:NO];
            }else{
                 return [BrandActivitiesTableViewCell getHeightForDevice:NO isLast:YES];
            }
           
        }else{
            if(indexPath.row == (_activitySelectedList.count - 1)){
                return [BrandActivitiesTableViewCell getHeightForDevice:YES isLast:NO];
            }else{
                return [BrandActivitiesTableViewCell getHeightForDevice:YES isLast:YES];
            }
           
        }
    }else if (indexPath.section  == 3) {
        if(indexPath.row == 0){
           return [GoodSelectTableViewCell getHeightForDevice:NO];
        }else{
            return [GoodSelectTableViewCell getHeightForDevice:YES];
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    //  0-家装会员 1-品牌专场 2-品牌活动 3-导购精选
    if (indexPath.section == 0) {
        return [self HomeMemberCellForTableView:tableView];
    } else if (indexPath.section  == 1) {
          return [self BrandSpecialCellForTableView:tableView];
    } else if (indexPath.section  == 2) {
         return [self BrandActivitiesCellForTableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section  == 3) {
         return [self GoodSelectCellForTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
    
}

// 家装会员节
- (UITableViewCell *)HomeMemberCellForTableView:(UITableView *)tableView {
    
    HomeMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMemberTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *imgViews = @[cell.imgView1, cell.imgView2, cell.imgView3, cell.imgView4 ,cell.imgView5 ,cell.imgView6 ,cell.imgView7 ,cell.imgView8];
    
    for (int i = 0; i < imgViews.count; i++) {
        
        UIImageView *imageView = [imgViews objectAtIndex:i];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [self removeGestureRecognizer:imageView];
        if (i < _vippriceSelectedList.count) {
            VipPrice *vipPrice = _vippriceSelectedList[i];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipTapGesture:)];
            [imageView addGestureRecognizer:tapGesture];
            imageView.tag = i;
            [imageView sd_setImageWithURL:[NSURL URLWithString:vipPrice.contentPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
        }else{
            imageView.image = nil;
        }
    }
    
    return cell;
}

// 品牌专场
- (UITableViewCell *)BrandSpecialCellForTableView:(UITableView *)tableView {
    BrandSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandSpecialTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *imgViews = @[cell.imageView1, cell.imageView2, cell.imageView3];
    NSArray *labels = @[cell.labelName1, cell.labelName2, cell.labelName3];
    
    for (int i = 0; i < imgViews.count; i++) {
        UIImageView *imageView = [imgViews objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        imageView.tag = i;
        [self removeGestureRecognizer:imageView];
        if (i < _brandSelectedList.count) {
            RenovationBrand *brandPrice = _brandSelectedList[i];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandSpecialTapGesture:)];
            [imageView addGestureRecognizer:tapGesture];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:brandPrice.contentPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
            label.text = brandPrice.contentTile;
        }else{
            imageView.image = nil;
            label.text = @"";
        }
    }
    
    return cell;
}

// 品牌活动
- (UITableViewCell *)BrandActivitiesCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandActivitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandActivitiesTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Activity *activity = _activitySelectedList [indexPath.row];
    [cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:activity.contentPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    cell.imageViewIcon.tag = indexPath.row;
    cell.imageViewIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandActivitiesTapGesture:)];
    [cell.imageViewIcon addGestureRecognizer:tapGesture];
    
    if(indexPath.row == 0){
        if(indexPath.row == (_activitySelectedList.count - 1)){
            cell.viewGrayHeigth.constant = 10;
        }else{
            cell.viewGrayHeigth.constant = 0;
        }
        cell.viewHeadTop.hidden = NO;
        cell.viewHeadHeight.constant = 46;
        
    }else{
        if(indexPath.row == (_activitySelectedList.count - 1)){
               cell.viewGrayHeigth.constant = 10;
        }else{
               cell.viewGrayHeigth.constant = 0;
        }
        cell.viewHeadTop.hidden = YES;
        cell.viewHeadHeight.constant = 0;
    }
    
//    if(indexPath.row == 0){
//        cell.viewHeadTop.hidden = NO;
//        cell.viewHeadHeight.constant = 46;
//        cell.viewGrayHeigth.constant = 10;
//    }else{
//        cell.viewHeadTop.hidden = YES;
//        cell.viewHeadHeight.constant = 0;
//        cell.viewGrayHeigth.constant = 0;
//        
//    }
    return cell;
}

// 导购精选
- (UITableViewCell *) GoodSelectCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodSelectTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        cell.viewHeaderHeight.constant = 46;
    }else{
        cell.viewHeaderHeight.constant = 15;
    }
    
    if(indexPath.row == (_topicSelectedList.count - 1)){
        cell.viewLine.hidden = YES;;
    }else{
        cell.viewLine.hidden = NO;;
    }
    
    RenovationTopic *topic = _topicSelectedList[indexPath.row];
    [cell.imageViewBig sd_setImageWithURL:[NSURL URLWithString:topic.topicPicUrl] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
    
    cell.imageViewBig .userInteractionEnabled = YES;
    cell.imageViewBig.tag = indexPath.row;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodSelectTapGesture:)];
    [cell.imageViewBig  addGestureRecognizer:tapGesture];
    
    NSArray *product = [NSArray arrayWithArray:topic.product];
    NSArray *imgViews = @[cell.imageViewSmall1, cell.imageViewSmall2, cell.imageViewSmall3];
    NSArray *labels = @[cell.labelTitle1, cell.labelTitle2, cell.labelTitle3];
    NSArray *labelPrices = @[cell.labelPrice1, cell.labelPrice2, cell.labelPrice3];
    NSArray *btnJumps = @[cell.btnJump1, cell.btnJump2, cell.btnJump3];
    NSUInteger numP = product.count;

    for (int i = 0; i < numP && i< 3; i++) {
        NSDictionary *productDic = product[i];
        UIImageView *imageView = [imgViews objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        UILabel *labelPrice = [labelPrices objectAtIndex:i];
        UILabel *btnJump = [btnJumps objectAtIndex:i];
        imageView.tag = i;
        btnJump.hidden = YES;
        imageView.superview.tag = indexPath.row;
        [self removeGestureRecognizer:imageView];
        if (productDic != nil) {
          
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodhomeProductTapGesture:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tapGesture];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[productDic[@"img_url"] description]] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
            label.text = [productDic[@"product_name"] description];
            NSString *needText;
            if ([CommonUtil isEmpty:[productDic[@"mall_price"] description]]) {
                needText = @"面议";
            }else{
               needText =  [NSString stringWithFormat:@"惊爆价:￥%@",[productDic[@"mall_price"] description]];
            }
            labelPrice.text = needText;
            imageView.hidden = NO;
            label.hidden = NO;
            labelPrice.hidden = NO;
        }else{
            imageView.image = nil;
            label.text = @"";
            labelPrice.text = @"";
        }
    }
 
    NSInteger num = product.count;
    for (int i = (int)num; i < 3 ; i++) {
        UIImageView *imageView = [imgViews objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        UILabel *labelPrice = [labelPrices objectAtIndex:i];
        UIButton *btnJump = [btnJumps objectAtIndex:i];
        imageView.hidden = YES;
        label.hidden = YES;
        labelPrice.hidden = YES;
        btnJump.hidden  = YES;
    }
    
    return cell;
}

//移除手势
- (void)removeGestureRecognizer:(UIView *)aView
{
    NSArray *allGesture = aView.gestureRecognizers;
    for (UIGestureRecognizer *gesture in allGesture) {
        [aView removeGestureRecognizer:gesture];
    }
}

#pragma mark - Actions
//城市切换
- (IBAction)btnLocationClicked:(id)sender {
    SwitchCityViewController *viewController = [[SwitchCityViewController alloc] initWithNibName:@"SwitchCityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

//检索
- (IBAction)searchClicked:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

// 打开web
- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

// 家装会员节
- (void)vipTapGesture:(UITapGestureRecognizer *)tapGesture {
      VipPrice *vipPrice = _vippriceSelectedList[tapGesture.view.tag];
     [self openWebView:vipPrice.contentUrl];
}

// 品牌专场
- (void)brandSpecialTapGesture:(UITapGestureRecognizer *)tapGesture {
    RenovationBrand *renovationBrand = _brandSelectedList[tapGesture.view.tag];
    [self openWebView:renovationBrand.contentUrl];
}
// 品牌活动
- (void)brandActivitiesTapGesture:(UITapGestureRecognizer *)tapGesture {
    Activity *activity = _activitySelectedList [tapGesture.view.tag];
    [self openWebView:activity.contentUrl];
}
// 导购精选
- (void)goodSelectTapGesture:(UITapGestureRecognizer *)tapGesture {
    RenovationTopic *topic = _topicSelectedList[tapGesture.view.tag];
    [self openWebView:topic.topicUrl];
}

//发现好家-商品
- (void)goodhomeProductTapGesture:(UITapGestureRecognizer *)tapGesture {
    
    RenovationTopic *renovationTopic = _topicSelectedList[tapGesture.view.superview.tag];
    NSDictionary *productDic = renovationTopic.product[tapGesture.view.tag];
    RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
    viewControler.productId = productDic[@"product_id"];
    [self.navigationController pushViewController:viewControler animated:YES];
    
}


#pragma mark - private
// 建材家电数据
- (void)getSelectedData {
    [self GetRenovationHomeData];
    [self GetRenovationTopicData];
}

//取挑货数据
- (void)GetRenovationHomeData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [GetRenovationHomeRequest requestWithParameters:parameters
                                    withCacheType:DataCacheManagerCacheTypeMemory
                                withIndicatorView:nil
                                withCancelSubject:[GetRenovationHomeRequest getDefaultRequstName]
                                   onRequestStart:nil
                                onRequestFinished:^(CIWBaseDataRequest *request) {
                                   
                                    if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                        
                                        weakSelf.bannerSelectedList = [request.resultDic objectForKey:@"banner"];
                                        weakSelf.vippriceSelectedList = [request.resultDic objectForKey:@"vipprice"];
                                        weakSelf.categorySelectedList = [request.resultDic objectForKey:@"category"];
                                        weakSelf.brandSelectedList = [request.resultDic objectForKey:@"brand"];
                                        weakSelf.activitySelectedList = [request.resultDic objectForKey:@"activity"];
                                        [_tableView reloadData];
                                        [self setHeadUi];
                                        
//                                        dispatch_group_t group = dispatch_group_create();
//                                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//                                        dispatch_group_async(group, mainQueue, ^{
//                                           [_tableView reloadData];
//
//                                        });
//                                        dispatch_group_notify(group, mainQueue, ^{
//                                           
//                                             [self setHeadUi];
//                                        });
                                    
                                    }
                                    
                                    [_tableView.mj_header endRefreshing];
                                }
                                onRequestCanceled:^(CIWBaseDataRequest *request) {
                                    [_tableView.mj_header endRefreshing];
                                }
                                  onRequestFailed:^(CIWBaseDataRequest *request) {
                                      [_tableView.mj_header endRefreshing];
                                  }];
}

// 专题
- (void)GetRenovationTopicData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"MALL" forKey:@"type"];
    [parameters setValue:@"1" forKey:@"product"];
    __weak typeof(self) weakSelf = self;
    [GetRenovationTopicRequest requestWithParameters:parameters
                                      withCacheType:DataCacheManagerCacheTypeMemory
                                  withIndicatorView:nil
                                  withCancelSubject:[GetRenovationTopicRequest getDefaultRequstName]
                                     onRequestStart:nil
                                  onRequestFinished:^(CIWBaseDataRequest *request) {
                                      
                                      if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                          
                                          weakSelf.topicSelectedList = [request.resultDic objectForKey:@"topic"];
                                          
                                      }
                                      
                                        [_tableView reloadData];
                                      
                                      [_tableView.mj_header endRefreshing];
                                  }
                                  onRequestCanceled:^(CIWBaseDataRequest *request) {
                                      [_tableView.mj_header endRefreshing];
                                  }
                                    onRequestFailed:^(CIWBaseDataRequest *request) {
                                        [_tableView.mj_header endRefreshing];
                                    }];
}

@end
