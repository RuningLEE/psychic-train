//
//  ReserveFitmentRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ReserveFitmentRequest.h"

@implementation ReserveFitmentRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/zx/update";
}

@end
