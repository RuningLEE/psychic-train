//
//  EvaluateOrderUpdateRequest.m
//  jiabasha
//
//  Created by LY on 2017/3/18.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EvaluateOrderUpdateRequest.h"

@implementation EvaluateOrderUpdateRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/dp/update";
}

@end
