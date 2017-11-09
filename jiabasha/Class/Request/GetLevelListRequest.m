//
//  GetLevelListRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetLevelListRequest.h"

@implementation GetLevelListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/my/user_level";
}

@end
