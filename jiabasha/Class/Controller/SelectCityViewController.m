//
//  SelectCityViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SelectCityViewController.h"
#import "GetCityListRequest.h"
#import "City.h"
#import "UIColor-Expanded.h"
#import <CoreLocation/CoreLocation.h>
#import "JZMainTabController.h"
#import "AppDelegate.h"

@interface SelectCityViewController ()<CLLocationManagerDelegate> {
    
    __weak IBOutlet UIView *_viewCityContainer;
    __weak IBOutlet NSLayoutConstraint *heightForContainer;
}

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, copy) NSString *localCity;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if([CLLocationManager locationServicesEnabled]) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        
//        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            NSLog(@"requestAlwaysAuthorization");
//            [self.locationManager requestAlwaysAuthorization];
//        }
//        
//        //开始定位，不断调用其代理方法
//        [self.locationManager startUpdatingLocation];
//    }
    
    //默认数据
    NSArray *cities = @[@{@"host": @"sh.jiehun.com.cn", @"id":@"310900", @"mark":@"sh", @"name":@"上海市", @"sname":@"上海"},
                        @{@"host": @"gz.jiehun.com.cn", @"id":@"440100", @"mark":@"gz", @"name":@"广州市", @"sname":@"广州"},
                        @{@"host": @"tj.jiehun.com.cn", @"id":@"120300", @"mark":@"tj", @"name":@"天津市", @"sname":@"天津"},
                        @{@"host": @"hz.jiehun.com.cn", @"id":@"330100", @"mark":@"hz", @"name":@"杭州市", @"sname":@"杭州"}];
    self.cityList = [City createModelsArrayByResults:cities];
    [self displayCityList];
    
    [self getCityListRequest];
}

- (void)getCityListRequest
{
    __weak typeof(self) weakSelf = self;
    [GetCityListRequest requestWithParameters:nil// 参数
                            withIndicatorView:nil
                               onRequestStart:^(CIWBaseDataRequest *request) {}
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if([request.errCode isEqualToString:RESPONSE_OK]){
                                    NSArray *cityList = [request.resultDic objectForKey:KEY_MODEL];
                                    
                                    if(cityList.count){
                                        weakSelf.cityList = cityList;
                                        //DATA_ENV.city = [cityList firstObject];
                                        [weakSelf displayCityList];
                                    }
                                }
                            }

                            onRequestCanceled:^(CIWBaseDataRequest *request) {}
                              onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)displayCityList {
    [_viewCityContainer removeAllSubviews];

    for (int i = 0;i< self.cityList.count; i++) {
        City *city = [self.cityList objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i % 3 * 95, i / 3 * (36 + 12), 85, 36);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:city.sname forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = .5;

//        if ([city.name isEqualToString:self.localCity]) {
//            [button setTitleColor:[UIColor colorWithHexString:@"#601986"] forState:UIControlStateNormal];
//            button.layer.borderColor = [UIColor colorWithHexString:@"#601986"].CGColor;
//            [button setBackgroundColor:[UIColor colorWithHexString:@"#fcf5ff"]];
//        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#601986"] forState:UIControlStateHighlighted];
            button.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
//        }

        [_viewCityContainer addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(btnCityClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button addTarget:self action:@selector(buttonCityHighlighted:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonCityNormal:) forControlEvents:UIControlEventTouchUpOutside];
    }
    
    heightForContainer.constant = (self.cityList.count + 2) / 3 * (36 + 12) - 12;
}

//  button普通状态下的背景色
- (void)buttonCityNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
}
//  button高亮状态下的背景色
- (void)buttonCityHighlighted:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#fcf5ff"]];
    sender.layer.borderColor = [UIColor colorWithHexString:@"#601986"].CGColor;
}

- (void)btnCityClicked:(UIButton *)button {
    [self buttonCityNormal:button];
    
    City *city = [self.cityList objectAtIndex:button.tag];
    DATA_ENV.city = city;
    
    JZMainTabController *mainControler  = [[JZMainTabController alloc] initWithNibName:@"JZMainTabController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.MyTabBarController = mainControler;
    
    self.navigationController.viewControllers = @[mainControler];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
    
    //反地理编码
    [self reverseGeocoder:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        
    }
}

- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
        
            self.localCity = [[placemark addressDictionary] objectForKey:@"City"];
            [self displayLocalCity];
        }
    }];  
}

- (void)displayLocalCity {
    if (self.cityList.count == 0 || self.localCity.length == 0) {
        return;
    }
    
    [self displayCityList];
}
@end
