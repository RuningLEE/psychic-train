//
//  CancelGetCoupon.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CancelGetCoupon.h"

@implementation CancelGetCoupon

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/coupon/cancel";
}

@end
