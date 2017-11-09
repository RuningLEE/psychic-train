//
//  LoginByCodeRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "LoginByCodeRequest.h"
#import "CommonUtils.h"

@implementation LoginByCodeRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/login_by_code";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        //保存用户信息
        UserInfo *userInfo = [[UserInfo alloc] initWithDataDic:data];
        DATA_ENV.userInfo = userInfo;
        
        [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
        [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    }
}

@end
