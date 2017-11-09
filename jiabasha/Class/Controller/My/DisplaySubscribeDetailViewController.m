//
//  DisplaySubscribeDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DisplaySubscribeDetailViewController.h"
#import "GetDisplaySubscribeDetailRequest.h"
#import "DisplaySubscribeModel.h"
#import "CancelDisplaySubscribeRequest.h"

@interface DisplaySubscribeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubscribe;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) DisplaySubscribeModel *displayModel;
@property (weak, nonatomic) IBOutlet UIImageView *CompanyImage;
@property (weak, nonatomic) IBOutlet UILabel *CompanyName;
@property (weak, nonatomic) IBOutlet UILabel *ShowName;


@end

@implementation DisplaySubscribeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonSubscribe.layer.cornerRadius = 0;
    _buttonSubscribe.layer.masksToBounds = YES;
    //请求接口
    [self getDisplaySubscribeDetailRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDisplaySubscribeDetailRequest{
/*
 "order_id": "1096834","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"order_id", nil];
    [GetDisplaySubscribeDetailRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:self.view withCancelSubject:[GetDisplaySubscribeDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            NSLog(@"******==%@",request.resultDic);
            NSString *urlStr=request.resultDic[@"data"][@"store"][@"logo"];
            
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            _CompanyImage.image=[UIImage imageWithData:data];
           _CompanyName.text=request.resultDic[@"data"][@"store"][@"store_name"];
            _ShowName.text=request.resultDic[@"data"][@"expo"][@"expo_name"];
            _displayModel = (DisplaySubscribeModel *)[request.resultDic objectForKey:@"DisModel"];
            [self setValueForControl];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

//值设定
- (void)setValueForControl{
    _labelNum.text = [NSString stringWithFormat:@"   %@",_displayModel.reserveId];
    _labelDate.text = [NSString stringWithFormat:@"   %@",[CommonUtil getDateStringFromtempString:_displayModel.createTime]];
    _labelDisplayDate.text = [NSString stringWithFormat:@"   %@",[CommonUtil getDateStringFromtempString:_displayModel.appointTime]];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelSubscribe:(id)sender {
    if ([self.displayModel.reserveType isEqualToString:@"1"] || [self.displayModel.reserveType isEqualToString:@"2"] || [self.displayModel.reserveType isEqualToString:@"3"] || [self.displayModel.reserveType isEqualToString:@"4"]) {
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"order_id",@"取消预约",@"extra",DATA_ENV.userInfo.user.uid,@"op_uid", nil];
        [CancelDisplaySubscribeRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory
                                           withIndicatorView:self.view withCancelSubject:[CancelDisplaySubscribeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
                                               
                                           } onRequestFinished:^(CIWBaseDataRequest *request) {
                                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                                   [self.view makeToast:@"成功取消预约"];
                                               } else {
                                                   [self.view makeToast:@"取消预约失败"];
                                               }
                                           } onRequestCanceled:^(CIWBaseDataRequest *request) {
                                               
                                           } onRequestFailed:^(CIWBaseDataRequest *request) {
                                               [self.view makeToast:@"取消预约失败"];
                                           }];

    } else {
        [self.view makeToast:@"取消预约失败" duration:1 position:CSToastPositionCenter];
    }
//    [self.view makeToast:@"取消预约"];
    /*
     "order_id": "1096834","uid": "12743702","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
}

@end
