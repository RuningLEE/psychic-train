//
//  SwitchCityViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SwitchCityViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GetCityListRequest.h"
#import "UIColor-Expanded.h"

@interface SwitchCityViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    __weak IBOutlet UILabel *_labelSelectedCity;
    __weak IBOutlet UITableView *_tableViewCity;
}

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, copy) NSString *localCity;

@end

@implementation SwitchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _labelSelectedCity.text = DATA_ENV.city.sname;
    
    //不用定位，删除
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
    
    [self getCityListRequest];
}

- (void)getCityListRequest
{
    __weak typeof(self) weakSelf = self;
    [GetCityListRequest requestWithParameters:nil// 参数
                            withIndicatorView:self.view//网络加载视图加载到某个view
                               onRequestStart:^(CIWBaseDataRequest *request) {}
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if([request.errCode isEqualToString:RESPONSE_OK]){
                                    NSArray *cityList = [request.resultDic objectForKey:KEY_MODEL];
                                    
                                    if(cityList.count){
                                        //提取第一个城市
                                        weakSelf.cityList = cityList;
                                        //DATA_ENV.city = [cityList firstObject];
                                        [_tableViewCity reloadData];
                                    }
                                }
                            }
     
                            onRequestCanceled:^(CIWBaseDataRequest *request) {}
                              onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            [_tableViewCity reloadData];
        }
    }];
}

#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *labelCity = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        labelCity = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 50, 20)];
        labelCity.font = [UIFont systemFontOfSize:15];
        labelCity.tag = 999;
        [cell.contentView addSubview:labelCity];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, .5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [cell.contentView addSubview:line];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    } else {
        labelCity = [cell.contentView viewWithTag:999];
    }
    
    City *city = [self.cityList objectAtIndex:indexPath.row];
    labelCity.text = city.sname;
    
//    if ([city.name isEqualToString:self.localCity]) {
//        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#fcf5ff"];
//        labelCity.textColor = [UIColor colorWithHexString:@"#601986"];
//    } else {
//        cell.contentView.backgroundColor = [UIColor whiteColor];
        labelCity.textColor = [UIColor colorWithHexString:@"#666666"];
//    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView.frame = cell.frame;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#fcf5ff"];
    labelCity.highlightedTextColor = [UIColor colorWithHexString:@"#601986"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    City *city = [self.cityList objectAtIndex:indexPath.row];
    
    if ([city.sname isEqualToString:DATA_ENV.city.sname]) {
        //没变
    } else {
        DATA_ENV.city = city;
        
        //发送城市切换的广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
