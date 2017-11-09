//
//  CompanySearchViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Store.h"
#import "BuildingExample.h"
#import "CaseHomeViewController.h"
#import "SearchStoreRequest.h"
#import "CompanyTableViewCell.h"
#import "AllCaseViewController.h"
#import "SearchNearbyTableViewCell.h"
#import "CompanyHomeViewController.h"
#import "CompanySearchViewController.h"
#import "YMAnnotationView.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "YMPointAnnotation.h"
#import "GetExampleListRequest.h"
#import "BuildingExample.h"
#import "YMPaopaoView.h"
//#import "YMAnnotationView.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface CompanySearchViewController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    //BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
    BMKGeoCodeResult *GeoResult;
}
/** 用户当前位置*/
@property(nonatomic , strong) BMKUserLocation *userLocation;

@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldContent;
@property (weak, nonatomic) IBOutlet UIView *viewGray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSearchHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;

@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIButton *btnFreeDesign;
@property (weak, nonatomic) IBOutlet UIView *BgmapView;

@property (assign ,nonatomic) BOOL isSearch; // 是否点击搜索
@property (assign ,nonatomic) BOOL isSearchNoData; // 搜索是否有结果
@property (nonatomic) NSInteger pageStore;
//数据源
@property (nonatomic, strong) NSMutableArray *storeList;
@property (nonatomic, strong) NSMutableArray *exampleList;//xiaoqu
@end

@implementation CompanySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    _storeList = [NSMutableArray array];
     _exampleList = [NSMutableArray array];
    [self setTapOfKeyboard];
    [self setUi];
    [self setupMapViewWithParam];
   
}
#pragma mark - 设置百度地图
-(void)setupMapViewWithParam {
    self.userLocation = [[BMKUserLocation alloc] init];
    _locService = [[BMKLocationService alloc] init];
    _locService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;//设定定位精度
    //开启定位服务
    [_locService startUserLocationService];
    //初始化BMKMapView
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, _BgmapView.frame.size.height)];
    _mapView.buildingsEnabled = YES;//设定地图是否现显示3D楼块效果
    _mapView.overlookEnabled = YES; //设定地图View能否支持俯仰角
    _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
    _mapView.zoomLevel = 16;//设置放大级别
    [_BgmapView addSubview:_mapView];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    //displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.isRotateAngleValid = YES;
    userlocationStyle.isAccuracyCircleShow = NO;
}
#pragma mark - BMKLocationServiceDelegate 用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];// 动态更新我的位置数据
    self.userLocation = userLocation;
    NSLog(@"*****%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView setCenterCoordinate:userLocation.location.coordinate];// 当前地图的中心点
}


#pragma mark -BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    // 创建大头针
    YMAnnotationView *annotationView = [YMAnnotationView annotationViewWithMap:mapView withAnnotation:annotation];
       // annotationView.curAddress=
        YMPaopaoView *paopaoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YMPaopaoView class]) owner:nil options:nil] lastObject];
       YMPointAnnotation *anno = (YMPointAnnotation *)annotationView.annotation;
        paopaoView.poi = anno.poi;
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:nil];
    return annotationView;
    
}
//正地理编码代理
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
   }
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    // 当选中标注的之后，设置开始拖动状态
    view.dragState = BMKAnnotationViewDragStateStarting;
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)annotationView {
    // 取消选中标注后，停止拖动状态
    annotationView.dragState = BMKAnnotationViewDragStateEnding;
    // 设置转换的坐标会有一些偏差，具体可以再调节坐标的 (x, y) 值
    CGPoint dropPoint = CGPointMake(annotationView.center.x, CGRectGetMaxY(annotationView.frame));
    CLLocationCoordinate2D newCoordinate = [_mapView convertPoint:dropPoint toCoordinateFromView:annotationView.superview];
    [annotationView.annotation setCoordinate:newCoordinate];
    /// geo检索信息类,获取当前城市数据
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = newCoordinate;
    [_geoSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 根据坐标返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    BMKAddressComponent *addressComponent = result.addressDetail;
    NSString *title = [NSString stringWithFormat:@"%@%@%@%@", addressComponent.city, addressComponent.district, addressComponent.streetName, addressComponent.streetNumber];
    NSLog(@"%s -- %@", __func__, title);
}

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)annotationView didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState {
    // -------- 这个方法不起作用 -----------
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoSearch.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoSearch.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUi{
    self.isSearch = NO;
    self.viewSearch.layer.borderWidth = 0.7;
    self.viewSearch.layer.borderColor = RGB(221, 221, 221).CGColor;
    
    self.btnFreeDesign.layer.cornerRadius = 4;
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backButton setImage:[UIImage imageNamed:@"fanhui"] forState: UIControlStateNormal];
    [backButton addTarget:self action:@selector(GoLast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

-(void)GoLast{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTapOfKeyboard{
    //添加点击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.numberOfTapsRequired = 1;  // 只需要点击非文字输入区域就会响应
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];
}


- (void) btnGoCaseDetail:(UIButton *)sender{
    CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
   // view.albumId = exampleData.albumId;
    [self.navigationController pushViewController:view animated:YES];
}

//点击事件
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

    if(!self.isSearchNoData){
        return _storeList.count;
    }else{
        return _exampleList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if(!self.isSearchNoData){
        static NSString *identity = @"CompanyTableViewCell";
        CompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identity];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Store *storeData = _storeList[indexPath.row];
        [cell loadData:storeData];
        cell.btnCaseOne.tag = indexPath.row;
        [cell.btnCaseOne addTarget:self action:@selector(btnGoCaseDetailOne:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnCaseTwo.tag = indexPath.row;
        [cell.btnCaseTwo addTarget:self action:@selector(btnGoCaseDetailTwo:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnCaseThree.tag = indexPath.row;
        [cell.btnCaseThree addTarget:self action:@selector(btnGoCaseDetailThree:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        
        static NSString * searchNearbyTableViewCell = @"SearchNearbyTableViewCell";
        SearchNearbyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchNearbyTableViewCell];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"SearchNearbyTableViewCell" bundle:nil] forCellReuseIdentifier:searchNearbyTableViewCell];
            cell = [tableView dequeueReusableCellWithIdentifier:searchNearbyTableViewCell];
        }
        BuildingExample *XiaoquData = _exampleList[indexPath.row];
        cell.labelnName.text = XiaoquData.address;
        //cell.labelAddress.text = storeData.address;
        cell.labelCaseNum.text = [NSString stringWithFormat:@"%@",XiaoquData.picCount];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if(!self.isSearchNoData){
        Store *storeData = _storeList[indexPath.row];
        NSInteger num = storeData.albumList.count;
        if (num == 0) {
            return 100;
        }else{
            return 200;
        }

    }else{
         return 65;;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isSearchNoData){
        Store *storeData = _storeList[indexPath.row];
        CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
         view.storeId = storeData.storeId;
        [self.navigationController pushViewController:view animated:YES];
    }else{
         BuildingExample *XiaoquData = _exampleList[indexPath.row];
        AllCaseViewController *view = [[AllCaseViewController alloc] initWithNibName:@"AllCaseViewController" bundle:nil];
        view.isAllCase = @"1";
        view.storeId = XiaoquData.storeId;
        view.storeName = XiaoquData.albumName;
       // [self.navigationController pushViewController:view animated:YES];

    }
}


- (void) btnGoCaseDetailOne:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
    NSDictionary *albumDic = storeData.albumList[0];
    [self goCaseDetail:albumDic];
}

- (void) btnGoCaseDetailTwo:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
    NSDictionary *albumDic = storeData.albumList[1];
    [self goCaseDetail:albumDic];
}


- (void) btnGoCaseDetailThree:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
    NSDictionary *albumDic = storeData.albumList[2];
    [self goCaseDetail:albumDic];
}

- (void) goCaseDetail:(NSDictionary*)albumDic{
    CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
    view.albumId = [albumDic[@"album_id"] description];
    NSLog(@"77777");
    [self.navigationController pushViewController:view animated:YES];
}

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSearch:(id)sender {

    if ([CommonUtil isEmpty:self.textFieldContent.text ]) {
        [self.view makeToast:@"搜索内容不能为空"];
        return;
    }
    [self seachExample:self.textFieldContent.text];
}

//检索店铺
- (void)seachStore:(NSString *)keyword {
    //default_order综合排序(默认),appoint_ascappoint_desc 预约最多 ,dp_descdp_asc 点评权重数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@"110900" forKey:@"city_id"];
    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:@"2083" forKey:@"cate_id"];
    [parameters setValue:@"list" forKey:@"type"];
    [parameters setValue:@"1" forKey:@"add_example"];
    [parameters setValue:@"default_order" forKey:@"sort_type"];
    [parameters setValue:@"100" forKey:@"app_id"];
    [parameters setValue:@10 forKey:@"size"];
   // [parameters setValue:[NSNumber numberWithInteger:0] forKey:@"page"];
//    [parameters setValue:@"09f8dcf852d1254c490342c1a05db1dc" forKey:@"app_secret"];
    __weak typeof(self) weakSelf = self;
    [SearchStoreRequest requestWithParameters:parameters
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:self.view
                            withCancelSubject:[SearchStoreRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                    NSLog(@"******==%@",request.resultDic);
                                    NSArray *array = [request.resultDic objectForKey:@"store"];
                                    if (array.count > 0) {
                                        [weakSelf.storeList addObjectsFromArray:array];
                                    }

                                   
                                    if (weakSelf.storeList.count == 0) {
                                        self.isSearchNoData = NO;
                                        [self seachStore:@""];
                                    }else{
                                        self.isSearchNoData = YES;
                                    }
                                
                                    if ([CommonUtil isEmpty:keyword ]) {
                                        self.isSearchNoData = NO;
                                    }
                                    if(!self.isSearchNoData){
                                        self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 170);
                                        self.tableView.tableHeaderView = self.viewHead;
                                        self.viewGray.hidden = YES;
                                        self.viewSearchHeight.constant = 60;
                                        self.tableViewBottom.constant = 65;
                                    }else{
                                        self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 0);
                                        self.tableView.tableHeaderView = nil;
                                        self.viewGray.hidden = NO;
                                        self.viewSearchHeight.constant = 60;
                                        self.tableViewBottom.constant = 0;
                                    }
                                    
                                     [_tableView reloadData];
                                
                                }
                                
                               
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                               
                                
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                        
                                  
                              }];
}
//检索案例
- (void)seachExample:(NSString *)keyword {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *str=[NSString stringWithFormat:@"%f,%f",self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude];
     [parameters setValue:@"110900" forKey:@"city_id"];
    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:str forKey:@"latlng"];
    [parameters setValue:@"address_id" forKey:@"group_by"];
//    [parameters setValue:@"0" forKey:@"page"];
//    [parameters setValue:@"20" forKey:@"size"];
    
    __weak typeof(self) weakSelf = self;
    [GetExampleListRequest requestWithParameters:parameters
                                   withCacheType:DataCacheManagerCacheTypeMemory
                               withIndicatorView:nil
                               withCancelSubject:[GetExampleListRequest getDefaultRequstName]
                                  onRequestStart:nil
                               onRequestFinished:^(CIWBaseDataRequest *request) {
                                   
                                   if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                       NSLog(@"****==%@",request.resultDic);
                                       NSArray *array = [request.resultDic objectForKey:@"example"];
                                       if (array.count > 0) {
                                           [weakSelf.exampleList addObjectsFromArray:array];
                                       }
                                       YMPointAnnotation *annotation = [[YMPointAnnotation alloc] init];
                                       for (int i=0; i<_exampleList.count; i++) {
                                           
                                           BuildingExample *exam=_exampleList[i];
                                           NSLog(@"%f,%f",[exam.lat floatValue], [exam.lng floatValue]);
                                       CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([exam.lat floatValue], [exam.lng floatValue]);
                                       annotation.coordinate = coordinate;
                                       //annotation.poi = poi;
                                       [_mapView addAnnotation:annotation];
}
//                                       [_tableView reloadData];
                                       if (weakSelf.exampleList.count == 0) {
                                           self.isSearchNoData = NO;
                                           [self seachStore:@""];
                                       }else{
                                           self.isSearchNoData = YES;
                                       }
                                       
                                       if ([CommonUtil isEmpty:keyword ]) {
                                           self.isSearchNoData = NO;
                                       }
                                       if(!self.isSearchNoData){
                                           self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 130);
                                           self.tableView.tableHeaderView = self.viewHead;
                                           self.viewGray.hidden = YES;
                                           self.viewSearchHeight.constant = 60;
                                           self.tableViewBottom.constant = 65;
                                       }else{
                                           self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 0);
                                           self.tableView.tableHeaderView = nil;
                                           self.viewGray.hidden = NO;
                                           self.viewSearchHeight.constant = 60;
                                           self.tableViewBottom.constant = 0;
                                       }
                                       
                                       [_tableView reloadData];


                               }
                               }
                               onRequestCanceled:^(CIWBaseDataRequest *request) {
                                  
                               }
                                 onRequestFailed:^(CIWBaseDataRequest *request) {
                                     
                                 }];
}

@end
