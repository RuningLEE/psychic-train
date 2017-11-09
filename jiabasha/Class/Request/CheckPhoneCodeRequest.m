//
//  CheckPhoneCodeRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "CheckPhoneCodeRequest.h"

@implementation CheckPhoneCodeRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/sms/check_phone_code";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        //NSDictionary *data = [self.resultDic objectForKey:@"data"];
    }
}

@end
