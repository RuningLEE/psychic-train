//
//  MainViewController.m
//  JiaZhuangDemo
//
//  Created by GarrettGao on 2016/12/21.
//  Copyright © 2016年 HunBoHui. All rights reserved.
//

#import "MainViewController.h"
#import "GetCityListRequest.h"
#import "AppInstallRequest.h"
#import "PhoneNumberLoginRequest.h"

@interface MainViewController (){
    __weak IBOutlet UITextField *_textFieldUser;
    __weak IBOutlet UITextField *_textFiledPassWord;
    
    __weak IBOutlet UILabel *_labelContent;
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"这是一个Demo";
    _labelContent.hidden = YES;
    
    [self getCityListRequest];

}

- (void)getCityListRequest
{
    
    [GetCityListRequest requestWithParameters:nil// 参数
                          withIndicatorView:self.view//网络加载视图加载到某个view
//                          withCancelSubject:[GetCityListRequest getDefaultRequstName]//取消网络请求名称
                             onRequestStart:^(CIWBaseDataRequest *request) {}
                          onRequestFinished:^(CIWBaseDataRequest *request) {
                              
                              NSLog(@"请求结果:%@",request.resultDic);
                              
            
                              if([request.errCode isEqualToString:RESPONSE_OK]){
                                  NSArray *cityList = [request.resultDic objectForKey:KEY_MODEL];
                                  NSLog(@"解析之后的城市列表:%@",cityList);
                                  
                                  if(cityList.count){
                                      //提取第一个城市
                                      DATA_ENV.city = [cityList firstObject];
                                  }
                        
                                  // 注册app
                                  [AppInstallRequest installRequest];

                              }
                              
                          }
     
     
                          onRequestCanceled:^(CIWBaseDataRequest *request) {}
                            onRequestFailed:^(CIWBaseDataRequest *request) {}];
    
//    [GetCityListRequest cancelRequestWithCancelSubject:[GetCityListRequest getDefaultRequstName]];//取消某个请求
}



#pragma mark=========登录接口的处理=================
- (IBAction)LoginAction:(UIButton *)sender
{

    
    NSString *userNum = _textFieldUser.text;
    NSString *password=_textFiledPassWord.text;


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:userNum forKey:@"username"];
    [parameters setValue:[password md5]forKey:@"password"];
    [parameters setValue:@1 forKey:@"type"];

    [PhoneNumberLoginRequest requestWithParameters:parameters
                                 withIndicatorView:self.view
                                 withCancelSubject:[PhoneNumberLoginRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
                                     
                                 } onRequestFinished:^(CIWBaseDataRequest *request) {
                                     
                                     _labelContent.hidden = NO;
                                     
                                     if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                         User *user = DATA_ENV.userInfo.user;
                                         NSLog(@"登录成功\n%@",user);
                                         _labelContent.text = [NSString stringWithFormat:@"登录成功\n 用户名:%@\n用户ID:%@",user.uname,user.uid];
                                     }else{
                                         NSLog(@"登录异常:%@",request.resultDic);
                                         _labelContent.text = [NSString stringWithFormat:@"登录失败\n %@",request.resultDic];
                                     }
                                     
                                 } onRequestCanceled:^(CIWBaseDataRequest *request) {
                                     
                                 } onRequestFailed:^(CIWBaseDataRequest *request) {
                                     _labelContent.text = @"检查网络";
                                 }];
    
    
    
}

- (IBAction)onTestClicked:(id)sender {
    _textFieldUser.text = @"appdemo";
    _textFiledPassWord.text = @"Appdemo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
