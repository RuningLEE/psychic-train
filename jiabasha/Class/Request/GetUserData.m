//
//  GetUserData.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetUserData.h"

@implementation GetUserData

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/my/account/info";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        
    }
}

@end
