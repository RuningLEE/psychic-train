//
//  RegisterRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "RegisterRequest.h"
#import "CommonUtils.h"

@implementation RegisterRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/register";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        //保存用户信息
        UserInfo *userInfo = [[UserInfo alloc] initWithDataDic:data];
        DATA_ENV.userInfo = userInfo;
        
        [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
        [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    }
}

@end
