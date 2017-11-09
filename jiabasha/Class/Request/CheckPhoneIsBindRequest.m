//
//  CheckPhoneIsBindRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CheckPhoneIsBindRequest.h"

@implementation CheckPhoneIsBindRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/check_phone_is_bind";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];

    }
}

@end
