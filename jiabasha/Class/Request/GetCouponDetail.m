//
//  GetCouponDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetCouponDetail.h"
#import "CouponModel.h"

@implementation GetCouponDetail

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
        NSArray *arrCoupon = [self.resultDic objectForKey:@"data"];
        NSArray *arrCouponModel = [CouponModel createModelsArrayByResults:arrCoupon];
        [self.resultDic setValue:arrCouponModel forKey:@"couponModel"];
    }
}

@end
