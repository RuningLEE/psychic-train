//
//  LoginRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "LoginRequest.h"
#import "CommonUtils.h"

@implementation LoginRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/login";
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
