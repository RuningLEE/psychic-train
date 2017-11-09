//
//  PhoneNumberLoginRequest.m
//  HunBaSha
//
//  Created by 张凯 on 16/6/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PhoneNumberLoginRequest.h"

@implementation PhoneNumberLoginRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/newaccount/_login";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        //保存用户信息
        UserInfo *userInfo = [[UserInfo alloc] initWithDataDic:data];
        DATA_ENV.userInfo = userInfo;
    }
}

@end
