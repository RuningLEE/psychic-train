//
//  AppInstallRequest.m
//  HunBaSha
//
//  Created by GarrettGao on 16/6/13.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "AppInstallRequest.h"
#import "CIWKeyChain.h"
#import <AdSupport/ASIdentifierManager.h>
#import "Client.h"
@implementation AppInstallRequest

+ (void)installRequest
{
    
    if(!DATA_ENV.city.cityId){
        return;
    }
    
    if(DATA_ENV.client){//第一次下载安装继续执行
        return;
    }
    
    [AppInstallRequest requestWithParameters:[self getParameter]
                          withIndicatorView:nil
                          withCancelSubject:[AppInstallRequest getDefaultRequstName]
                             onRequestStart:^(CIWBaseDataRequest *request) {}
                          onRequestFinished:^(CIWBaseDataRequest *request) {

                          }
                          onRequestCanceled:^(CIWBaseDataRequest *request) {

                          }
                            onRequestFailed:^(CIWBaseDataRequest *request) {
                            }];
}


+ (NSMutableDictionary *)getParameter
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *machine_id = [CIWKeyChain getAppOnlyIdentifierOnDevice];//app唯一表示
    NSString *machine_name = [[UIDevice currentDevice] model];
    NSString *machine_version = [UIDevice getCurrentDeviceModel];
//    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //设备的唯一标识
    [params setObject:machine_id forKey:@"machine_id"];
    //客户端机型（品牌）
    [params setObject:machine_name forKey:@"machine_name"];
    //客户端机型的版本
    [params setObject:machine_version forKey:@"machine_version"];
    //客户端的os
    [params setObject:[[UIDevice currentDevice] systemName] forKey:@"os_name"];
    //客户端的os版本号
    [params setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
//    //广告符
//    if(idfa)
//        [params setObject:idfa forKey:@"ios_idfa"];
    //安装渠道
    [params setObject:@"AppStore" forKey:@"app_channel"];

    return params;
}

- (CIWRequestMethod)getRequestMethod{
    return CIWRequestMethodPost;
}


- (NSString *)getURI{
    
    //注册app
//    return @"/common/app/_install";
    return @"/common/app/get";
}

- (void)processResult{
    
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        
        NSString *data = self.resultDic[@"data"];
        if([data isKindOfClass:[NSString class]]){
            
            Client *client = [[Client alloc] init];
            client.clientId = data;
            DATA_ENV.client = client;//clinet信息保存到本地
            NSLog(@"注册app接口返回结果:%@",DATA_ENV.client);
            
            //IOS设备绑定TOKEN
//            [BindTokenAndClientIdRequest bindRequest];
        }
    }
}
@end
