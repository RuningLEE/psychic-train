//
//  MyOrderDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "EvlauateOrderViewController.h"
#import "GetOrderDetailRequest.h"
#import "OrderModel.h"
#import "BackCrashViewController.h"
@interface MyOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelSubscribeDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPhonNum;
@property (strong, nonatomic) OrderModel *orderModel;
@property (strong, nonatomic) IBOutlet UIView *NoyifyView;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UIButton *is_Di;
@property(nonatomic,strong) UIView *bootmVeiw;
@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _bootmVeiw=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.view addSubview:_bootmVeiw];
    UIButton *fanxian=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bootmVeiw.frame.size.width/2, 44)];
    [fanxian addTarget:self action:@selector(GoNextView) forControlEvents:UIControlEventTouchUpInside];
    fanxian.backgroundColor=[UIColor colorWithRed:241/255.0 green:228/255.0 blue:245/255.0 alpha:1.0];
    [fanxian setTitle:_buttonTitle forState: UIControlStateNormal];
    UIButton *dianP=[[UIButton alloc]initWithFrame:CGRectMake(_bootmVeiw.frame.size.width/2, 0, _bootmVeiw.frame.size.width/2, 44)];
    [dianP addTarget:self action:@selector(DpView) forControlEvents:UIControlEventTouchUpInside];
    dianP.backgroundColor=[UIColor colorWithRed:86/255.0 green:21/255.0 blue:122/255.0 alpha:1.0];
    [dianP setTitle:_dpTitle forState:UIControlStateNormal];
    [_bootmVeiw addSubview:fanxian];
    [_bootmVeiw addSubview:dianP];
    if([_buttonTitle isEqualToString:@""]){
        _bootmVeiw.hidden=YES;
    }else{
        _bootmVeiw.hidden=NO;
        _is_Di.hidden=YES;
    }
    _NoyifyView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _NoyifyView.hidden=YES;
    [self.view addSubview:_NoyifyView];
    [self getOrderDetailRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GoNextView{
    BackCrashViewController *vc=[[BackCrashViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Request
- (void)getOrderDetailRequest{
/*
 "order_id": "2087356","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"order_id", nil];
    [GetOrderDetailRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetOrderDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            //布局子控件
            _orderModel = [request.resultDic objectForKey:@"orderModel"];
            NSLog(@"*******==%@",request.resultDic);
            [self setup];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

- (void)setup{
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:_orderModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelCompany.text = _orderModel.store.storeName;
    _labelAddress.text = _orderModel.store.address;
    _labelNum.text = [NSString stringWithFormat:@"   %@",_orderModel.orderId];
    _labelSubscribeDate.text = [NSString stringWithFormat:@"   %@",[CommonUtil getDateStringFromtempString:_orderModel.reserveTime]];
    _labelPrice.text = [NSString stringWithFormat:@"   %@元",_orderModel.orderPrice];
    _labelPhonNum.text = [NSString stringWithFormat:@"   %@",_orderModel.phone];
    [_is_Di setTitle:_dpTitle forState:UIControlStateNormal];
   
}
-(void)DpView{
    EvlauateOrderViewController *evlauteController = [[EvlauateOrderViewController alloc]init];
    evlauteController.orderModel = _orderModel;
    if([_dpTitle isEqualToString:@"去点评"]){
        evlauteController.type=@"1";
    }else if ([_dpTitle isEqualToString:@"修改点评"]){
        evlauteController.type=@"2";
        evlauteController.remarkID=_remarkId;
    }
    [self.navigationController pushViewController:evlauteController animated:YES];
}
#pragma mark - ButtonClick
- (IBAction)evaluateAction:(id)sender {
//   BackCrashViewController *evlauteController = [[BackCrashViewController alloc]init];
//    //evlauteController.orderModel = _orderModel;
//    [self.navigationController pushViewController:evlauteController animated:YES];
    
    EvlauateOrderViewController *evlauteController = [[EvlauateOrderViewController alloc]init];
    evlauteController.orderModel = _orderModel;
    if([_dpTitle isEqualToString:@"去点评"]){
        evlauteController.type=@"1";
    }else if ([_dpTitle isEqualToString:@"修改点评"]){
        evlauteController.type=@"2";
        evlauteController.remarkID=_remarkId;
    }

    [self.navigationController pushViewController:evlauteController animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ConnectKefu:(UIButton *)sender {
    _NoyifyView.hidden=NO;
}
//telephone
- (IBAction)TelePhone:(id)sender {
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelPhone.text = @"0571-28198188";
    } else {
        _labelPhone.text = @"4000-365-520";
    }

    if (![CommonUtil isEmpty:_labelPhone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelPhone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
    _NoyifyView.hidden = YES;
}
- (IBAction)CancleView:(id)sender {
    _NoyifyView.hidden = YES;
}


@end
