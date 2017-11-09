//
//  GetUserData.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetUserDataRequest.h"

@implementation GetUserDataRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/my/info";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]||[@"OK" isEqualToString:self.errCode]){
        DATA_ENV.userInfo.user = [[User alloc]initWithDataDic:[self.resultDic objectForKey:@"data"]];
    }
}

@end
