//
//  FitmentViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "FitmentViewController.h"
#import "EditFitmentViewController.h"
#import "GetFitmentDetailRequest.h"
#import "MineFitmentModel.h"

@interface FitmentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelCity;
@property (weak, nonatomic) IBOutlet UILabel *labelEstate;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@property (weak, nonatomic) IBOutlet UILabel *labelHousetype;
@property (strong, nonatomic) MineFitmentModel *fitmentModel;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *demandId;
@end

@implementation FitmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self getFitmentDetailRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _labelCity.text = _fitmentModel.demandData.city;
    _labelEstate.text = _fitmentModel.demandData.block;
    _labelArea.text = _fitmentModel.demandData.area;
    _labelHousetype.text = _fitmentModel.demandData.houseType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)getFitmentDetailRequest{
    /*
     "city_id": "110900","cate_id":"2083","access_token": "NgDXJv3Ua8Wt98B5oHDGeG8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8ehSWfOTQaIX/p8t1rH/Dcn4Xm3/9x2PWpPXNLfh9lnIsFMR7/5M=","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"110900",@"city_id",@"2083",@"cate_id",@"NgDXJv3Ua8Wt98B5oHDGeG8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8ehSWfOTQaIX/p8t1rH/Dcn4Xm3/9x2PWpPXNLfh9lnIsFMR7/5M=",@"access_token",@"100",@"app_id",@"09f8dcf852d1254c490342c1a05db1dc",@"app_secret", nil];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_fitmentModel.cateId,@"cate_id", nil];
    [GetFitmentDetailRequest requestWithParameters:nil withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetFitmentDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            _storeName = [[[[request.resultDic objectForKey:@"data"] objectForKey:@"demand_data"] objectForKey:@"store_name"] description];
            _demandId = [[[[request.resultDic objectForKey:@"data"] objectForKey:@"demand_data"] objectForKey:@"demand_id"] description];
            _fitmentModel = (MineFitmentModel *)[request.resultDic objectForKey:@"fitmentModel"];
            [self setUp];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editDetail:(id)sender {
    EditFitmentViewController *editFitment = [[EditFitmentViewController alloc]init];
    editFitment.demandId = _demandId;
    editFitment.storeName = _storeName;
    editFitment.fitMentModel = _fitmentModel;
    [self.navigationController pushViewController:editFitment animated:YES];
}

@end
