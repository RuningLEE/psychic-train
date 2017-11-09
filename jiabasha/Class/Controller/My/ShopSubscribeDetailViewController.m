//
//  ShopSubscribeDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShopSubscribeDetailViewController.h"
#import "GetStoreSubscribeDetailRequest.h"
#import "SubscribeStore.h"
#import "CancelStoreSubscribeRequest.h"
#import "ReserveStoreSubscribeRequest.h"
#import "CompanyHomeViewController.h"
@interface ShopSubscribeDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelSubTime;
@property (weak, nonatomic) IBOutlet UILabel *labelArriveTime;
@property (strong, nonatomic) IBOutlet UIView *selectDateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;
@property (strong, nonatomic) NSString* arriveDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonModify;
@property (strong, nonatomic) SubscribeStore *storeModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewShop;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName;
@property (weak, nonatomic) IBOutlet UILabel *labelShopDetailName;
@property (assign, nonatomic) NSTimeInterval timestamp;
@property (weak, nonatomic) IBOutlet UIView *tiaozhuanView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//new
@property(nonatomic,strong)NSString *companyId;
@end

@implementation ShopSubscribeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NextView)];
    
    self.tiaozhuanView.userInteractionEnabled=YES;
    [self.tiaozhuanView addGestureRecognizer:tapRecognizerWeibo];
    
    [self setUp];
    //详细数据接口
    [self getStoreSubscribeDetailRequest];
    // Do any additional setup after loading the view from its nib.
}
-(void)NextView{
    NSLog(@"ud==%@",_companyId);
    CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
    view.storeId = _companyId;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)setUp{
    _contentViewWidthConstant.constant = kScreenWidth;
    _contentViewHeightConstant.constant = kScreenHeight - 64;
    
    _buttonCancel.layer.borderColor = RGB(96, 24, 134).CGColor;
    _buttonCancel.layer.borderWidth = 1;
    _buttonCancel.layer.cornerRadius = 3;
    _buttonCancel.layer.masksToBounds = YES;
    _buttonModify.layer.cornerRadius = 3;
    _buttonModify.layer.masksToBounds = YES;
    
    //do something until display
    _selectDateView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:_selectDateView];
    _selectDateView.hidden = YES;
    _pickerDate.datePickerMode = UIDatePickerModeDate;
    [_pickerDate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [_pickerDate addTarget:self action:@selector(datechange:) forControlEvents:UIControlEventAllEvents];
    //初始化时间
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* datestring = [dateformatter stringFromDate:date];
    _arriveDate = datestring;
}

- (void)getStoreSubscribeDetailRequest{
//params - {"reserve_id": "1096834","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_reserveId,@"reserve_id",nil];
    [GetStoreSubscribeDetailRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:self.view withCancelSubject:[GetStoreSubscribeDetailRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"&&&&==%@",request.resultDic);
            _companyId=request.resultDic[@"data"][@"store"][@"store_id"];
            _storeModel = (SubscribeStore *)[request.resultDic objectForKey:@"storeModel"];
            [self setValueForControl];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

//值设定
- (void)setValueForControl{
    [_imageviewShop sd_setImageWithURL:[NSURL URLWithString:_storeModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelShopName.text = _storeModel.store.storeName;
//    _labelShopDetailName.text = _storeModel.
    _labelNum.text = [NSString stringWithFormat:@"   %@",_storeModel.reserveId];
    _labelSubTime.text = [NSString stringWithFormat:@"   %@",[CommonUtil getDateStringFromtempString:_storeModel.createTime]];
    _labelArriveTime.text = [NSString stringWithFormat:@"   %@",[CommonUtil getDateStringFromtempString:_storeModel.appointTime]];
    NSString *state=[NSString stringWithFormat:@"%@",_storeModel.reserveStatus];
    if([state isEqualToString:@"0"]){
       _stateLabel.text=@"您的预约已取消";
    }else if ([state isEqualToString:@"1"]){
        _stateLabel.text=@"商家已接到您的预约，请静候安排";

        
    }else if ([state isEqualToString:@"2"]){
        _stateLabel.text=@"您的预约已安排";

    }else if ([state isEqualToString:@"3"]){
        _stateLabel.text=@"已到店";

    }else if ([state isEqualToString:@"4"]){
        _stateLabel.text=@"您未赴约";

    }else if ([state isEqualToString:@"5"]){
        _stateLabel.text=@"商家已取消预约";

    }
}

- (void)datechange:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString* datestring = [dateformatter stringFromDate:date];
    _arriveDate = datestring;
    NSDate *d = [dateformatter dateFromString:datestring];              // 转换Date类型
    _timestamp = [d timeIntervalSince1970]*1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectDate:(id)sender {
    _selectDateView.hidden = NO;
}

- (IBAction)modifySubscribe:(id)sender {
    /*
     "reserve_id": "1096834","appoint_time":"2016-01-02 00:00:01","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_reserveId,@"reserve_id",[NSString stringWithFormat:@"%.0f",_timestamp],@"appoint_time", nil];
    [ReserveStoreSubscribeRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:self.view withCancelSubject:[ReserveStoreSubscribeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
//            KKLog(@"%@",request.resultDic);
            [self.view makeToast:@"成功修改预约"];
        } else {
            [self.view makeToast:@"修改预约失败"];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [self.view makeToast:@"修改预约失败"];
    }];
    
}

- (IBAction)cancelSubscribe:(id)sender {
    /*
     "reserve_id": "1096834","reserve_status":"0","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    if ([_storeModel.reserveStatus isEqualToString:@"1"] || [_storeModel.reserveStatus isEqualToString:@"2"]) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_reserveId,@"reserve_id", nil];
        [CancelStoreSubscribeRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:self.view withCancelSubject:[CancelStoreSubscribeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
            
        } onRequestFinished:^(CIWBaseDataRequest *request) {
            if ([request.errCode isEqualToString:RESPONSE_OK]) {
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
    
}

- (IBAction)saveArriveDate:(id)sender {
    _labelArriveTime.text = [NSString stringWithFormat:@"   %@",_arriveDate];
    _selectDateView.hidden = YES;
}

- (IBAction)hideSelectView:(id)sender {
    _selectDateView.hidden = YES;
}
@end
