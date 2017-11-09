//
//  GetCouponDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetCouponDetailRequest.h"
#import "CouponModel.h"

@implementation GetCouponDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/coupon/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *dicCoupon = [self.resultDic objectForKey:@"data"];
        CouponModel *couponModel = [[CouponModel alloc]initWithDataDic:dicCoupon];
        [self.resultDic setValue:couponModel forKey:@"couponModel"];
    }
}

@end
