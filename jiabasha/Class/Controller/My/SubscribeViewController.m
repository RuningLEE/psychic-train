//
//  SubscribeViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeTableViewCell.h"
#import "CommonUnSubscribeViewController.h"
#import "FitmentViewController.h"
#import "ShopSubscribeViewController.h"
#import "DisplaySubscribeViewController.h"
#import "GetFitmentDetailRequest.h"
#import "MineFitmentModel.h"

@interface SubscribeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(246, 246, 246);
    [_tableView registerNib:[UINib nibWithNibName:@"SubscribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"subscribeCell"];
    _tableView.rowHeight = 50;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)getFitmentDetailRequest{
    /*
     "city_id": "110900","cate_id":"2083","access_token": "NgDXJv3Ua8Wt98B5oHDGeG8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8ehSWfOTQaIX/p8t1rH/Dcn4Xm3/9x2PWpPXNLfh9lnIsFMR7/5M=","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    //    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"110900",@"city_id",@"2083",@"cate_id",@"NgDXJv3Ua8Wt98B5oHDGeG8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8ehSWfOTQaIX/p8t1rH/Dcn4Xm3/9x2PWpPXNLfh9lnIsFMR7/5M=",@"access_token",@"100",@"app_id",@"09f8dcf852d1254c490342c1a05db1dc",@"app_secret", nil];
    [GetFitmentDetailRequest requestWithParameters:nil withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetFitmentDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            if ([CommonUtil isEmpty:[[[[request.resultDic objectForKey:@"data"] objectForKey:@"demand_data"] objectForKey:@"store_name"] description]]) {
                [self.view makeToast:@"暂无装修预约" duration:1 position:CSToastPositionCenter];
                return ;
            } else {
                FitmentViewController *fitment = [[FitmentViewController alloc]init];
                [self.navigationController pushViewController:fitment animated:YES];
            }
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeTableViewCell *subscribeCell = [tableView dequeueReusableCellWithIdentifier:@"subscribeCell"];
    if (indexPath.row == 0) {
        subscribeCell.labelTitle.text = @"装修预约";
    }else if (indexPath.row == 1){
        subscribeCell.labelTitle.text = @"店铺预约";

    }else if (indexPath.row == 2){
        subscribeCell.labelTitle.text = @"展会预约";

    }
    subscribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return subscribeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self getFitmentDetailRequest];
    }else if (indexPath.row == 1){
        ShopSubscribeViewController *shopController = [[ShopSubscribeViewController alloc]init];
        [self.navigationController pushViewController:shopController animated:YES];
    }else if (indexPath.row == 2){
        DisplaySubscribeViewController *displayController = [[DisplaySubscribeViewController alloc]init];
        [self.navigationController pushViewController:displayController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeTableViewCell *subscribeCell = [tableView cellForRowAtIndexPath:indexPath];
    subscribeCell.backgroundColor = RGB(252, 245, 255);
    subscribeCell.labelTitle.textColor = RGB(96, 25, 134);
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeTableViewCell *subscribeCell = [tableView cellForRowAtIndexPath:indexPath];
    subscribeCell.backgroundColor = [UIColor whiteColor];
    subscribeCell.labelTitle.textColor = RGBFromHexColor(333333);
}

@end
