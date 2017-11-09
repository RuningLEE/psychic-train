//
//  GetCouponList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetCouponList.h"
#import "CouponModel.h"

@implementation GetCouponList

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/coupon/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrCoupon = [[self.resultDic objectForKey:@"data"] objectForKey:@"list"];
        NSArray *arrCouponModel = [CouponModel createModelsArrayByResults:arrCoupon];
        [self.resultDic setValue:arrCouponModel forKey:@"arrCoupon"];
    }
}

@end
