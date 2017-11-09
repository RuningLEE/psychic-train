//
//  BackCrashRequest.m
//  jiabasha
//
//  Created by LY on 2017/3/18.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BackCrashRequest.h"

@implementation BackCrashRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/update";
}

@end
