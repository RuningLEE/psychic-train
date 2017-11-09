//
//  EvaluateOrderRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EvaluateOrderRequest.h"

@implementation EvaluateOrderRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/dp";
}

@end
