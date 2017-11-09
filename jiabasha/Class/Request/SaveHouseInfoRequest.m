//
//  SaveHouseInfoRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SaveHouseInfoRequest.h"

@implementation SaveHouseInfoRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/house/info/save";
}

@end
